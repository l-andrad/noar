import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BarraNavegacao extends StatefulWidget {
  int index;
  BarraNavegacao({Key? key, required this.index}) : super(key: key);

  @override
  State<BarraNavegacao> createState() => _BarraNavegacaoState();
}

class _BarraNavegacaoState extends State<BarraNavegacao> {
  late var progresso = widget.index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: progresso >= 1 ? const Color.fromRGBO(60, 120, 62, 50) : Colors.black12,
                ),
                child: const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 2,
            width: 50, // Largura da linha divisória vertical
            color: progresso >= 2 ? const Color.fromRGBO(60, 120, 62, 50) : Colors.black12,
          ),
          Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: progresso >= 2 ? const Color.fromRGBO(60, 120, 62, 50) : Colors.black12,
                ),
                child: const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.home_work,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 2,
            width: 50, // Largura da linha divisória vertical
            color: progresso >= 3 ? const Color.fromRGBO(60, 120, 62, 50) : Colors.black12,
          ),
          Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: progresso >= 3 ? const Color.fromRGBO(60, 120, 62, 50) : Colors.black12,
                ),
                child: const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
