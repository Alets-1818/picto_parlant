import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/crear_oracion_screen.dart';
import 'screens/rutina_screen.dart';
import 'screens/expresate_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Carga el .env ANTES de iniciar la app
  runApp(PictoParlantApp());
}

class PictoParlantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PictoParlant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212), // Fondo negro
        primaryColor: Color(0xFFFFAB91), // Durazno
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFFAB91),
          brightness: Brightness.dark,
          primary: Color(0xFFFFAB91),
          secondary: Color(0xFFFFCCBC),
          background: Color(0xFF121212),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFAB91), // Botón durazno
            foregroundColor: Colors.white, // Texto blanco
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Color(0xFFFFAB91)),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.white),
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
