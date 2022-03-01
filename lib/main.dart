import 'package:amarboi/pages/all_books.dart';
import 'package:amarboi/pages/favorites.dart';
import 'package:amarboi/pages/mainpage.dart';
import 'package:amarboi/pages/popular.dart';
import 'package:amarboi/pages/profile.dart';
import 'package:amarboi/pages/search.dart';
import 'package:amarboi/services/auth.dart';
import 'package:amarboi/views-widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleAuth(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Projapoti',
          theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Kalpurush'
              // textTheme: GoogleFonts.hindSiliguriTextTheme(
              //   Theme.of(context).textTheme,
              // )
              ),
          home: Scaffold(
              body: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SafeArea(
                          child: Center(child: CircularProgressIndicator()));
                    } else if (!snapshot.hasData) {
                      return SafeArea(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        constraints: const BoxConstraints.expand(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/projapoti.png',
                                height: 150,
                              ),
                              const Text(
                                'প্রজাপতি',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'বিনামূল্যে ই-বুক',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final provider = Provider.of<GoogleAuth>(
                                        context,
                                        listen: false);
                                    provider.googleLogIn();
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(FontAwesome.google),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Sign in with Google')
                                      ])),
                            ]),
                      ));
                    } else if (snapshot.hasData) {
                      return const BottomNavScreen();
                    } else {
                      return SafeArea(
                          child: Container(
                        child: Text('Something went wrong!'),
                      ));
                    }
                  })),
          routes: {
            BottomNavScreen.routName: (ctx) => const BottomNavScreen(),
            MainPage.routName: (ctx) => const MainPage(),
            Popular.routName: (ctx) => const Popular(),
            Search.routName: (ctx) => const Search(),
            AllBooks.routName: (ctx) => const AllBooks(),
            Profile.routName: (ctx) => const Profile(),
            Favorites.routName: (ctx) => const Favorites()
            // AddDesc.routName: (ctx) => const AddDesc(),
          }));
}
