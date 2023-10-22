import 'package:flutter/material.dart';
import 'package:my_contacts/pages/home/home_page.dart';

const Color mainColor = Color.fromARGB(255, 13, 152, 176);
const Color darkColor = Color.fromARGB(255, 5, 87, 101);
const Color darkLightColor = Color.fromARGB(255, 29, 117, 133);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove o banner de "Modo Debug"
      debugShowCheckedModeBanner: false,
      // Tema customizado
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: mainColor,
        ),
        iconTheme: const IconThemeData(color: mainColor),
        textTheme: const TextTheme(
          button: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: mainColor, fontSize: 20),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor.withOpacity(0.3)),
          ),
          prefixStyle: TextStyle(color: mainColor.withOpacity(0.8), fontSize: 20),
          labelStyle: TextStyle(color: mainColor.withOpacity(0.8), fontSize: 20),
        ),
      ),
      home: const HomePage(),
    );
  }
}
