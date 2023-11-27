import 'package:flutter/material.dart';
import 'package:trabalho_2/Banco/banco.dart';
import 'package:trabalho_2/Page/ImageDescription.dart';
import 'package:trabalho_2/Page/ImageForm.dart';
import 'package:trabalho_2/Page/LoginPage.dart';
import 'package:trabalho_2/carousel/carousel.dart';
import 'globals/globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _images = [];
  var banco = Banco((e) => print('Não foi possível estabelecer conexão - $e'));

  void _setImages(List<dynamic> images) {
    setState(() {
      _images = images;
    });
  }

  _getImages() {
    if (globals.user_id != null) {
      banco.query(
        "select * from tb_images where owner = '${globals.user_id}' order by id",
        (num, result) {
          var images = result.map((e) => e['tb_images']).toList();
          _setImages(images);
        },
        () {
          print('Erro ao buscar imagens');
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Utiliza do widget Carousel criado
            _images.isNotEmpty
                ? Carousel(
                    children: _images
                        .map(
                          (image) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageDescription(
                                    imageId: image['id'],
                                  ),
                                ),
                              ).then((value) => _getImages());
                            },
                            child: Container(
                              foregroundDecoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(image['url']),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                        )
                        .toList())
                : const Text('Sem imagens na Lista'),

            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ImageForm()),
                  ).then((value) => _getImages());
                },
                child: const Text("Adicionar Imagem"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
