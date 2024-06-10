import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do/api/firsebase_api.dart';
import 'auth.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/login_register_page.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  // await FirebaseApi().initNotifications();
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WidgetTree(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginRegesterPage();
          }
        });
  }
}
