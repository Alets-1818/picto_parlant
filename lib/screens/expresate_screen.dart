import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/pictograma.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExpresateScreen extends StatefulWidget {
  @override
  _ExpresateScreenState createState() => _ExpresateScreenState();
}

class _ExpresateScreenState extends State<ExpresateScreen> {
  List<Pictograma> pictogramas = [];
  List<Pictograma> seleccionados = [];
  String query = '';
  final FlutterTts flutterTts = FlutterTts();
  final openAiApiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    inicializarPictogramas();
  }

  Future<void> inicializarPictogramas() async {
    final prefs = await SharedPreferences.getInstance();
    final customJson = prefs.getStringList('pictogramas_personalizados') ?? [];

    List<Pictograma> custom = customJson.map((j) {
      final map = jsonDecode(j);
      return Pictograma(
        nombre: map['nombre'],
        imagen: map['imagen'],
        categoria: map['categoria'] ?? 'Personalizados',
      );
    }).toList();

    setState(() {
      pictogramas = [...base, ...custom];
    });
  }

  List<Pictograma> base = [
    // Acciones
    Pictograma(
      nombre: 'Quiero',
      imagen: 'assets/Pictogramas/Acciones/quiero.png',
      categoria: 'Acciones',
    ),
    Pictograma(
      nombre: 'Comer',
      imagen: 'assets/Pictogramas/Acciones/comer.png',
      categoria: 'Acciones',
    ),
    Pictograma(
      nombre: 'Baño',
      imagen: 'assets/Pictogramas/Acciones/baño.png',
      categoria: 'Acciones',
    ),
    Pictograma(
      nombre: 'Jugar',
      imagen: 'assets/Pictogramas/Acciones/jugar.png',
      categoria: 'Acciones',
    ),
    Pictograma(
      nombre: 'Hacer',
      imagen: 'assets/Pictogramas/Acciones/hacer.png',
      categoria: 'Acciones',
    ),
    Pictograma(
      nombre: 'Hacer la compra',
      imagen: 'assets/Pictogramas/Acciones/hacer la compra.png',
      categoria: 'Acciones',
    ),
    Pictograma(
      nombre: 'Tomar la temperatura',
      imagen: 'assets/Pictogramas/Acciones/tomar la temperatura.png',
      categoria: 'Acciones',
    ),

    // Carnes
    Pictograma(
      nombre: 'Atún',
      imagen: 'assets/Pictogramas/Carnes/atún.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'Carne envasada de cerdo',
      imagen: 'assets/Pictogramas/Carnes/carne envasada de cerdo.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'Carne envasada de pollo',
      imagen: 'assets/Pictogramas/Carnes/carne envasada de pollo.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'Carne envasada de Ternera',
      imagen: 'assets/Pictogramas/Carnes/carne envasada de ternera.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'Carne',
      imagen: 'assets/Pictogramas/Carnes/carne.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'Carnes',
      imagen: 'assets/Pictogramas/Carnes/carnes.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'carnicería',
      imagen: 'assets/Pictogramas/Carnes/carnicería.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'Huevo',
      imagen: 'assets/Pictogramas/Carnes/huevo.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'mantequilla',
      imagen: 'assets/Pictogramas/Carnes/mantequilla.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'muslo de pollo',
      imagen: 'assets/Pictogramas/Carnes/muslo de pollo.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'pescadería',
      imagen: 'assets/Pictogramas/Carnes/salmón.png',
      categoria: 'Carnes',
    ),
    Pictograma(
      nombre: 'sardina',
      imagen: 'assets/Pictogramas/Carnes/sardina.png',
      categoria: 'Carnes',
    ),

    // Cocina
    // Cocina
    Pictograma(
      nombre: 'Bajar la temperatura',
      imagen: 'assets/Pictogramas/Cocina/bajar la temperatura.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Cereales',
      imagen: 'assets/Pictogramas/Cocina/cereales.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Remover',
      imagen: 'assets/Pictogramas/Cocina/remover.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Especias',
      imagen: 'assets/Pictogramas/Cocina/especias.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Cuchillo',
      imagen: 'assets/Pictogramas/Cocina/cuchillo.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Plato',
      imagen: 'assets/Pictogramas/Cocina/plato.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Batidora',
      imagen: 'assets/Pictogramas/Cocina/batidora.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Ración',
      imagen: 'assets/Pictogramas/Cocina/ración.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Bebidas',
      imagen: 'assets/Pictogramas/Cocina/bebidas.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Asar',
      imagen: 'assets/Pictogramas/Cocina/asar.png',
      categoria: 'Cocina',
    ),

    // Cocina
    Pictograma(
      nombre: 'Nevera',
      imagen: 'assets/Pictogramas/Cocina/nevera.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Bol',
      imagen: 'assets/Pictogramas/Cocina/bol.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Microondas',
      imagen: 'assets/Pictogramas/Cocina/microondas.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Pizza',
      imagen: 'assets/Pictogramas/Cocina/pizca.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Comida caliente',
      imagen: 'assets/Pictogramas/Cocina/comida caliente.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Refresco',
      imagen: 'assets/Pictogramas/Cocina/Refresco.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Rellenar',
      imagen: 'assets/Pictogramas/Cocina/rellenar.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Rodillo',
      imagen: 'assets/Pictogramas/Cocina/rodillo.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Rasera',
      imagen: 'assets/Pictogramas/Cocina/rasera.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Tostadora',
      imagen: 'assets/Pictogramas/Cocina/tostadora.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Cucharón (1)',
      imagen: 'assets/Pictogramas/Cocina/cucharón (1).png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Receta',
      imagen: 'assets/Pictogramas/Cocina/receta.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Comida fría',
      imagen: 'assets/Pictogramas/Cocina/comida fría.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Bocadillo',
      imagen: 'assets/Pictogramas/Cocina/bocadillo.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Majar',
      imagen: 'assets/Pictogramas/Cocina/majar.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Aceite',
      imagen: 'assets/Pictogramas/Cocina/aceite.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Bandeja',
      imagen: 'assets/Pictogramas/Cocina/bandeja.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Sartén',
      imagen: 'assets/Pictogramas/Cocina/sartén.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Colador',
      imagen: 'assets/Pictogramas/Cocina/colador.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Lista',
      imagen: 'assets/Pictogramas/Cocina/lista.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Cocina',
      imagen: 'assets/Pictogramas/Cocina/cocina.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Café',
      imagen: 'assets/Pictogramas/Cocina/café.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Batir',
      imagen: 'assets/Pictogramas/Cocina/batir.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Platos',
      imagen: 'assets/Pictogramas/Cocina/platos.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Cazo',
      imagen: 'assets/Pictogramas/Cocina/cazo.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Salero',
      imagen: 'assets/Pictogramas/Cocina/salero.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Cucharón',
      imagen: 'assets/Pictogramas/Cocina/cucharón.png',
      categoria: 'Cocina',
    ),
    Pictograma(
      nombre: 'Ingredientes',
      imagen: 'assets/Pictogramas/Cocina/ingredientes.png',
      categoria: 'Cocina',
    ),

    Pictograma(
      nombre: 'Salpicar',
      imagen: 'assets/Pictogramas/Deportes_juegos/salpicar.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Billar',
      imagen: 'assets/Pictogramas/Deportes_juegos/billar.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Mando de la consola',
      imagen: 'assets/Pictogramas/Deportes_juegos/mando de la consola.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Juego de piedra papel o tijera',
      imagen:
          'assets/Pictogramas/Deportes_juegos/juego de piedra papel o tijera.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Peón',
      imagen: 'assets/Pictogramas/Deportes_juegos/peón.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Patinar sobre hielo',
      imagen: 'assets/Pictogramas/Deportes_juegos/patinar sobre hielo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Portería',
      imagen: 'assets/Pictogramas/Deportes_juegos/portería.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Voltereta',
      imagen: 'assets/Pictogramas/Deportes_juegos/voltereta.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Golf',
      imagen: 'assets/Pictogramas/Deportes_juegos/golf.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Boxeo',
      imagen: 'assets/Pictogramas/Deportes_juegos/boxeo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Guante de béisbol',
      imagen: 'assets/Pictogramas/Deportes_juegos/guante de béisbol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugador de hockey hielo',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugador de hockey hielo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Escaladora',
      imagen: 'assets/Pictogramas/Deportes_juegos/escaladora.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Raqueta de ping-pong',
      imagen: 'assets/Pictogramas/Deportes_juegos/raqueta de ping-pong.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugar con el ordenador',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugar con el ordenador.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Ajedrez',
      imagen: 'assets/Pictogramas/Deportes_juegos/ajedrez.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Tapar los ojos',
      imagen: 'assets/Pictogramas/Deportes_juegos/tapar los ojos.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Rey',
      imagen: 'assets/Pictogramas/Deportes_juegos/rey.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Reina',
      imagen: 'assets/Pictogramas/Deportes_juegos/reina.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Patinaje',
      imagen: 'assets/Pictogramas/Deportes_juegos/patinaje.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Hockey (1)',
      imagen: 'assets/Pictogramas/Deportes_juegos/hockey (1).png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Equilibrio',
      imagen: 'assets/Pictogramas/Deportes_juegos/equilibrio.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Hockey',
      imagen: 'assets/Pictogramas/Deportes_juegos/hockey.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugador de fútbol americano',
      imagen:
          'assets/Pictogramas/Deportes_juegos/jugador de fútbol americano.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Balón de rugby',
      imagen: 'assets/Pictogramas/Deportes_juegos/balón de rugby.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Pódium',
      imagen: 'assets/Pictogramas/Deportes_juegos/pódium.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Atleta',
      imagen: 'assets/Pictogramas/Deportes_juegos/atleta.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Mesa de ping pong',
      imagen: 'assets/Pictogramas/Deportes_juegos/mesa de ping pong.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugar con el tablet',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugar con el tablet.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Cambio de turno',
      imagen: 'assets/Pictogramas/Deportes_juegos/cambio de turno.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Escondite',
      imagen: 'assets/Pictogramas/Deportes_juegos/escondite.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Torre',
      imagen: 'assets/Pictogramas/Deportes_juegos/torre.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Bate y pelota',
      imagen: 'assets/Pictogramas/Deportes_juegos/bate y pelota.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Pádel',
      imagen: 'assets/Pictogramas/Deportes_juegos/pádel.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Esgrima',
      imagen: 'assets/Pictogramas/Deportes_juegos/esgrima.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Ping-pong',
      imagen: 'assets/Pictogramas/Deportes_juegos/ping-pong.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Boxeador',
      imagen: 'assets/Pictogramas/Deportes_juegos/boxeador.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugador de béisbol',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugador de béisbol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Gol',
      imagen: 'assets/Pictogramas/Deportes_juegos/gol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Patinadora (1)',
      imagen: 'assets/Pictogramas/Deportes_juegos/patinadora (1).png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Patinadora',
      imagen: 'assets/Pictogramas/Deportes_juegos/patinadora.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Deportes',
      imagen: 'assets/Pictogramas/Deportes_juegos/deportes.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugar a la videoconsola',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugar a la videoconsola.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Juegos',
      imagen: 'assets/Pictogramas/Deportes_juegos/juegos.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Rayuela',
      imagen: 'assets/Pictogramas/Deportes_juegos/rayuela.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Caballo',
      imagen: 'assets/Pictogramas/Deportes_juegos/caballo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Guante de boxeo',
      imagen: 'assets/Pictogramas/Deportes_juegos/guante de boxeo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Bola de bolos',
      imagen: 'assets/Pictogramas/Deportes_juegos/bola de bolos.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Motorista',
      imagen: 'assets/Pictogramas/Deportes_juegos/motorista.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Voleibol',
      imagen: 'assets/Pictogramas/Deportes_juegos/voleibol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Guantes de boxeo',
      imagen: 'assets/Pictogramas/Deportes_juegos/guantes de boxeo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Palo de golf',
      imagen: 'assets/Pictogramas/Deportes_juegos/palo de golf.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugador de voleibol',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugador de voleibol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Judoka',
      imagen: 'assets/Pictogramas/Deportes_juegos/judoka.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Raqueta',
      imagen: 'assets/Pictogramas/Deportes_juegos/raqueta.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Consola',
      imagen: 'assets/Pictogramas/Deportes_juegos/consola.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Máquina recreativa',
      imagen: 'assets/Pictogramas/Deportes_juegos/máquina recreativa.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Canicas',
      imagen: 'assets/Pictogramas/Deportes_juegos/canicas.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Alfil',
      imagen: 'assets/Pictogramas/Deportes_juegos/alfil.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Paracaidismo',
      imagen: 'assets/Pictogramas/Deportes_juegos/paracaidismo.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Campo de béisbol',
      imagen: 'assets/Pictogramas/Deportes_juegos/campo de béisbol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Ganador',
      imagen: 'assets/Pictogramas/Deportes_juegos/ganador.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Béisbol',
      imagen: 'assets/Pictogramas/Deportes_juegos/béisbol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Patinador',
      imagen: 'assets/Pictogramas/Deportes_juegos/patinador.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Pelota de béisbol',
      imagen: 'assets/Pictogramas/Deportes_juegos/pelota de béisbol.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Jugador de balonmano',
      imagen: 'assets/Pictogramas/Deportes_juegos/jugador de balonmano.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Nadador',
      imagen: 'assets/Pictogramas/Deportes_juegos/nadador.png',
      categoria: 'Deportes_juegos',
    ),
    Pictograma(
      nombre: 'Pelota de tenis',
      imagen: 'assets/Pictogramas/Deportes_juegos/pelota de tenis.png',
      categoria: 'Deportes_juegos',
    ),

    Pictograma(
      nombre: 'Ácido',
      imagen: 'assets/Pictogramas/Estado/ácido.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'Agradable',
      imagen: 'assets/Pictogramas/Estado/agradable.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'Amargo',
      imagen: 'assets/Pictogramas/Estado/amargo.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'dulce',
      imagen: 'assets/Pictogramas/Estado/dulce.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'no gustar',
      imagen: 'assets/Pictogramas/Estado/no gustar.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'picante',
      imagen: 'assets/Pictogramas/Estado/picante.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'salado',
      imagen: 'assets/Pictogramas/Estado/salado.png',
      categoria: 'Estado',
    ),
    Pictograma(
      nombre: 'temperatura',
      imagen: 'assets/Pictogramas/Estado/temperatura.png',
      categoria: 'Estado',
    ),

    Pictograma(
      nombre: 'Cuaderno',
      imagen: 'assets/Pictogramas/Estudios/cuaderno.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Estuche',
      imagen: 'assets/Pictogramas/Estudios/estuche.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Lápiz y papel',
      imagen: 'assets/Pictogramas/Estudios/lápiz y papel.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Leer',
      imagen: 'assets/Pictogramas/Estudios/leer.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Escribir el título',
      imagen: 'assets/Pictogramas/Estudios/escribir el título.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Copiar',
      imagen: 'assets/Pictogramas/Estudios/copiar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Repasar',
      imagen: 'assets/Pictogramas/Estudios/repasar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Rodear',
      imagen: 'assets/Pictogramas/Estudios/rodear.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Borrar',
      imagen: 'assets/Pictogramas/Estudios/borrar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Actividades',
      imagen: 'assets/Pictogramas/Estudios/actividades.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Memory',
      imagen: 'assets/Pictogramas/Estudios/memory.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Educación física',
      imagen: 'assets/Pictogramas/Estudios/educación física.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de música',
      imagen: 'assets/Pictogramas/Estudios/clase de música.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de química',
      imagen: 'assets/Pictogramas/Estudios/clase de química.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Asignaturas',
      imagen: 'assets/Pictogramas/Estudios/asignaturas.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Visita escolar',
      imagen: 'assets/Pictogramas/Estudios/visita escolar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Grapadora',
      imagen: 'assets/Pictogramas/Estudios/grapadora.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Diccionario',
      imagen: 'assets/Pictogramas/Estudios/diccionario.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Pinturas de colores',
      imagen: 'assets/Pictogramas/Estudios/pinturas de colores.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Anotar',
      imagen: 'assets/Pictogramas/Estudios/anotar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Frase',
      imagen: 'assets/Pictogramas/Estudios/frase.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Aprobar',
      imagen: 'assets/Pictogramas/Estudios/aprobar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Completar',
      imagen: 'assets/Pictogramas/Estudios/completar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Tachar',
      imagen: 'assets/Pictogramas/Estudios/tachar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Ordenar',
      imagen: 'assets/Pictogramas/Estudios/ordenar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Manualidades',
      imagen: 'assets/Pictogramas/Estudios/manualidades.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Mapa conceptual',
      imagen: 'assets/Pictogramas/Estudios/mapa conceptual.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de ética y valores',
      imagen: 'assets/Pictogramas/Estudios/clase de ética y valores.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de biología',
      imagen: 'assets/Pictogramas/Estudios/clase de biología.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de lengua y literatura',
      imagen: 'assets/Pictogramas/Estudios/clase de lengua y literatura.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Poner la mochila',
      imagen: 'assets/Pictogramas/Estudios/poner la mochila.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Esperar',
      imagen: 'assets/Pictogramas/Estudios/esperar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Pegamento',
      imagen: 'assets/Pictogramas/Estudios/pegamento.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Calculadora',
      imagen: 'assets/Pictogramas/Estudios/calculadora.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Rotulador permanente',
      imagen: 'assets/Pictogramas/Estudios/rotulador permanente.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Pasar lista',
      imagen: 'assets/Pictogramas/Estudios/pasar lista.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Poner la fecha',
      imagen: 'assets/Pictogramas/Estudios/poner la fecha.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Correcto',
      imagen: 'assets/Pictogramas/Estudios/correcto.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Meter en la mochila',
      imagen: 'assets/Pictogramas/Estudios/meter en la mochila.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Subrayar',
      imagen: 'assets/Pictogramas/Estudios/subrayar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Terminar la tarea',
      imagen: 'assets/Pictogramas/Estudios/terminar la tarea.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Dibujo',
      imagen: 'assets/Pictogramas/Estudios/dibujo.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Examen',
      imagen: 'assets/Pictogramas/Estudios/examen.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Inglés',
      imagen: 'assets/Pictogramas/Estudios/inglés.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de economía',
      imagen: 'assets/Pictogramas/Estudios/clase de economía.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de tecnología',
      imagen: 'assets/Pictogramas/Estudios/clase de tecnología.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Quitar la mochila',
      imagen: 'assets/Pictogramas/Estudios/quitar la mochila.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Vacaciones',
      imagen: 'assets/Pictogramas/Estudios/vacaciones.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Regla',
      imagen: 'assets/Pictogramas/Estudios/regla.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Tijeras',
      imagen: 'assets/Pictogramas/Estudios/tijeras.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Bolígrafos de colores',
      imagen: 'assets/Pictogramas/Estudios/bolígrafos de colores.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Rellenar la ficha',
      imagen: 'assets/Pictogramas/Estudios/rellenar la ficha.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Ordenar secuencia',
      imagen: 'assets/Pictogramas/Estudios/ordenar secuencia.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Incorrecto',
      imagen: 'assets/Pictogramas/Estudios/incorrecto.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Sacar de la mochila',
      imagen: 'assets/Pictogramas/Estudios/sacar de la mochila.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Pintar',
      imagen: 'assets/Pictogramas/Estudios/pintar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Deberes',
      imagen: 'assets/Pictogramas/Estudios/deberes.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Estudio',
      imagen: 'assets/Pictogramas/Estudios/estudio.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de idiomas',
      imagen: 'assets/Pictogramas/Estudios/clase de idiomas.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Educación artística',
      imagen: 'assets/Pictogramas/Estudios/educación artística.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Ciencias sociales',
      imagen: 'assets/Pictogramas/Estudios/ciencias sociales.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Ciencias de la naturaleza',
      imagen: 'assets/Pictogramas/Estudios/ciencias de la naturaleza.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de física',
      imagen: 'assets/Pictogramas/Estudios/clase de física.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de matemáticas',
      imagen: 'assets/Pictogramas/Estudios/clase de matemáticas.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Cerrar la mochila',
      imagen: 'assets/Pictogramas/Estudios/cerrar la mochila.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Sacapuntas',
      imagen: 'assets/Pictogramas/Estudios/sacapuntas.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Pluma',
      imagen: 'assets/Pictogramas/Estudios/pluma.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Rotuladores',
      imagen: 'assets/Pictogramas/Estudios/rotuladores.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Escribir el nombre',
      imagen: 'assets/Pictogramas/Estudios/escribir el nombre.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Pegar',
      imagen: 'assets/Pictogramas/Estudios/pegar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Completar (1)',
      imagen: 'assets/Pictogramas/Estudios/completar (1).png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Indicar',
      imagen: 'assets/Pictogramas/Estudios/indicar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Arrugar',
      imagen: 'assets/Pictogramas/Estudios/arrugar.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Lectura',
      imagen: 'assets/Pictogramas/Estudios/lectura.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Trabajo en grupo',
      imagen: 'assets/Pictogramas/Estudios/trabajo en grupo.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de historia',
      imagen: 'assets/Pictogramas/Estudios/clase de historia.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Clase de filosofía',
      imagen: 'assets/Pictogramas/Estudios/clase de filosofía.png',
      categoria: 'Estudios',
    ),
    Pictograma(
      nombre: 'Abrir la mochila',
      imagen: 'assets/Pictogramas/Estudios/abrir la mochila.png',
      categoria: 'Estudios',
    ),

    Pictograma(
      nombre: 'Heladería',
      imagen: 'assets/Pictogramas/Lugares/heladería.png',
      categoria: 'Lugares',
    ),
    Pictograma(
      nombre: 'Pastelería',
      imagen: 'assets/Pictogramas/Lugares/pastelería.png',
      categoria: 'Lugares',
    ),

    Pictograma(
      nombre: 'Silla',
      imagen: 'assets/Pictogramas/Objetos/silla.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Cama',
      imagen: 'assets/Pictogramas/Objetos/cama.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Toallero',
      imagen: 'assets/Pictogramas/Objetos/toallero.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Duro',
      imagen: 'assets/Pictogramas/Objetos/duro.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Elástico',
      imagen: 'assets/Pictogramas/Objetos/elástico.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Grande',
      imagen: 'assets/Pictogramas/Objetos/grande.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Mineral del hierro',
      imagen: 'assets/Pictogramas/Objetos/mineral del hierro.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Piedras',
      imagen: 'assets/Pictogramas/Objetos/piedras.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Armario de cocina',
      imagen: 'assets/Pictogramas/Objetos/armario de cocina.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Sillón',
      imagen: 'assets/Pictogramas/Objetos/sillón.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Estante para libros',
      imagen: 'assets/Pictogramas/Objetos/estante para libros.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Liso',
      imagen: 'assets/Pictogramas/Objetos/liso.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Flexible',
      imagen: 'assets/Pictogramas/Objetos/flexible.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Madera',
      imagen: 'assets/Pictogramas/Objetos/madera.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Perla',
      imagen: 'assets/Pictogramas/Objetos/perla.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Cuero',
      imagen: 'assets/Pictogramas/Objetos/cuero.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Casillero',
      imagen: 'assets/Pictogramas/Objetos/casillero.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Silla de ruedas',
      imagen: 'assets/Pictogramas/Objetos/silla de ruedas.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Suave',
      imagen: 'assets/Pictogramas/Objetos/suave.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Pegajoso',
      imagen: 'assets/Pictogramas/Objetos/pegajoso.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Tamaño',
      imagen: 'assets/Pictogramas/Objetos/tamaño.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Palo',
      imagen: 'assets/Pictogramas/Objetos/palo.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Carbón',
      imagen: 'assets/Pictogramas/Objetos/carbón.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Mineral',
      imagen: 'assets/Pictogramas/Objetos/mineral.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Mecedora',
      imagen: 'assets/Pictogramas/Objetos/mecedora.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Litera',
      imagen: 'assets/Pictogramas/Objetos/litera.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Rígido',
      imagen: 'assets/Pictogramas/Objetos/rígido.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Rugoso',
      imagen: 'assets/Pictogramas/Objetos/rugoso.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Pequeño',
      imagen: 'assets/Pictogramas/Objetos/pequeño.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Tienda de minerales',
      imagen: 'assets/Pictogramas/Objetos/tienda de minerales.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Rubí',
      imagen: 'assets/Pictogramas/Objetos/rubí.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Piedra',
      imagen: 'assets/Pictogramas/Objetos/piedra.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Cajón',
      imagen: 'assets/Pictogramas/Objetos/cajón.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Escritorio',
      imagen: 'assets/Pictogramas/Objetos/escritorio.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Blando',
      imagen: 'assets/Pictogramas/Objetos/blando.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Áspero',
      imagen: 'assets/Pictogramas/Objetos/áspero.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Mediano',
      imagen: 'assets/Pictogramas/Objetos/mediano.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Tronco',
      imagen: 'assets/Pictogramas/Objetos/tronco.png',
      categoria: 'Objetos',
    ),
    Pictograma(
      nombre: 'Petróleo',
      imagen: 'assets/Pictogramas/Objetos/petróleo.png',
      categoria: 'Objetos',
    ),

    Pictograma(
      nombre: 'Magdalena',
      imagen: 'assets/Pictogramas/Postres/magdalena.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Tarta',
      imagen: 'assets/Pictogramas/Postres/tarta.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Crep',
      imagen: 'assets/Pictogramas/Postres/crep.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Croissant',
      imagen: 'assets/Pictogramas/Postres/croissant.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Merengue',
      imagen: 'assets/Pictogramas/Postres/merengue.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Muffin',
      imagen: 'assets/Pictogramas/Postres/muffin.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Dónut',
      imagen: 'assets/Pictogramas/Postres/dónut.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Cono de chocolate',
      imagen: 'assets/Pictogramas/Postres/cono de chocolate.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Flan',
      imagen: 'assets/Pictogramas/Postres/flan.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Postre',
      imagen: 'assets/Pictogramas/Postres/postre.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Bombón',
      imagen: 'assets/Pictogramas/Postres/bombón.png',
      categoria: 'Postres',
    ),
    Pictograma(
      nombre: 'Natilla',
      imagen: 'assets/Pictogramas/Postres/natilla.png',
      categoria: 'Postres',
    ),

    Pictograma(
      nombre: 'Pantalón',
      imagen: 'assets/Pictogramas/Ropa/pantalón.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Abanico',
      imagen: 'assets/Pictogramas/Ropa/abanico.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Diadema',
      imagen: 'assets/Pictogramas/Ropa/diadema.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Colorete',
      imagen: 'assets/Pictogramas/Ropa/colorete.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Zapatillas',
      imagen: 'assets/Pictogramas/Ropa/zapatillas.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Sandalias',
      imagen: 'assets/Pictogramas/Ropa/sandalias.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Gorro de fiesta',
      imagen: 'assets/Pictogramas/Ropa/gorro de fiesta.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Antifaz',
      imagen: 'assets/Pictogramas/Ropa/antifaz.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Manoplas',
      imagen: 'assets/Pictogramas/Ropa/manoplas.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Esmalte de uñas',
      imagen: 'assets/Pictogramas/Ropa/esmalte de uñas.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Camiseta',
      imagen: 'assets/Pictogramas/Ropa/camiseta.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Camisa',
      imagen: 'assets/Pictogramas/Ropa/camisa.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Bota',
      imagen: 'assets/Pictogramas/Ropa/bota.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Monedero',
      imagen: 'assets/Pictogramas/Ropa/monedero.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Laca',
      imagen: 'assets/Pictogramas/Ropa/laca.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Corona',
      imagen: 'assets/Pictogramas/Ropa/corona.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Camisón',
      imagen: 'assets/Pictogramas/Ropa/camisón.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Braga',
      imagen: 'assets/Pictogramas/Ropa/braga.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Mancha',
      imagen: 'assets/Pictogramas/Ropa/mancha.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Sombra de ojos',
      imagen: 'assets/Pictogramas/Ropa/sombra de ojos.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Pintalabios',
      imagen: 'assets/Pictogramas/Ropa/pintalabios.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Botas',
      imagen: 'assets/Pictogramas/Ropa/botas.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Guantes',
      imagen: 'assets/Pictogramas/Ropa/guantes.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Blusa',
      imagen: 'assets/Pictogramas/Ropa/blusa.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Capucha',
      imagen: 'assets/Pictogramas/Ropa/capucha.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Pasador',
      imagen: 'assets/Pictogramas/Ropa/pasador.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Coletero',
      imagen: 'assets/Pictogramas/Ropa/coletero.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Corbata',
      imagen: 'assets/Pictogramas/Ropa/corbata.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Pulsera',
      imagen: 'assets/Pictogramas/Ropa/pulsera.png',
      categoria: 'Ropa',
    ),
    Pictograma(
      nombre: 'Babero',
      imagen: 'assets/Pictogramas/Ropa/babero.png',
      categoria: 'Ropa',
    ),

    Pictograma(
      nombre: 'Lugar',
      imagen: 'assets/Pictogramas/Varios/lugar.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Verduras',
      imagen: 'assets/Pictogramas/Varios/verduras.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Comida',
      imagen: 'assets/Pictogramas/Varios/comida.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Postre',
      imagen: 'assets/Pictogramas/Varios/postre.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Equipaje',
      imagen: 'assets/Pictogramas/Varios/equipaje.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Productos de apoyo',
      imagen: 'assets/Pictogramas/Varios/productos de apoyo.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Aparatos y muebles',
      imagen: 'assets/Pictogramas/Varios/aparatos y muebles.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Juego y deporte',
      imagen: 'assets/Pictogramas/Varios/juego y deporte.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Juguetes',
      imagen: 'assets/Pictogramas/Varios/juguetes.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Animales terrestres',
      imagen: 'assets/Pictogramas/Varios/animales terrestres.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Formas (1)',
      imagen: 'assets/Pictogramas/Varios/formas (1).png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Formas',
      imagen: 'assets/Pictogramas/Varios/formas.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Animales marinos',
      imagen: 'assets/Pictogramas/Varios/animales marinos.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Muebles',
      imagen: 'assets/Pictogramas/Varios/muebles.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Tiempo libre',
      imagen: 'assets/Pictogramas/Varios/tiempo libre.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Clima',
      imagen: 'assets/Pictogramas/Varios/clima.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Mascotas',
      imagen: 'assets/Pictogramas/Varios/mascotas.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Anfibios',
      imagen: 'assets/Pictogramas/Varios/anfibios.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Aves',
      imagen: 'assets/Pictogramas/Varios/aves.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Protector solar',
      imagen: 'assets/Pictogramas/Varios/protector solar.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Hoguera',
      imagen: 'assets/Pictogramas/Varios/hoguera.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Brújula',
      imagen: 'assets/Pictogramas/Varios/brújula.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Animales aéreos',
      imagen: 'assets/Pictogramas/Varios/animales aéreos.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Seres vivos',
      imagen: 'assets/Pictogramas/Varios/seres vivos.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Insectos',
      imagen: 'assets/Pictogramas/Varios/insectos.png',
      categoria: 'Varios',
    ),
    Pictograma(
      nombre: 'Cuerda',
      imagen: 'assets/Pictogramas/Varios/cuerda.png',
      categoria: 'Varios',
    ),

    Pictograma(
      nombre: 'Cerezas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/cerezas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Piña',
      imagen: 'assets/Pictogramas/Vegetales_frutas/piña.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Arroz',
      imagen: 'assets/Pictogramas/Vegetales_frutas/arroz.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Mango',
      imagen: 'assets/Pictogramas/Vegetales_frutas/mango.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Coco',
      imagen: 'assets/Pictogramas/Vegetales_frutas/coco.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Cereza',
      imagen: 'assets/Pictogramas/Vegetales_frutas/cereza.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Pipas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/pipas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Moras',
      imagen: 'assets/Pictogramas/Vegetales_frutas/moras.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Pepino',
      imagen: 'assets/Pictogramas/Vegetales_frutas/pepino.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Almendras',
      imagen: 'assets/Pictogramas/Vegetales_frutas/almendras.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Ensalada',
      imagen: 'assets/Pictogramas/Vegetales_frutas/ensalada.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Tomate',
      imagen: 'assets/Pictogramas/Vegetales_frutas/tomate.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Col de Bruselas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/col de Bruselas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Manzana',
      imagen: 'assets/Pictogramas/Vegetales_frutas/manzana.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Banana',
      imagen: 'assets/Pictogramas/Vegetales_frutas/banana.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Puerro',
      imagen: 'assets/Pictogramas/Vegetales_frutas/puerro.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Racimo de uvas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/racimo de uvas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Kiwi',
      imagen: 'assets/Pictogramas/Vegetales_frutas/kiwi.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Ciruelas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/ciruelas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Espárragos',
      imagen: 'assets/Pictogramas/Vegetales_frutas/espárragos.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Fresa',
      imagen: 'assets/Pictogramas/Vegetales_frutas/fresa.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Manzana roja',
      imagen: 'assets/Pictogramas/Vegetales_frutas/manzana roja.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Canela',
      imagen: 'assets/Pictogramas/Vegetales_frutas/canela.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Mandarina',
      imagen: 'assets/Pictogramas/Vegetales_frutas/mandarina.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Aceituna',
      imagen: 'assets/Pictogramas/Vegetales_frutas/aceituna.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Guindilla',
      imagen: 'assets/Pictogramas/Vegetales_frutas/guindilla.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Castañas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/castañas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Higo',
      imagen: 'assets/Pictogramas/Vegetales_frutas/higo.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Calabacín',
      imagen: 'assets/Pictogramas/Vegetales_frutas/calabacín.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Sandía',
      imagen: 'assets/Pictogramas/Vegetales_frutas/sandía.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Melón',
      imagen: 'assets/Pictogramas/Vegetales_frutas/melón.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Uvas negras',
      imagen: 'assets/Pictogramas/Vegetales_frutas/uvas negras.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Brócoli',
      imagen: 'assets/Pictogramas/Vegetales_frutas/brócoli.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Frambuesas',
      imagen: 'assets/Pictogramas/Vegetales_frutas/frambuesas.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Mora',
      imagen: 'assets/Pictogramas/Vegetales_frutas/mora.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Alcachofa',
      imagen: 'assets/Pictogramas/Vegetales_frutas/alcachofa.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Avellana',
      imagen: 'assets/Pictogramas/Vegetales_frutas/avellana.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Col',
      imagen: 'assets/Pictogramas/Vegetales_frutas/col.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Calabaza',
      imagen: 'assets/Pictogramas/Vegetales_frutas/calabaza.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Zanahoria',
      imagen: 'assets/Pictogramas/Vegetales_frutas/zanahoria.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Patata',
      imagen: 'assets/Pictogramas/Vegetales_frutas/patata.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Diente de ajo',
      imagen: 'assets/Pictogramas/Vegetales_frutas/diente de ajo.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Cáscara',
      imagen: 'assets/Pictogramas/Vegetales_frutas/cáscara.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Arándanos',
      imagen: 'assets/Pictogramas/Vegetales_frutas/arándanos.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Aguacate',
      imagen: 'assets/Pictogramas/Vegetales_frutas/aguacate.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Pistachos',
      imagen: 'assets/Pictogramas/Vegetales_frutas/pistachos.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Nuez',
      imagen: 'assets/Pictogramas/Vegetales_frutas/nuez.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Pepinillos',
      imagen: 'assets/Pictogramas/Vegetales_frutas/pepinillos.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Berenjena',
      imagen: 'assets/Pictogramas/Vegetales_frutas/berenjena.png',
      categoria: 'Vegetales_frutas',
    ),
    Pictograma(
      nombre: 'Lechuga',
      imagen: 'assets/Pictogramas/Vegetales_frutas/lechuga.png',
      categoria: 'Vegetales_frutas',
    ),
  ];
  Future<void> agregarPictogramaPersonalizado() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final nombre = await pedirNombre();
      if (nombre == null || nombre.isEmpty) return;

      final directory = await getApplicationDocumentsDirectory();
      final path = p.join(directory.path, p.basename(pickedFile.path));
      await File(pickedFile.path).copy(path);

      final nuevo = Pictograma(
        nombre: nombre,
        imagen: path,
        categoria: 'Personalizados',
      );

      final prefs = await SharedPreferences.getInstance();
      final personalizados =
          prefs.getStringList('pictogramas_personalizados') ?? [];
      personalizados.add(
        jsonEncode({
          'nombre': nombre,
          'imagen': path,
          'categoria': 'Personalizados',
        }),
      );
      await prefs.setStringList('pictogramas_personalizados', personalizados);

      setState(() {
        pictogramas.add(nuevo);
      });
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

  Future<void> generarYLeerFrase() async {
    if (seleccionados.isEmpty) return;

    final prompt =
        "Genera una frase corta y natural como si fuera dicha por un niño, usando: ${seleccionados.map((p) => p.nombre).join(', ')}.";

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiApiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "max_tokens": 60,
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final texto = data['choices'][0]['message']['content'];
      await flutterTts.setLanguage("es-MX");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(texto.trim());
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al generar la frase.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Pictograma>> porCategoria = {};
    for (var p in pictogramas) {
      final c = p.categoria ?? 'Otros';
      porCategoria.putIfAbsent(c, () => []).add(p);
    }

    final filtrados = query.isEmpty
        ? porCategoria
        : {
            'Resultados': pictogramas
                .where(
                  (p) => p.nombre.toLowerCase().contains(query.toLowerCase()),
                )
                .toList(),
          };

    return DefaultTabController(
      length: filtrados.keys.length,
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          title: Text('Exprésate'),
          centerTitle: true,
          backgroundColor: Color(0xFFFFAB91),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: agregarPictogramaPersonalizado,
              color: Colors.black,
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black87,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: filtrados.keys.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar pictograma...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) => setState(() => query = value),
              ),
            ),
            if (seleccionados.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: seleccionados.map((p) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => seleccionados.remove(p));
                            },
                            child: p.imagen.startsWith('assets')
                                ? Image.asset(p.imagen, height: 40)
                                : Image.file(File(p.imagen), height: 40),
                          ),
                          Text(p.nombre, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (seleccionados.isNotEmpty)
              ElevatedButton(
                onPressed: generarYLeerFrase,
                child: Text("Leer con IA"),
              ),
            Expanded(
              child: TabBarView(
                children: filtrados.keys.map((categoria) {
                  final lista = filtrados[categoria]!;
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final p = lista[index];
                      return GestureDetector(
                        onTap: () => setState(() => seleccionados.add(p)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFAB91),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              p.imagen.startsWith('assets')
                                  ? Image.asset(p.imagen, height: 50)
                                  : Image.file(File(p.imagen), height: 50),
                              const SizedBox(height: 8),
                              Text(
                                p.nombre,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
