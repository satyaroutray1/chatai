import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'chat_main.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyBJjpbnVJxjWDg8maAFhGyeqz', enableDebugging: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // for default text
          bodyMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          // for headings
        ),
      ),
      home: ChatMain(),
      debugShowCheckedModeBanner: false,
    );
  }
}
