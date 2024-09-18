import 'package:flutter/material.dart';

class Post {
  final String title;
  final String content;
  final String author;
  final DateTime date;

  Post({required this.title, required this.content, required this.author, required this.date});
}

class JornalAcademicoScreen extends StatefulWidget {
  final bool isServidor;

  const JornalAcademicoScreen({Key? key, required this.isServidor}) : super(key: key);

  @override
  _JornalAcademicoScreenState createState() => _JornalAcademicoScreenState();
}

class _JornalAcademicoScreenState extends State<JornalAcademicoScreen> {
  final List<Post> _posts = [
    Post(
      title: "Novo laboratório de pesquisa",
      content: "A UFES inaugurou um novo laboratório de pesquisa em inteligência artificial...",
      author: "Prof. Silva",
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Post(
      title: "Inscrições abertas para intercâmbio",
      content: "Estão abertas as inscrições para o programa de intercâmbio internacional...",
      author: "Departamento de Relações Internacionais",
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jornal Acadêmico UFES',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),  // Define a cor da seta para branca
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(_posts[index].title),
                    subtitle: Text(
                      '${_posts[index].author} - ${_posts[index].date.day}/${_posts[index].date.month}/${_posts[index].date.year}',
                    ),
                    onTap: () {
                      _showPostDetails(_posts[index], index);
                    },
                    trailing: widget.isServidor
                        ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(index),
                    )
                        : null,
                  ),
                );
              },
            ),
          ),
          if (widget.isServidor)
            ElevatedButton(
              child: const Text('Nova Postagem'),
              onPressed: () {
                _showNewPostDialog();
              },
            ),
        ],
      ),
    );
  }

  void _showPostDetails(Post post, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(post.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(post.content),
                const SizedBox(height: 16),
                Text('Autor: ${post.author}'),
                Text('Data: ${post.date.day}/${post.date.month}/${post.date.year}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (widget.isServidor)
              TextButton(
                child: const Text('Apagar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(index);
                },
              ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja apagar esta publicação?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Apagar'),
              onPressed: () {
                setState(() {
                  _posts.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNewPostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Postagem'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Conteúdo'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o conteúdo';
                    }
                    return null;
                  },
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
              child: const Text('Publicar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _posts.insert(
                      0,
                      Post(
                        title: _titleController.text,
                        content: _contentController.text,
                        author: 'Administração', // Você pode personalizar isso
                        date: DateTime.now(),
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                  _titleController.clear();
                  _contentController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}