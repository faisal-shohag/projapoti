import 'package:amarboi/pages/all_books.dart';
import 'package:amarboi/pages/favorites.dart';
import 'package:amarboi/pages/mainpage.dart';
// import 'package:amarboi/pages/popular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../pages/search.dart';

class BottomNavScreen extends StatefulWidget {
  static const routName = '/BottomNave-screen';
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List _pages = const [
    MainPage(),
    // Popular(),
    Search(),
    AllBooks(),
    Favorites()
  ];

  int _currentIndex = 0;

  _onTap(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Ionicons.home), label: 'হোম ', tooltip: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Fontisto.search), label: 'খুঁজুন', tooltip: 'Feed'),
          // BottomNavigationBarItem(icon: Icon(null), label: '', tooltip: ''),
          BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.bookshelf),
              label: 'সব বই',
              tooltip: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(MaterialIcons.favorite),
              label: 'প্রিয়',
              tooltip: 'Favs')
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Search',
      //   onPressed: () {
      //     _onTap(2);
      //   },
      //   child: const Icon(Ionicons.add),
      // ),
    );
  }
}
