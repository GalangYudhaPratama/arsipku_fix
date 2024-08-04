import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime_dart/mime_dart.dart';

import 'package:arsipku/models/booklist_model.dart';
import 'package:arsipku/providers/setting_provider.dart';
import 'package:provider/provider.dart';

class BookListProvider with ChangeNotifier {
  List<BooklistModel> _list = [
    // BookListModel(
    //   id: "1",
    //   title: "Judul 1",
    //   imagePath: "assets/book.png",
    // ),
    // BookListModel(
    //   id: "2",
    //   title: "Judul 2",
    //   imagePath: "assets/book.png",
    // ),
    // BookListModel(
    //   id: "3",
    //   title: "Judul 3",
    //   imagePath: "assets/book.png",
    // ),
  ];

  bool _isReading = false;
  bool _isCreating = false;

  List<BooklistModel> get list {
    return [...this._list];
  }

  bool get isReading {
    return this._isReading;
  }

  bool get isCreating {
    return this._isCreating;
  }

  Future<void> read(BuildContext context) async {
    this._isReading = true;
    final settingData = Provider.of<SettingProvider>(context, listen: false);
    String url =
        "${settingData.setting.apiHost}/perpus-api/booklist/${settingData.setting.userName}";
    http.Response res;
    try {
      final resTmp = await http.get(url as Uri);
      res = resTmp;
    } catch (e) {
      this._isReading = false;
      throw (e);
    }
    List<BooklistModel> bookListData = (json.decode(res.body)["data"] as List)
        .map((i) => BooklistModel.fromjson(i))
        .toList();
    this._list = bookListData;

    this._isReading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> create(
      BuildContext context, BooklistModel data) async {
    this._isCreating = true;
    notifyListeners();
    final settingData = Provider.of<SettingProvider>(context, listen: false);
    if (data == null || data.title == "") {
      Map<String, dynamic> resInvalid = new Map<String, dynamic>();
      resInvalid["statusCode"] = 400;
      resInvalid["message"] = "Input is not valid";
      this._isCreating = false;
      notifyListeners();
      return resInvalid;
    }

    List mimeStr = lookupMimeType(data.imageFile.path)!.split("/");

    var imageBytes = await data.imageFile.readAsBytes();
    var uri = Uri.parse(
        '${settingData.setting.apiHost}/perpus-api/booklist/${settingData.setting.userName}');
    var request = http.MultipartRequest('POST', uri)
      ..fields['title'] = data.title
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes,
          filename: Path.basename(data.imageFile.path),
          contentType: mediaType(mimeStr[0], mimeStr[1])));
    int statusCode;
    try {
      http.StreamedResponse res = await request.send();
      statusCode = res.statusCode;
      final String respStr = await res.stream.bytesToString();
      Map<String, dynamic> resDecoded = json.decode(respStr);
      resDecoded["statusCode"] = res.statusCode;
      this._isCreating = false;
      notifyListeners();
      return resDecoded;
    } catch (e) {
      Map<String, dynamic> resInvalid = new Map<String, dynamic>();
      resInvalid["statusCode"] = statusCode != null ? statusCode : 400;
      resInvalid["message"] = e.toString();
      this._isCreating = false;
      notifyListeners();
      return resInvalid;
    }
  }
}
