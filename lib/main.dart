import 'package:flutter/material.dart';
import 'package:trabalho_2/Page/ImageDescription.dart';
import 'package:trabalho_2/Page/LoginPage.dart';
import 'package:trabalho_2/carousel/carousel.dart';

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
            Carousel(children: [
              //Utiliza dos assets foto1, foto2 e foto3.
              //Para conseguir usar AssetImage vá entre no arquivo pubspec.yaml na "root".
              //depois procure por assets e indique o caminha da sua pasta assets
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageDescription(
                          imageUrl: 'assets/foto1.jpg',
                          imageDescription: 'Foto 1'),
                    ),
                  );
                },
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/foto1.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageDescription(
                        imageUrl:
                            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                        imageDescription: 'Foto 2',
                        isNetworkImage: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageDescription(
                          imageUrl: 'assets/foto2.jpg',
                          imageDescription: 'Foto 3'),
                    ),
                  );
                },
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/foto2.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
