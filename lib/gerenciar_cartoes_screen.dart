import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GerenciarCartoesScreen extends StatefulWidget {
  const GerenciarCartoesScreen({Key? key}) : super(key: key);

  @override
  _GerenciarCartoesScreenState createState() => _GerenciarCartoesScreenState();
}

class _GerenciarCartoesScreenState extends State<GerenciarCartoesScreen> {
  List<CreditCard> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('credit_cards');
    if (cardsJson != null) {
      final List<dynamic> decodedList = json.decode(cardsJson);
      setState(() {
        cards = decodedList.map((item) => CreditCard.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String cardsJson = json.encode(cards.map((card) => card.toJson()).toList());
    await prefs.setString('credit_cards', cardsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerenciar Cartões',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),  // Define a cor da seta para branca
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.credit_card),
            title: Text('**** **** **** ${cards[index].lastFourDigits}'),
            subtitle: Text(cards[index].cardHolderName),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  cards.removeAt(index);
                  _saveCards();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String cardNumber = '';
        String cardHolderName = '';
        String expiryDate = '';
        String cvv = '';

        return AlertDialog(
          title: const Text('Adicionar Novo Cartão'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Número do Cartão'),
                  onChanged: (value) => cardNumber = value,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Nome do Titular'),
                  onChanged: (value) => cardHolderName = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Data de Expiração (MM/AA)'),
                  onChanged: (value) => expiryDate = value,
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'CVV'),
                  onChanged: (value) => cvv = value,
                  keyboardType: TextInputType.number,
                  obscureText: true,
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
              child: const Text('Adicionar'),
              onPressed: () {
                if (cardNumber.isNotEmpty && cardHolderName.isNotEmpty && expiryDate.isNotEmpty && cvv.isNotEmpty) {
                  setState(() {
                    cards.add(CreditCard(
                      lastFourDigits: cardNumber.substring(cardNumber.length - 4),
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                    ));
                    _saveCards();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, preencha todos os campos.')),
                  );
                }
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