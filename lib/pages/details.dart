import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/book_model.dart';
import 'package:flutter_html/flutter_html.dart';

class BookDetails extends StatefulWidget {
  final Book b;
  final String collection;
  const BookDetails({Key? key, required this.b, required this.collection})
      : super(key: key);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  void _launchURL() async {
    if (!await launch(widget.b.link!)) {
      throw 'Could not launch ${widget.b.link}';
    }
  }

  int c = 0;

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    print(widget.b.id);
    if (widget.b.views != null) {
      FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.b.id)
          .update({"views": widget.b.views! + 1});
    }
    TextEditingController _descController = TextEditingController();
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.green, shadowColor: Colors.green),
            onPressed: () {
              setState(() {
                c++;
              });
              FirebaseFirestore.instance
                  .collection(widget.collection)
                  .doc(widget.b.id)
                  .update({"down": c});
              _launchURL();
            },
            icon: const Icon(Ionicons.md_book_outline),
            label: Text(
              'এখুনি পড়ুন',
              style: GoogleFonts.hindSiliguri(
                  fontSize: 20, fontWeight: FontWeight.bold),
            )),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.collection)
                .doc(widget.b.id)
                .snapshots(),
            builder: (context, snapshot) {
              // print("uid: ${user!.uid}");
              // print(snapshot.data);
              bool? favs;
              if (snapshot.hasData || snapshot.data!.exists) {
                _descController.text = snapshot.data!["description"];
                c = snapshot.data!["down"];
                if (snapshot.data!["favs"] == "") {
                  FirebaseFirestore.instance
                      .collection(widget.collection)
                      .doc(widget.b.id)
                      .set({
                    "favs": {user!.uid: false}
                  }, SetOptions(merge: true));
                } else if (snapshot.data!["favs"][user!.uid] == null) {
                  print("uid: ${user!.uid}");
                  print("id: ${widget.b.id}");
                  FirebaseFirestore.instance
                      .collection(widget.collection)
                      .doc(widget.b.id)
                      .set({
                    "favs": {user!.uid: false}
                  }, SetOptions(merge: true));
                } else {
                  favs = snapshot.data!["favs"][user!.uid];
                  print("not null");
                }

                print(favs);

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: const Color.fromARGB(255, 12, 11, 15),
                      expandedHeight: MediaQuery.of(context).size.height * 0.5,
                      flexibleSpace: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        color: const Color.fromARGB(255, 75, 70, 70),
                        child: Stack(children: [
                          Positioned(
                            right: 10,
                            child: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection(widget.collection)
                                    .doc(widget.b.id)
                                    .set({
                                  "favs": {user!.uid: !favs!}
                                }, SetOptions(merge: true));
                                if (!favs) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user!.uid)
                                      .collection('favs')
                                      .doc(widget.b.id)
                                      .set({
                                    "id": widget.b.id,
                                    "title": snapshot.data!["title"],
                                    "cover": snapshot.data!["cover"],
                                    "link": snapshot.data!["link"],
                                    "writer": snapshot.data!["writer"],
                                    "date": FieldValue.serverTimestamp()
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: const Duration(seconds: 1),
                                    // padding:
                                    //     EdgeInsets.symmetric(horizontal: 20),
                                    content: Text(
                                      'Added to favorites!',
                                      style: GoogleFonts.hindSiliguri(),
                                    ),
                                    backgroundColor: Colors.green,
                                  ));
                                } else {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user!.uid)
                                      .collection('favs')
                                      .doc(widget.b.id)
                                      .delete();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: const Duration(seconds: 1),
                                    // padding:
                                    //     EdgeInsets.symmetric(horizontal: 20),
                                    content: Text(
                                      'Removed from favorites!',
                                      style: GoogleFonts.hindSiliguri(),
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              icon: favs!
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                            ),
                          ),
                          Align(
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 250,
                                width: 170,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(snapshot.data!["cover"]),
                                    )),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(top: 24, left: 25),
                          child: Text(
                            snapshot.data!["title"],
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 30),
                          child: Text(
                            snapshot.data!["writer"],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 25),
                          child: Row(children: [
                            Row(
                              children: [
                                const Icon(
                                  FontAwesome.eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  (snapshot.data!["views"].toString()),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Ionicons.book_outline,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  (snapshot.data!["down"]).toString(),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Row(
                            //   children: [
                            //     const Icon(
                            //       Feather.star,
                            //       color: Colors.grey,
                            //       size: 15,
                            //     ),
                            //     const SizedBox(
                            //       width: 5,
                            //     ),
                            //     Text(
                            //       (((snapshot.data!["views"] +
                            //                       snapshot.data!["down"]) /
                            //                   100) *
                            //               5)
                            //           .toStringAsPrecision(2),
                            //       style: const TextStyle(
                            //           color: Colors.grey,
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // )
                          ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              color: const Color.fromARGB(172, 28, 180, 61),
                              elevation: 5,
                              margin: const EdgeInsets.only(
                                right: 5,
                                left: 25,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.center,
                                // width: 100,
                                height: 30,
                                child: Text(snapshot.data!["category"],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(200, 15, 99, 15))),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            // Card(
                            //   color: const Color.fromARGB(134, 190, 80, 218),
                            //   elevation: 5,
                            //   margin: const EdgeInsets.only(right: 10),
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(2)),
                            //   child: Container(
                            //     width: 100,
                            //     height: 30,
                            //     alignment: Alignment.center,
                            //     child: Text(snapshot.data!["publisher"],
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.center,
                            //         style: const TextStyle(
                            //             fontSize: 12,
                            //             fontWeight: FontWeight.bold,
                            //             color:
                            //                 Color.fromARGB(201, 72, 11, 80))),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(2),
                            //     ),
                            //   ),
                            // ),
                            // Card(
                            //   color: const Color.fromARGB(172, 28, 180, 61),
                            //   elevation: 5,
                            //   margin: const EdgeInsets.only(right: 5),
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(2)),
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     width: 100,
                            //     height: 30,
                            //     child: Text(widget.b.language!,
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.center,
                            //         style: const TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             color: Color.fromARGB(200, 15, 99, 15))),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(2),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'বইটি সম্পর্কে',
                                style: GoogleFonts.hindSiliguri(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  onPressed: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(
                                                Entypo.feather,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                'বই বিবরণ এডিট',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          content: TextFormField(
                                            controller: _descController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green))),
                                            maxLines: 7,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          widget.collection)
                                                      .doc(widget.b.id)
                                                      .update({
                                                    "description":
                                                        _descController.text
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                      'Saved successfully!',
                                                      style: GoogleFonts
                                                          .hindSiliguri(),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ));
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save'))
                                          ],
                                        ),
                                      ),
                                  icon: const Icon(Entypo.pencil))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, bottom: 50, right: 10),
                          child: Html(
                            data: snapshot.data!["description"],
                          ),
                        ),
                      ]),
                    )
                  ],
                );
              }
              return const Text('not found');
            }),
      ),
    );
  }
}
