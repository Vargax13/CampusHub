import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final bool isDigital;
  final bool isAvailable;

  Book({required this.title, required this.author, required this.isDigital, required this.isAvailable});
}

class BibliotecaScreen extends StatefulWidget {
  final bool isServidor;

  const BibliotecaScreen({Key? key, required this.isServidor}) : super(key: key);

  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  final List<Book> _books = [
    Book(title: "Flutter Development", author: "John Doe", isDigital: true, isAvailable: true),
    Book(title: "Dart Programming", author: "Jane Smith", isDigital: false, isAvailable: true),
    Book(title: "Mobile App Design", author: "Bob Johnson", isDigital: true, isAvailable: true),
    Book(title: "Software Engineering", author: "Alice Brown", isDigital: false, isAvailable: false),
    Book(title: "Database Systems", author: "Charlie Davis", isDigital: true, isAvailable: true),
  ];

  int _borrowedBooks = 3;
  double _pendingFines = 15.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca UFES'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Column(
        children: [
          _buildUserInfo(),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return _buildBookItem(_books[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livros emprestados: $_borrowedBooks/5',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Multas pendentes: R\$ ${_pendingFines.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBookItem(Book book) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(book.title),
        subtitle: Text(book.author),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(book.isDigital ? 'Digital' : 'Físico'),
            Text(
              book.isAvailable ? 'Disponível' : 'Indisponível',
              style: TextStyle(
                color: book.isAvailable ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onTap: () {
          _showBookDetails(book);
        },
      ),
    );
  }

  void _showBookDetails(Book book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Autor: ${book.author}'),
              Text('Tipo: ${book.isDigital ? 'Digital' : 'Físico'}'),
              Text('Status: ${book.isAvailable ? 'Disponível' : 'Indisponível'}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (book.isAvailable && !book.isDigital && _borrowedBooks < 5)
              TextButton(
                child: const Text('Emprestar'),
                onPressed: () {
                  setState(() {
                    _borrowedBooks++;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Livro emprestado com sucesso!')),
                  );
                },
              ),
            if (book.isDigital)
              TextButton(
                child: const Text('Ler Online'),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo livro para leitura online...')),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}