import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> actividades = [
    'Arma una frase con 3 pictogramas',
    'Describe tu comida favorita',
    'Haz una frase sobre un animal',
    'Expresa una emoción con pictogramas',
    'Crea una frase para saludar',
    'Cuenta qué hiciste hoy',
  ];

  String actividadActual = '';

  @override
  void initState() {
    super.initState();
    actividadActual = actividades.first;
  }

  void cambiarActividad() {
    final nuevas = actividades.where((a) => a != actividadActual).toList();
    actividadActual = (nuevas..shuffle()).first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F6),
      appBar: AppBar(
        title: Text('PictoParlant'),
        centerTitle: true,
        backgroundColor: Color(0xFFF2E6FF),
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '¡Hola!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '¿Qué quieres hacer hoy?',
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.edit,
                  label: 'Crear oración',
                  route: '/crear-oracion',
                ),
                _buildActionButton(
                  context,
                  icon: Icons.record_voice_over,
                  label: 'Exprésate',
                  route: '/expresate',
                ),
              ],
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: cambiarActividad,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                color: Color(0xFFF8F2FF),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.black, size: 36),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Actividad sugerida',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            actividadActual,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return _AnimatedScaleButton(
      onTap: () => Navigator.pushNamed(context, route),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFF2E6FF),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.black),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedScaleButton({required this.child, required this.onTap});

  @override
  State<_AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<_AnimatedScaleButton> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
