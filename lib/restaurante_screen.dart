import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RestauranteUniversitarioScreen extends StatefulWidget {
  const RestauranteUniversitarioScreen({Key? key}) : super(key: key);

  @override
  _RestauranteUniversitarioScreenState createState() => _RestauranteUniversitarioScreenState();
}

class _RestauranteUniversitarioScreenState extends State<RestauranteUniversitarioScreen> {
  int _selectedDay = DateTime.now().weekday - 1;
  final List<String> _weekdays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta'];
  final String _pixKey = 'a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _hasRegisteredCard = false;
  String? _registeredCardNumber;

  final Map<int, Map<String, String>> _menuItems = {
    0: {'Prato principal': 'Frango grelhado', 'Acompanhamento': 'Arroz e feijão', 'Salada': 'Mix de folhas', 'Sobremesa': 'Gelatina'},
    1: {'Prato principal': 'Bife acebolado', 'Acompanhamento': 'Purê de batata', 'Salada': 'Tomate e alface', 'Sobremesa': 'Pudim'},
    2: {'Prato principal': 'Peixe assado', 'Acompanhamento': 'Arroz e legumes', 'Salada': 'Cenoura ralada', 'Sobremesa': 'Frutas'},
    3: {'Prato principal': 'Feijoada', 'Acompanhamento': 'Arroz e farofa', 'Salada': 'Couve', 'Sobremesa': 'Laranja'},
    4: {'Prato principal': 'Lasanha', 'Acompanhamento': 'Salada verde', 'Salada': 'Beterraba', 'Sobremesa': 'Mousse'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurante Universitário'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDaySelector(),
              const SizedBox(height: 20),
              _buildMenu(),
              const SizedBox(height: 20),
              _buildPaymentOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weekdays.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(_weekdays[index]),
              selected: _selectedDay == index,
              onSelected: (selected) {
                setState(() {
                  _selectedDay = index;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenu() {
    final menu = _menuItems[_selectedDay];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menu!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${entry.key}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(entry.value)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Opções de Pagamento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _showPixPayment(),
          child: const Text('Pagar com PIX'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _hasRegisteredCard ? _showCreditCardPayment : _showCreditCardForm,
          child: Text(_hasRegisteredCard ? 'Pagar com Cartão de Crédito' : 'Cadastrar Cartão de Crédito'),
        ),
      ],
    );
  }

  void _showPixPayment() {
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
              SelectableText(_pixKey, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreditCardForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastrar Cartão de Crédito'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: 'Número do Cartão'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(labelText: 'Nome no Cartão'),
                ),
                TextField(
                  controller: _expirationController,
                  decoration: const InputDecoration(labelText: 'Data de Expiração (MM/AA)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                // Aqui implementaremos a lógica para validar e salvar o cartão
                setState(() {
                  _hasRegisteredCard = true;
                  _registeredCardNumber = _cardNumberController.text;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cartão salvo com sucesso!')),
                );
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
        return AlertDialog(
          title: const Text('Pagamento com Cartão de Crédito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cartão registrado: **** **** **** ${_registeredCardNumber!.substring(_registeredCardNumber!.length - 4)}'),
              const SizedBox(height: 10),
              const Text('Valor da refeição: R\$ 5,00'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar Pagamento'),
              onPressed: () {
                // Aqui implementaremos a lógica para processar o pagamento
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pagamento realizado com sucesso!')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}