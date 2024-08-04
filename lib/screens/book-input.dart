import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:arsipku/models/booklist_model.dart';
import 'package:arsipku/providers/booklist_provider.dart';
import 'package:provider/provider.dart';
import 'package:snackbar/snackbar.dart';

import 'package:arsipku/providers/setting_provider.dart';

class BookInputScreenArguments {
  final String id;
  final String title;
  final String imagePath;
  BookInputScreenArguments(
      {required this.id, required this.title, required this.imagePath});
}

class BookInputScreen extends StatefulWidget {
  static const routeName = "/book-add";

  @override
  _BookInputScreenState createState() => _BookInputScreenState();
}

class _BookInputScreenState extends State<BookInputScreen> {
  String _title;
  bool _inputIsValid = false;
  bool _isInitialized;
  bool _isSubmitting = false;
  BookInputScreenArguments _args;

  String _apiHost = "";
  String _userName = "";

  File _image;
  final picker = ImagePicker();

  Future _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        this._setInputValid();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (this._isInitialized == null || this._isInitialized) {
      this._args = ModalRoute.of(context).settings.arguments;
      SettingProvider settingData =
          Provider.of<SettingProvider>(context, listen: false);
      this._apiHost = settingData.setting.apiHost;
      this._userName = settingData.setting.userName;
      if (this._args != null && this._args.id != null) {
        this._title = this._args.title;
      }

      this._setInputValid();
      this._isInitialized = true;
    }
    super.didChangeDependencies();
  }

  void _setInputValid() {
    this._inputIsValid =
        this._title != null && this._title != "" && this._image != null;
  }

  bool get inputIsValid {
    return this._inputIsValid;
  }

  Future<void> _submit(BuildContext submitContext) async {
    final BooklistModel inputData = new BooklistModel(
      id: null,
      title: this._title,
      imagePath: null,
      imageFile: this._image,
    );
    final BookListProvider booklistData =
        Provider.of<BookListProvider>(submitContext, listen: false);
    Map<String, dynamic> submitRes =
        await booklistData.create(submitContext, inputData);

    if (submitRes["statusCode"] != null && submitRes["statusCode"] == 200) {
      Navigator.pop(context, submitRes["statusCode"]);
    } else {
      Scaffold.of(submitContext)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
                "Error \n- Status: ${submitRes["statusCode"]} \n- Message: ${submitRes["message"]}"),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.redAccent.shade400,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCreating = context.watch<BookListProvider>().isCreating;
    return Scaffold(
      appBar: AppBar(
        title: this._args == null || this._args.id == null
            ? const Text("Tambah Buku")
            : const Text("Edit Buku"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: this._title,
                  onChanged: (v) {
                    setState(() {
                      this._title = v;
                      this._setInputValid();
                    });
                  },
                ),
                SizedBox(height: 10),
                ButtonActivateIntent.icon(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                  label: Text("Pick an Image"),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: this._image == null
                      ? Container()
                      : Image(
                          image: FileImage(this._image),
                          width: 230,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 10),
                Builder(builder: (BuildContext submitContext) {
                  return RaisedButton(
                    child: Text("Simpan"),
                    color: Colors.lightBlueAccent,
                    onPressed: !this.inputIsValid || isCreating
                        ? null
                        : () {
                            this._submit(submitContext);
                          },
                  );
                }),
                isCreating == false
                    ? Container()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: CircularProgressIndicator(),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
