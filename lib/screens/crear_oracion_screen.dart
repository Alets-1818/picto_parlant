import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pictograma.dart';

class CrearOracionScreen extends StatefulWidget {
  @override
  _CrearOracionScreenState createState() => _CrearOracionScreenState();
}

class _CrearOracionScreenState extends State<CrearOracionScreen> {
  List<Pictograma> seleccionados = [];
  List<String> frasesGuardadas = [];

  final FlutterTts flutterTts = FlutterTts();

  final List<Pictograma> pictogramas = [
    Pictograma(nombre: 'Quiero', imagen: 'assets/Pictogramas/quiero.png'),
    Pictograma(nombre: 'Comer', imagen: 'assets/Pictogramas/comer.png'),
    Pictograma(nombre: 'Agua', imagen: 'assets/Pictogramas/agua.png'),
    Pictograma(nombre: 'Jugar', imagen: 'assets/Pictogramas/jugar.png'),
    Pictograma(nombre: 'Baño', imagen: 'assets/Pictogramas/baño.png'),
  ];

  @override
  void initState() {
    super.initState();
    cargarFrasesGuardadas();
  }

  void agregarAPalabra(Pictograma p) {
    setState(() {
      seleccionados.add(p);
    });
  }

  void limpiarFrase() {
    setState(() {
      seleccionados.clear();
    });
  }

  Future<void> leerFrase() async {
    if (seleccionados.isEmpty) return;
    String frase = seleccionados.map((p) => p.nombre).join(' ');
    await flutterTts.setLanguage("es-MX");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(frase);
  }

  Future<void> guardarFrase() async {
    String frase = seleccionados.map((p) => p.nombre).join(' ');
    if (frase.trim().isEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      frasesGuardadas.add(frase);
    });
    await prefs.setStringList('frases_guardadas', frasesGuardadas);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Frase guardada')));
  }

  Future<void> cargarFrasesGuardadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      frasesGuardadas = prefs.getStringList('frases_guardadas') ?? [];
    });
  }

  void cargarFraseEnConstructor(String frase) {
    List<String> palabras = frase.split(' ');
    setState(() {
      seleccionados = palabras.map((palabra) {
        return pictogramas.firstWhere(
          (p) => p.nombre == palabra,
          orElse: () => Pictograma(nombre: palabra, imagen: ''),
        );
      }).toList();
    });
    leerFrase(); // 🔊 leer automáticamente al tocar una frase guardada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear oración')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Frase construida
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: seleccionados.asMap().entries.map((entry) {
                      int index = entry.key;
                      Pictograma p = entry.value;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            seleccionados.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(p.imagen, height: 40),
                              Text(p.nombre),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: limpiarFrase,
              child: Text('Limpiar oración'),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: leerFrase, child: Text('Leer oración')),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: guardarFrase,
              child: Text('Guardar oración'),
            ),
            SizedBox(height: 16),

            // Lista de frases guardadas
            if (frasesGuardadas.isNotEmpty) ...[
              Text(
                'Frases guardadas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: frasesGuardadas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(frasesGuardadas[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            frasesGuardadas.removeAt(index);
                            prefs.setStringList(
                              'frases_guardadas',
                              frasesGuardadas,
                            );
                          });
                        },
                      ),
                      onTap: () =>
                          cargarFraseEnConstructor(frasesGuardadas[index]),
                    );
                  },
                ),
              ),
            ],

            // Pictogramas para seleccionar
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: pictogramas.map((p) {
                  return GestureDetector(
                    onTap: () => agregarAPalabra(p),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(p.imagen, height: 60),
                          SizedBox(height: 8),
                          Text(p.nombre),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
