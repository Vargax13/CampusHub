import 'package:flutter/material.dart';

class GerenciarCartoesScreen extends StatefulWidget {
  const GerenciarCartoesScreen({Key? key}) : super(key: key);

  @override
  _GerenciarCartoesScreenState createState() => _GerenciarCartoesScreenState();
}

class _GerenciarCartoesScreenState extends State<GerenciarCartoesScreen> {
  List<CreditCard> cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Cartões'),
        backgroundColor: const Color(0xFF003366),
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
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF003366),
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
                if (cardNumber.isNotEmpty && cardHolderName.isNotEmpty) {
                  setState(() {
                    cards.add(CreditCard(
                      lastFourDigits: cardNumber.substring(cardNumber.length - 4),
                      cardHolderName: cardHolderName,
                    ));
                  });
                  Navigator.of(context).pop();
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

  CreditCard({required this.lastFourDigits, required this.cardHolderName});
}