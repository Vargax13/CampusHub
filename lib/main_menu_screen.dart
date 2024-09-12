import 'package:flutter/material.dart';
import 'jornal_academico_screen.dart';
import 'mapa_campus_screen.dart';
import 'biblioteca_screen.dart';
import 'restaurante_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final bool isServidor;

  const MainMenuScreen({Key? key, required this.isServidor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal UFES'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildMenuOption(context, 'Restaurante Universitário', Icons.restaurant),
            _buildMenuOption(context, 'Biblioteca', Icons.library_books),
            _buildMenuOption(context, 'Mapa do Campus', Icons.map),
            _buildMenuOption(context, 'Jornal Acadêmico', Icons.newspaper),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Jornal Acadêmico') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => JornalAcademicoScreen(isServidor: isServidor),
              ),
            );
          } else if (title == 'Mapa do Campus') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MapaCampusScreen(),
              ),
            );
          } else if (title == 'Biblioteca') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BibliotecaScreen(isServidor: isServidor),
              ),
            );
          } else if (title == 'Restaurante Universitário') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RestauranteUniversitarioScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Você selecionou: $title')),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF003366)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}