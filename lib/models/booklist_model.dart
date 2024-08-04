import 'dart:io';
import 'package:flutter/foundation.dart';

class BooklistModel {
  final String id;
  final String title;
  final String author;
  final String image;
  bool isFavorite;

  BooklistModel({
    required this.id,
    required this.title,
    required this.author,
    required this.image,
    this.isFavorite = false,
    required imagePath,
    required File imageFile,
  });

  BooklistModel.fromjson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
        image = json['image'];

  get imagePath => null;

  get imageFile => null;
}
