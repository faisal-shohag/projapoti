import 'package:amarboi/model/book_model.dart';
import 'package:amarboi/pages/all_books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../pages/details.dart';
import 'package:jiffy/jiffy.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>>(context);
    if (books.isEmpty) {
      return Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/empty.png',
              height: 200,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'প্রিয়তে কোন বই নেই!',
              style: GoogleFonts.hindSiliguri(
                  fontSize: 25,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AllBooks.routName);
                },
                child: Text(
                  'যুক্ত করুন!',
                  style: GoogleFonts.hindSiliguri(),
                ))
          ],
        ),
      );
    }
    return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          var date = books[index].date;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookDetails(
                        b: Book(id: books[index].id, link: books[index].link),
                        collection: "all_books",
                      )));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 7,
                        child: Container(
                          height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(books[index].cover!))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index].title!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green),
                          ),
                          Text(
                            books[index].writer!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            date.toString().split(' ')[0],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(user!.uid)
                            .collection('favs')
                            .doc(books[index].id)
                            .delete();
                      },
                      icon: const Icon(MaterialCommunityIcons.delete,
                          color: Color.fromARGB(255, 179, 58, 36)))
                ],
              ),
            ),
          );
        });
  }
}
