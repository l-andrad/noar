import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background-page.jpeg'),
                fit: BoxFit.cover),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ligue 180\nCentral de Atendimento a Mulher',
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.5),
                          textAlign: TextAlign.center,
                          
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DPCAMI\nDelegacia de Proteção à Criança,\n ao Adolescente, à Mulher e ao Idoso',
                      style: TextStyle(fontSize: 20, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Em caso de emergência\nLIGUE PARA O 190!',
                      style: TextStyle(fontSize: 20, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
