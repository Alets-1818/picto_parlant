import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/crear_oracion_screen.dart';
import 'screens/rutina_screen.dart';
import 'screens/expresate_screen.dart';

void main() {
  runApp(PictoParlantApp());
}

class PictoParlantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PictoParlant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFCFCB), // coral claro (60%)
        primaryColor: Color(0xFFFF6F61), // coral fuerte
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFF6F61),
          primary: Color(0xFFFF6F61),
          secondary: Color(0xFF81D4FA), // azul suave (10%)
          background: Color(0xFFFFCFCB), // coral claro
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFD3B6), // melón claro
            foregroundColor: Color(0xFF5D4037), // marrón suave
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Color(0xFFFF6F61)), // borde coral fuerte
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18.0),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/crear-oracion': (context) => CrearOracionScreen(),
        '/rutina': (context) => RutinaScreen(),
        '/expresate': (context) => ExpresateScreen(),
      },
    );
  }
}
