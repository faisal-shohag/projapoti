import 'package:amarboi/pages/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/book_model.dart';

class ForYou extends StatefulWidget {
  ForYou({Key? key}) : super(key: key);

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>>(context);
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookDetails(
                        b: Book(
                            id: books[index].id,
                            description: books[index].description,
                            link: books[index].link,
                            cover: books[index].cover,
                            down: books[index].down,
                            views: books[index].views),
                        collection: "all_books",
                      )));
              FirebaseFirestore.instance
                  .collection('books')
                  .doc(books[index].id)
                  .update({"views": books[index].views! + 1});
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: books.isEmpty
                  ? Container(
                      child: Text('...'),
                      height: 180,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red),
                    )
                  : Container(
                      height: 120,
                      width: 95,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                (books[index].cover!),
                              )),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red),
                    ),
            ),
          );
        });
  }
}

/*
Container(
          height: 180,
          width: 120,
          // padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    (_books[index].cover),
                  )),
              borderRadius: BorderRadius.circular(10),
              color: Colors.red),
        ),
*/