import 'package:flutter/material.dart';
import 'package:trabalho_2/Banco/banco.dart';
import 'package:trabalho_2/globals/globals.dart' as globals;

class ImageForm extends StatefulWidget {
  const ImageForm({super.key, this.imageId});
  final int? imageId;

  @override
  State<ImageForm> createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  final _formKey = GlobalKey<FormState>();
  final _formUrl = TextEditingController();
  final _formDescription = TextEditingController();
  final fUrl = FocusNode();
  final fDescription = FocusNode();

  var banco = Banco(() {
    print('Erro ao conectar');
  });

  String _imageUrl = '';

  void _setCurrentImage() {
    setState(() {
      _imageUrl = _formUrl.text;
    });
  }

  String? _validateURL(String? value) {
    if (value!.length > 0) {
      return null;
    }

    return "URL não pode ser vazia";
  }

  _saveImage(BuildContext context) {
    banco.query(
      "insert into tb_images (url, owner, description) values ('${_formUrl.text}', ${globals.user_id}, '${_formDescription.text}')",
      (num, result) {
        Navigator.pop(context, true);
      },
      () {
        print("Erro ao salvar imagem");
      },
    );
  }

  _updateImage(BuildContext context) {
    banco.query(
        "update tb_images set url = '${_formUrl.text}', description = '${_formDescription.text}' where id = ${widget.imageId}",
        (num, result) {
      Navigator.pop(context, true);
    }, () {
      print('erro ao atualizar imagem!');
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.imageId != null) {
      banco.query("select * from tb_images where id = ${widget.imageId}",
          (num, result) {
        if (num > 0) {
          var imageData = result[0]['tb_images'];

          _formUrl.text = imageData['url'];
          _formDescription.text = imageData['description'];

          _setCurrentImage();
        }
      }, () {
        print('Erro ao buscar imagem!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Adicionar imagem'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                      image: _imageUrl.isEmpty
                          ? const AssetImage('assets/foto1.jpg')
                              as ImageProvider
                          : NetworkImage(_imageUrl),
                      fit: BoxFit.fill),
                ),
                width: 240,
                height: 240,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _formUrl,
                  focusNode: fUrl,
                  validator: _validateURL,
                  autofocus: true,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: const Text("Url da imagem"),
                    hintText: "Digite a URL",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _formDescription,
                  focusNode: fDescription,
                  autofocus: true,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: const Text("Descrição"),
                    hintText: "Digite a descrição",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _setCurrentImage,
                child: const Text("Testar imagem"),
              ),
              ElevatedButton(
                onPressed: () {
                  bool validity = _formKey.currentState!.validate();
                  if (validity) {
                    if (widget.imageId != null) {
                      _updateImage(context);
                    } else {
                      _saveImage(context);
                    }
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
