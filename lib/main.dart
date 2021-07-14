import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/overview.dart';
import 'screens/loading.dart';
import 'screens/error.dart';
import 'screens/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _buildHome(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return ErrorScreen(snapshot.error.toString());
    }

    if (snapshot.connectionState == ConnectionState.done) {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }

          if (snapshot.hasError) {
            return ErrorScreen(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            return OverviewScreen();
          }

          return AuthScreen();
        },
      );
    }

    return LoadingScreen();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Spending Planner',
            theme: ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.lightGreen,
            ),
            home: _buildHome(snapshot),
            routes: {
              OverviewScreen.routeName: (ctx) => OverviewScreen(),
            },
          );
        });
  }
}
