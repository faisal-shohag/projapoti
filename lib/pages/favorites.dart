import 'package:amarboi/pages/details.dart';
import 'package:amarboi/views-widgets/favorite_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book_model.dart';
import '../model/database.dart';

class Favorites extends StatefulWidget {
  static const routName = "/favorites";
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('প্রিয়'),
      ),
      body: StreamProvider<List<Book>>.value(
        value: Database().favs,
        initialData: const [],
        child: const SizedBox(
            height: 500, width: double.infinity, child: FavoriteList()),
      ),
    );
  }
}
