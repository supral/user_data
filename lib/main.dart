import 'package:flutter/material.dart';
import 'screens/user_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Placeholder App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserPage(),
    );
  }
}
