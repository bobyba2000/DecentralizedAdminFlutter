import 'package:admin/page/homepage.dart';
import 'package:admin/page/login_page.dart';
import 'package:admin/page/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('There has been an error.'),
          );
        } else if (snapshot.hasData) {
          return const MainPage();
        }
        return const LoginPage();
      }),
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}
