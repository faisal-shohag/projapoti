import 'package:amarboi/services/auth.dart';
import 'package:amarboi/views-widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const BottomNavScreen();
              }
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
                            final provider =
                                Provider.of<GoogleAuth>(context, listen: false);
                            provider.googleLogIn();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FontAwesome.google),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Sign in with Google')
                              ])),
                    ]),
              ));
            }));
    // return Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //       child: Column(
    //         children: [
    //           ElevatedButton(
    //               onPressed: () async {
    //                 final provider =
    //                     Provider.of<GoogleAuth>(context, listen: false);
    //                 provider.googleLogIn();
    //               },
    //               child: Text('Sign in')),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
