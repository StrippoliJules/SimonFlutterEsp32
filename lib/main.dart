import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu ESP32',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Jeu ESP32'),
        ),
        body: GameControl(),
      ),
    );
  }
}

class GameControl extends StatefulWidget {
  @override
  _GameControlState createState() => _GameControlState();
}

class _GameControlState extends State<GameControl> {
  final String esp32Ip = 'http://192.168.x.x';
  int score = 0;
  bool gameStarted = false;

  Future<void> startGame() async {
    final response = await http.get(Uri.parse('$esp32Ip/start'));
    if (response.statusCode == 200) {
      setState(() {
        gameStarted = true;
        score = 0;
      });
      getScore();
    } else {
      print('Erreur lors du démarrage du jeu');
    }
  }

  Future<void> getScore() async {
    while (gameStarted) {
      final response = await http.get(Uri.parse('$esp32Ip/score'));
      if (response.statusCode == 200) {
        setState(() {
          score = int.parse(response.body);
        });
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score : $score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: startGame,
            child: Text('Play'),
          ),
        ],
      ),
    );
  }
}
