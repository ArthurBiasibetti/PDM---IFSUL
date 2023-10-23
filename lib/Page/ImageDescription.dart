import 'package:flutter/material.dart';
import 'package:trabalho_2/Banco/banco.dart';

class ImageDescription extends StatefulWidget {
  final String imageUrl;
  final String imageDescription;
  final bool isNetworkImage;

  const ImageDescription({
    super.key,
    required this.imageUrl,
    required this.imageDescription,
    this.isNetworkImage = false,
  });

  @override
  State<ImageDescription> createState() => _ImageDescriptionState();
}

class _ImageDescriptionState extends State<ImageDescription> {
  var banco;

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
                    image: widget.isNetworkImage
                        ? NetworkImage(widget.imageUrl)
                        : AssetImage(widget.imageUrl) as ImageProvider,
                    fit: BoxFit.fill),
              ),
              width: 240,
              height: 240,
            ),
            Text(widget.imageDescription),
            FloatingActionButton(
              onPressed: () => buscarPessoa(),
              child: const Text('Buscar Dados'),
            ),
            FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            )
          ],
        ),
      ),
    );
  }

  buscarPessoa() {
    banco?.query('select * from tb_pessoa', (numR, result) {
      if (numR > 0) {
        for (var row in result) {
          print("---------------------------------");
          print(row);
        }
      }
    }, (e) => print('Erro: $e'));
  }
}
