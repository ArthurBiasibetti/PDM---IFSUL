import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Carousel extends StatefulWidget {
  Carousel({super.key, required this.children});
  // State que receberá a os items que devem ficar no carrossel;
  final List<Widget> children;
  //O criando o controlador do scroll desse widget para termos maior controle das ações;
  final ScrollController _scrollController = ScrollController();
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentFocusedIndex = 0;

  void _setCurrentIndex(int indexNumber) {
    setState(() {
      _currentFocusedIndex = indexNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Sempre que o scroll mudar chama esse listener
    widget._scrollController.addListener(() {
      //Calcula qual é o bloco do carrossel que está em "foco"
      double scrollPosition = widget._scrollController.position.pixels;
      double itemSize = 296;
      int approximateIndex = (scrollPosition / itemSize).round();
      approximateIndex = approximateIndex.clamp(0, 20 - 1);
      int nextItemIndex = approximateIndex + 1;

      if (nextItemIndex >= 20) {
        nextItemIndex = 20;
      }

      _setCurrentIndex(nextItemIndex - 1);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 400,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            scrollDirection: Axis.horizontal,
            //Define o controller do scroll
            controller: widget._scrollController,
            //Define a quantidade de items que ira buildar. é um inteiro
            itemCount: widget.children.length,
            // Função para o build. cada intem dentro desse ListView terá esse build realizado.
            itemBuilder: (BuildContext context, int index) {
              return Center(
                //estilo para dar uma impressão de foco
                child: Transform.scale(
                  scaleX: _currentFocusedIndex == index ? 1.1 : .90,
                  scaleY: _currentFocusedIndex == index ? 1.1 : .90,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 280,
                    width: 280,
                    child: widget.children[index],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Botão para voltar uma "pagina" no carrossel
              FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: () {
                  widget._scrollController.animateTo(
                      widget._scrollController.offset - 296,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                },
                //Define o icone de flecha para e esquerda
                child: const Icon(Icons.arrow_left),
              ),
              const Spacer(),
              //Botão para avançar uma "pagina" no carrossel
              FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: () {
                  widget._scrollController.animateTo(
                      widget._scrollController.offset + 296,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                },
                //Define o icone de flecha para direita
                child: const Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
