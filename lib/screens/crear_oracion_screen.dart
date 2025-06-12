import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';

import '../models/pictograma.dart';

class CrearOracionScreen extends StatefulWidget {
  @override
  _CrearOracionScreenState createState() => _CrearOracionScreenState();
}

class _CrearOracionScreenState extends State<CrearOracionScreen> {
  List<Pictograma> seleccionados = [];
  List<String> frasesGuardadas = [];
  List<Pictograma> pictogramas = [];
  Map<String, int> contadorUso = {}; // Contador para personalización IA

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    cargarFrasesGuardadas();
    inicializarPictogramas();
    cargarContadorUso();
  }

  Future<void> inicializarPictogramas() async {
    final prefs = await SharedPreferences.getInstance();
    final customJson = prefs.getStringList('pictogramas_personalizados') ?? [];

    List<Pictograma> custom = customJson.map((j) {
      final map = jsonDecode(j);
      return Pictograma(nombre: map['nombre'], imagen: map['imagen']);
    }).toList();

    List<Pictograma> base = [
      Pictograma(nombre: 'Quiero', imagen: 'assets/Pictogramas/quiero.png'),
      Pictograma(nombre: 'Comer', imagen: 'assets/Pictogramas/comer.png'),
      Pictograma(nombre: 'Agua', imagen: 'assets/Pictogramas/agua.png'),
      Pictograma(nombre: 'Jugar', imagen: 'assets/Pictogramas/jugar.png'),
      Pictograma(nombre: 'Baño', imagen: 'assets/Pictogramas/baño.png'),
    ];

    setState(() {
      pictogramas = [...base, ...custom];
      ordenarPictogramasPorUso();
    });
  }

  void ordenarPictogramasPorUso() {
    pictogramas.sort((a, b) {
      int usoA = contadorUso[a.nombre] ?? 0;
      int usoB = contadorUso[b.nombre] ?? 0;
      return usoB.compareTo(usoA);
    });
  }

  Future<void> cargarContadorUso() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('contador_uso');
    if (jsonStr != null) {
      setState(() {
        contadorUso = Map<String, int>.from(jsonDecode(jsonStr));
        ordenarPictogramasPorUso();
      });
    }
  }

  Future<void> guardarContadorUso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contador_uso', jsonEncode(contadorUso));
  }

  void agregarAPalabra(Pictograma p) {
    setState(() {
      seleccionados.add(p);
      contadorUso[p.nombre] = (contadorUso[p.nombre] ?? 0) + 1;
    });
    guardarContadorUso();
    ordenarPictogramasPorUso();
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
    leerFrase();
  }

  Future<void> agregarPictogramaPersonalizado() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final nombre = await pedirNombre();
      if (nombre == null || nombre.isEmpty) return;

      final directory = await getApplicationDocumentsDirectory();
      final path = p.join(directory.path, p.basename(pickedFile.path));
      await File(pickedFile.path).copy(path);

      final nuevo = Pictograma(nombre: nombre, imagen: path);

      final prefs = await SharedPreferences.getInstance();
      final personalizados =
          prefs.getStringList('pictogramas_personalizados') ?? [];
      personalizados.add(jsonEncode({'nombre': nombre, 'imagen': path}));
      await prefs.setStringList('pictogramas_personalizados', personalizados);

      setState(() {
        pictogramas.add(nuevo);
      });
      ordenarPictogramasPorUso();
    }
  }

  Future<String?> pedirNombre() async {
    String? valor;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nombre del pictograma'),
        content: TextField(onChanged: (value) => valor = value),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
    return valor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear oración'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: agregarPictogramaPersonalizado,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = seleccionados.removeAt(oldIndex);
                      seleccionados.insert(newIndex, item);
                    });
                  },
                  children: List.generate(seleccionados.length, (index) {
                    final p = seleccionados[index];
                    return Container(
                      key: ValueKey(p.nombre + index.toString()),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReorderableDragStartListener(
                            index: index,
                            child: Icon(Icons.drag_handle, color: Colors.grey),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                seleccionados.removeAt(index);
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                p.imagen.startsWith('assets')
                                    ? Image.asset(p.imagen, height: 40)
                                    : Image.file(File(p.imagen), height: 40),
                                Text(p.nombre),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
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
                          p.imagen.startsWith('assets')
                              ? Image.asset(p.imagen, height: 60)
                              : Image.file(File(p.imagen), height: 60),
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
