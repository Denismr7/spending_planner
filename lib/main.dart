import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/insights_screen.dart';
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
                      model.Setting.Budget,
                      response.data()!['budget'],
                    ),
                    model.UserSettings(
                      model.Setting.Currency,
                      response.data()!['currency'],
                    ),
                    model.UserSettings(
                      model.Setting.Categories,
                      response.data()!['categories'],
                    ),
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
                primarySwatch: createMaterialColor(
                  const Color.fromRGBO(44, 52, 148, 1.0),
                ),
                scaffoldBackgroundColor:
                    const Color.fromRGBO(251, 248, 255, 1.0),
                accentColor: const Color.fromRGBO(88, 86, 188, 1),
                cardColor: const Color.fromRGBO(51, 56, 153, 1),
                textTheme: TextTheme(
                    headline1: const TextStyle(
                      color: const Color.fromRGBO(251, 248, 255, 1.0),
                    ),
                    headline2: const TextStyle(
                      color: const Color.fromRGBO(251, 248, 255, 1.0),
                    ),
                    headline3: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    subtitle2: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              home: _buildHome(snapshot),
              routes: {
                OverviewScreen.routeName: (ctx) => OverviewScreen(),
                SettingsScreen.routeName: (ctx) => SettingsScreen(),
                InsightsScreen.routeName: (ctx) => InsightsScreen(),
              },
            ),
          );
        });
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
