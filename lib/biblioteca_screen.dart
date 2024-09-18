import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Book {
  final String title;
  final String author;
  final bool isDigital;
  bool isAvailable;

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
    Book(title: "Software Engineering", author: "Alice Brown", isDigital: false, isAvailable: true),
    Book(title: "Database Systems", author: "Charlie Davis", isDigital: true, isAvailable: true),
  ];

  int _borrowedBooks = 0;
  double _pendingFines = 15.0;
  List<CreditCard> _savedCards = [];
  CreditCard? _selectedCard;

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('credit_cards');
    if (cardsJson != null) {
      final List<dynamic> decodedList = json.decode(cardsJson);
      setState(() {
        _savedCards = decodedList.map((item) => CreditCard.fromJson(item)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Biblioteca UFES',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
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
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livros emprestados: $_borrowedBooks/5',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Multas pendentes: R\$ ${_pendingFines.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (_pendingFines > 0)
            ElevatedButton(
              onPressed: _showPaymentOptions,
              child: const Text('Pagar Multa'),
            ),
        ],
      ),
    );
  }

  Widget _buildBookItem(Book book) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.author),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(book.isDigital ? Icons.computer : Icons.book, color: Colors.blue),
          const SizedBox(width: 8),
          Icon(book.isDigital || book.isAvailable ? Icons.check_circle : Icons.remove_circle,
              color: book.isDigital || book.isAvailable ? Colors.green : Colors.red),
        ],
      ),
      onTap: () => _showBookDetails(book),
    );
  }

  void _showBookDetails(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(book.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Autor: ${book.author}'),
              Text('Tipo: ${book.isDigital ? 'Digital' : 'Físico'}'),
              Text('Status: ${book.isDigital ? 'Disponível Online' : (book.isAvailable ? 'Disponível' : 'Indisponível')}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (!book.isDigital && book.isAvailable && !widget.isServidor && _borrowedBooks < 5)
              TextButton(
                child: const Text('Emprestar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _borrowBook(book);
                },
              ),
            if (book.isDigital)
              TextButton(
                child: const Text('Acessar Online'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _accessDigitalBook(book);
                },
              ),
          ],
        );
      },
    );
  }

  void _borrowBook(Book book) {
    if (_borrowedBooks < 5 && book.isAvailable && !book.isDigital) {
      setState(() {
        _borrowedBooks++;
        book.isAvailable = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livro "${book.title}" emprestado com sucesso!')),
      );
    } else if (!book.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este livro já está emprestado.')),
      );
    } else if (book.isDigital) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livros digitais não podem ser emprestados. Por favor, acesse online.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite de empréstimos atingido! Não é possível emprestar mais livros.')),
      );
    }
  }

  void _accessDigitalBook(Book book) async {
    final url = 'https://bibliotecas-digitais.ufes.br${book.title.replaceAll(' ', '-')}';  // Link fictício
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showPaymentOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opções de Pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _showPixPayment,
                child: const Text('Pagar com PIX'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _savedCards.isNotEmpty ? _showCreditCardPayment : _showAddCreditCardForm,
                child: Text(_savedCards.isNotEmpty ? 'Pagar com Cartão de Crédito' : 'Adicionar Cartão de Crédito'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPixPayment() {
    const String pixKey = 'biblioteca@ufes.br';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pagamento via PIX'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Use a chave PIX abaixo para fazer o pagamento:'),
              const SizedBox(height: 10),
              const SelectableText(pixKey, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Valor a pagar: R\$ ${_pendingFines.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirmar Pagamento'),
              onPressed: () {
                _processPendingFines();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreditCardPayment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Pagamento com Cartão de Crédito'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<CreditCard>(
                    value: _selectedCard,
                    items: _savedCards.map((card) {
                      return DropdownMenuItem<CreditCard>(
                        value: card,
                        child: Text('**** **** **** ${card.lastFourDigits}'),
                      );
                    }).toList(),
                    onChanged: (CreditCard? value) {
                      setState(() {
                        _selectedCard = value;
                      });
                    },
                    hint: const Text('Selecione um cartão'),
                  ),
                  const SizedBox(height: 10),
                  Text('Valor a pagar: R\$ ${_pendingFines.toStringAsFixed(2)}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Confirmar Pagamento'),
                  onPressed: () {
                    _processPendingFines();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _processPendingFines() {
    setState(() {
      _pendingFines = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pagamento realizado com sucesso!')),
    );
  }

  void _showAddCreditCardForm() {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController cardHolderController = TextEditingController();
    final TextEditingController expirationController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Cartão de Crédito'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: 'Número do Cartão'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cardHolderController,
                  decoration: const InputDecoration(labelText: 'Nome no Cartão'),
                ),
                TextField(
                  controller: expirationController,
                  decoration: const InputDecoration(labelText: 'Data de Expiração (MM/AA)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                final newCard = CreditCard(
                  lastFourDigits: cardNumberController.text.substring(cardNumberController.text.length - 4),
                  cardHolderName: cardHolderController.text,
                  expiryDate: expirationController.text,
                );
                setState(() {
                  _savedCards.add(newCard);
                });
                final prefs = await SharedPreferences.getInstance();
                final String cardsJson = json.encode(_savedCards.map((card) => card.toJson()).toList());
                await prefs.setString('credit_cards', cardsJson);
                Navigator.of(context).pop();
                _showCreditCardPayment();
              },
            ),
          ],
        );
      },
    );
  }
}

class CreditCard {
  final String lastFourDigits;
  final String cardHolderName;
  final String expiryDate;

  CreditCard({required this.lastFourDigits, required this.cardHolderName, required this.expiryDate});

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      lastFourDigits: json['lastFourDigits'],
      cardHolderName: json['cardHolderName'],
      expiryDate: json['expiryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastFourDigits': lastFourDigits,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
    };
  }
}