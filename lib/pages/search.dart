import 'package:amarboi/model/book_model.dart';
import 'package:amarboi/model/database.dart';
import 'package:flutter/material.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);
  static const routName = '/search';
  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      firestoreCollectionName: 'all_books',
      searchBy: 'title',
      scaffoldBody: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Ionicons.search,
            size: 150,
            color: Colors.grey,
          ),
          const SizedBox(height: 30),
          Text('সার্চ করুন!',
              style: GoogleFonts.hindSiliguri(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          Text('বইয়ের নাম লিখুন!',
              style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ],
      )),
      dataListFromSnapshot: Database().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Book>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return Center(
              child: Text('কোনো বই পাওয়া যায়নি!',
                  style: GoogleFonts.hindSiliguri(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final Book data = dataList[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BookDetails(
                              b: Book(id: data.id, link: data.link),
                              collection: "all_books",
                            )));
                  },
                  child: Row(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 7,
                        child: Container(
                          height: 80,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data.cover!))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.title}',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                          Text('${data.writer}',
                              style: Theme.of(context).textTheme.bodyText1),
                          Text('${data.category}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 13, 56, 9)))
                        ],
                      ),
                    ],
                  ),
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('কোনো বই পাওয়া যায়নি!',
                  style: GoogleFonts.hindSiliguri(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
