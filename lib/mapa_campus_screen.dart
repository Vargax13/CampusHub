import 'package:flutter/material.dart';

class MapaCampusScreen extends StatelessWidget {
  const MapaCampusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa do Campus UFES - São Mateus'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Campus de São Mateus',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                'assets/mapa_ufes_sao_mateus.png',
                fit: BoxFit.contain,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Arraste para mover. Faça pinça para zoom.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}