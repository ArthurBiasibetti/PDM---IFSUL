import 'package:flutter/material.dart';
import 'package:trabalho_2/Banco/banco.dart';
import 'package:trabalho_2/Page/ImageForm.dart';

class ImageDescription extends StatefulWidget {
  final int imageId;

  const ImageDescription({
    super.key,
    required this.imageId,
  });

  @override
  State<ImageDescription> createState() => _ImageDescriptionState();
}

class _ImageDescriptionState extends State<ImageDescription> {
  var banco = Banco(() {
    print('Erro ao conectar');
  });
  String imageUrl = '';
  String imageDescription = '';

  void _setUrl(String url) {
    setState(() {
      imageUrl = url;
    });
  }

  void _setDescription(String description) {
    setState(() {
      imageDescription = description;
    });
  }

  _getImage() {
    banco.query('select * from tb_images where id = ${widget.imageId}',
        (num, result) {
      if (num > 0) {
        _setUrl(result[0]['tb_images']['url']);
        _setDescription(result[0]['tb_images']['description']);
      }
    }, () {
      print('Erro ao buscar imagem');
    });
  }

  _deleteImage() {
    banco.query("delete from tb_images where id = ${widget.imageId}",
        (num, result) {
      Navigator.pop(context, true);
    }, () {
      print('Erro ao excluir imagem!');
    });
  }

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  @override
  Widget build(BuildContext context) {
    banco = Banco((e) => print('Não foi possível estabelecer conexão - $e'));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.fill),
              ),
              width: 240,
              height: 240,
            ),
            Text(imageDescription),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: _deleteImage,
                        child: const Text('Excluir imagem'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageForm(imageId: widget.imageId),
                          ),
                        ).then((value) => value && _getImage()),
                        child: const Text('Editar'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Voltar'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
