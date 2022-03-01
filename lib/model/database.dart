import 'package:amarboi/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  late FirebaseFirestore firestore;
  final user = FirebaseAuth.instance.currentUser;
  //book model
  List<Book> _bookListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Book(
          id: doc.id,
          title: doc["title"],
          cover: doc['cover'],
          link: doc['link'],
          category: doc['category'],
          publisher: doc['publisher'],
          writer: doc['writer'],
          description: doc['description'],
          down: doc['down'],
          views: doc['views'],
          date: (doc['date'] as Timestamp).toDate(),
          language: doc['language']);
    }).toList();
  }

  List<Book> _favsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Book(
          id: doc.id,
          title: doc["title"],
          cover: doc['cover'],
          writer: doc['writer'],
          link: doc['link'],
          date: (doc['date'] as Timestamp).toDate());
    }).toList();
  }

  //favs
  Stream<List<Book>> get favs {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('favs')
        .orderBy('date', descending: true)
        .snapshots()
        .map(_favsList);
  }

  //all books
  Stream<List<Book>> get allBooks {
    // print(arr);
    return FirebaseFirestore.instance
        .collection("all_books")
        .orderBy('views', descending: true)
        .snapshots()
        .map(_bookListFromSnapshot);
  }

  //Book by category
  Stream<List<Book>> bookByCat(var arr) {
    // print(arr);
    return FirebaseFirestore.instance
        .collection("all_books")
        .where("tags", arrayContainsAny: arr)
        .orderBy('views', descending: true)
        .snapshots()
        .map(_bookListFromSnapshot);
  }

  //suggestion books
  Stream<List<Book>> get sugesstion {
    return FirebaseFirestore.instance
        .collection("books")
        .orderBy('views', descending: true)
        .snapshots()
        .map(_bookListFromSnapshot);
  }

  //popular listQuerySnapshot
  Stream<List<Book>> get popular {
    return FirebaseFirestore.instance
        .collection("popular")
        .orderBy('views', descending: true)
        .snapshots()
        .map(_bookListFromSnapshot);
  }

  List<Book> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return Book(
          title: dataMap['title'],
          writer: dataMap['writer'],
          category: dataMap['category'],
          id: snapshot.id,
          link: dataMap['link'],
          cover: dataMap['cover']);
    }).toList();
  }
}

class Post {
  String? title;
  String? cover;
  String? writer;
  int? down;
  int? views;
  String? category;
  String? description;
  String? link;

  Post(
      {this.category,
      this.cover,
      this.writer,
      this.down,
      this.description,
      this.link,
      this.title,
      this.views});

  Post.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          cover: json['cover']! as String,
          category: json['category']! as String,
          writer: json['writer']! as String,
          views: json['views']! as int,
          down: json['down']! as int,
          description: json['description'] as String,
          link: json['link'] as String,
        );

  Map<String, dynamic> toJson() => {
        'title': title,
        'cover': cover,
        'category': category,
        'writer': writer,
        'views': views,
        'down': down,
        'description': description,
        'link': link
      };

  Query<Post> bp(arr) {
    return FirebaseFirestore.instance
        .collection("all_books")
        .where("tags", arrayContainsAny: arr)
        .orderBy('views', descending: true)
        .withConverter(
            fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
            toFirestore: (post, _) => post.toJson());
  }
}
