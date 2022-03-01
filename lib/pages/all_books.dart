import 'package:amarboi/model/book_model.dart';
import 'package:amarboi/model/database.dart';
import 'package:amarboi/pages/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutterfire_ui/firestore.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({Key? key}) : super(key: key);
  static const routName = '/allbook';

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Post>(
      query: Post().bp(["Fiction"]),
      // pageSize: 2,
      builder: (context, snapshot, _) {
        count = snapshot.docs.length;
        return Scaffold(
          appBar: AppBar(title: Text('সব বই(${snapshot.docs.length})')),
          body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, mainAxisExtent: 120),
              shrinkWrap: true,
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                final hasEndReached = snapshot.hasMore &&
                    index + 1 == snapshot.docs.length &&
                    !snapshot.isFetchingMore;
                if (hasEndReached) {
                  snapshot.fetchMore();
                }

                final post = snapshot.docs[index].data();
                return buildBookPost(post, snapshot.docs[index].id);
              }),
        );
      },
    );
  }

  Widget buildBookPost(Post post, String id) => InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookDetails(
                    b: Book(
                        id: id,
                        description: post.description,
                        down: post.down,
                        link: post.link,
                        views: post.views),
                    collection: "all_books",
                  )));
        },
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              Card(
                elevation: 7,
                child: Container(
                  height: 100,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            post.cover.toString(),
                          ))),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          // fontSize: 14
                        ),
                      ),
                      Text(
                        post.writer.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 10),
                      ),
                      Text(
                        post.category.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 8),
                      ),
                      Row(
                        children: [
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
                                (post.views.toString()),
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
                                (post.down).toString(),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      );
}
