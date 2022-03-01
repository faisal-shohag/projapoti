import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import '../model/book_model.dart';
import '../pages/details.dart';

class PopularBook extends StatefulWidget {
  const PopularBook({Key? key}) : super(key: key);

  @override
  State<PopularBook> createState() => _PopularBookState();
}

class _PopularBookState extends State<PopularBook> {
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>>(context);

    return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookDetails(
                        b: Book(
                            id: books[index].id,
                            description: books[index].description,
                            down: books[index].down,
                            link: books[index].link,
                            views: books[index].views),
                        collection: "all_books",
                      )));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(books[index].cover!))),
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        books[index].writer!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                      Row(children: [
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
                              (books[index].views.toString()),
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
                              (books[index].down).toString(),
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
                        //       (((books[index].views! / books[index].down!)))
                        //           .toStringAsPrecision(2),
                        //       style: const TextStyle(
                        //           color: Colors.grey,
                        //           fontSize: 12,
                        //           fontWeight: FontWeight.bold),
                        //     )
                        //   ],
                        // )
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            color: const Color.fromARGB(172, 28, 180, 61),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              // width: 100,
                              height: 25,
                              child: Text(books[index].category!,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(200, 15, 99, 15))),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
