import 'dart:io';
import 'package:amarboi/model/database.dart';
import 'package:amarboi/pages/popular.dart';
import 'package:amarboi/pages/profile.dart';
import 'package:amarboi/views-widgets/popular_list.dart';
import 'package:amarboi/views-widgets/yours_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/book_model.dart';

class MainPage extends StatefulWidget {
  static const routName = "/home";
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // print(_books);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.green,
            // centerTitle: true,
            title: Text(
              'প্রজাপতি',
              style: GoogleFonts.hindSiliguri(
                  color: const Color.fromARGB(255, 71, 71, 71)),
            ),
            leading: Image.asset(
              'assets/projapoti.png',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Profile.routName);
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 15,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'আপনার জন্য',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.hindSiliguri(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                StreamProvider<List<Book>>.value(
                  value: Database().bookByCat(["Onubad"]),
                  initialData: [],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 150,
                    width: double.infinity,
                    child: ForYou(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'জনপ্রিয়',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.hindSiliguri(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Popular.routName);
                          },
                          child: const Text('সব দেখুন',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline))),
                    ],
                  ),
                ),
                StreamProvider<List<Book>>.value(
                  value: Database().bookByCat(["Popular"]),
                  initialData: const [],
                  child: const SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: PopularBook(),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // void openPDF(BuildContext context, File file) {
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //         builder: (context) => PDFViewerPage(
  //               file: file,
  //               isNight: _isNight,
  //             )),
  //   );
  // }
}


/*
Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              final url =
                  'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
              final file = await PDFApi.loadNetwork(url);
              openPDF(context, file);
            },
            child: Text('Network PDF'),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  _isNight = !_isNight;
                });
              },
              icon: Icon(Icons.brightness_6)),
          Container(
            child: _isLoading ? CircularProgressIndicator() : null,
          )
        ],
      )),
      */