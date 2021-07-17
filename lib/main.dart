import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/settings.dart';
import 'screens/overview.dart';
import 'screens/loading.dart';
import 'screens/error.dart';
import 'screens/auth.dart';
import 'providers/user.dart';
import 'models/user.dart' as model;

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
            // Returns a FutureBuilder in order to save the user data into provider
            return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(
                      (snapshot.data as User).uid,
                    )
                    .get(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  } else if (snapshot.hasError) {
                    return ErrorScreen(snapshot.error.toString());
                  }
                  final response =
                      snapshot.data as DocumentSnapshot<Map<String, dynamic>>;
                  Provider.of<UserProvider>(ctx, listen: false)
                      .setUser(response.id, response.data()!['email'], "", [
                    model.UserSettings(
                        model.Setting.Budget, response.data()!['budget']),
                    model.UserSettings(
                        model.Setting.Currency, response.data()!['currency']),
                  ]);
                  return OverviewScreen();
                });
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
          return ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
            child: MaterialApp(
              title: 'Spending Planner',
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.deepPurple,
              ),
              home: _buildHome(snapshot),
              routes: {
                OverviewScreen.routeName: (ctx) => OverviewScreen(),
                SettingsScreen.routeName: (ctx) => SettingsScreen()
              },
            ),
          );
        });
  }
}
