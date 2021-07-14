import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'screens/overview.dart';
import 'screens/loading.dart';
import 'screens/error.dart';

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
      return OverviewScreen();
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
