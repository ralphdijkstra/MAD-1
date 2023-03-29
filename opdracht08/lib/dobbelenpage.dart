import 'dart:math';

import 'package:flutter/material.dart';

class DobbelenPage extends StatefulWidget {
  final String title;

  const DobbelenPage({super.key, required this.title});

  @override
  State<DobbelenPage> createState() => _DobbelenPageState();
}

class _DobbelenPageState extends State<DobbelenPage> {
  final List<String> _bron = <String>[
    "https://www.jugglux.ch/media/image/fb/be/30/augenwurfel-18mm-holz-natur-220750-32535_600x600.jpg",
    "https://as2.ftcdn.net/v2/jpg/02/14/48/13/1000_F_214481332_H9xKoSh5iM94bAPxREQOgdenx0WOapqh.jpg",
    "https://cdn11.bigcommerce.com/s-70184/images/stencil/608x608/products/241/9062/wood-dice-d6-16mm__68084.1572113629.jpg?c=2&imbypass=on",
    "https://toutpourlejeu.com/1304-home_default/de-bois-12-mm-en-charmille-de-1-a-6-pour-jeu-de-societe-.jpg",
    "https://w24cdn.cz/www.jdinato.cz/_/1200x800-0-0-0-0/product/product_1440/8e8642b4d7444aefefc08d1a85f75ac0.jpg",
    "https://toutpourlejeu.com/3848-home_default/de-bois-25-mm.jpg",
  ];

  final List<int> _getallen = <int>[0, 1, 2, 3, 4, 5];

  // Hieronder de namen van de files in de assets.
  // Assets moeten in pubspec.yaml worden opgenomen:
  // - de directory afgesloten door /, in dit geval alle files uit deze directory
  // - de afzonderlijke files, in dit geval elke individuele file
  // Het hele path moet opgenomen zijn

  final List<String> _ogen = <String>[
    'een.jpg',
    'twee.jpg',
    'drie.jpg',
    'vier.jpg',
    'vijf.jpg',
    'zes.jpg',
  ];

  void dobbel() {
    setState(() {
      for (int i = 0; i < 6; i++) {
        _getallen[i] = Random().nextInt(5);
      }
    });
  }

  Widget dobbelsteenRij(int nummer, double width, double height) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/' + _ogen[_getallen[nummer]]),
            height: height,
            width: width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text((_getallen[nummer] + 1).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontSize: 40,
                )),
          ),
          Image.network(
            _bron[_getallen[nummer]],
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/achtergrond.jpg"),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dobbelsteenRij(0, 50, 50),
                    dobbelsteenRij(1, 50, 50),
                    dobbelsteenRij(2, 50, 50),
                    dobbelsteenRij(3, 50, 50),
                    dobbelsteenRij(4, 50, 50),
                    dobbelsteenRij(5, 50, 50),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      )),
                  child: TextButton(
                      onPressed: () => dobbel(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: const Text(
                          'Werp de stenen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
