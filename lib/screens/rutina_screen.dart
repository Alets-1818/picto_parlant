import 'package:flutter/material.dart';

class RutinaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutina diaria'),
      ),
      body: Center(
        child: Text('Aquí se configurarán rutinas por hora del día'),
      ),
    );
  }
}
