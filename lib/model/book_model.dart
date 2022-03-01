import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Book {
  String? id;
  String? title;
  String? writer;
  String? description;
  String? category;
  String? publisher;
  String? language;
  String? link;
  String? cover;
  int? down;
  int? views;
  DateTime? date;

  Book(
      {this.id,
      this.title,
      this.writer,
      this.description,
      this.category,
      this.publisher,
      this.language,
      this.link,
      this.cover,
      this.down,
      this.views,
      this.date});
}
