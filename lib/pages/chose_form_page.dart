// ignore_for_file: use_build_context_synchronously

import 'package:app_pm/pages/question_page.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

// ignore: must_be_immutable
class ChoseFormPage extends StatefulWidget {
  const ChoseFormPage({Key? key}) : super(key: key);

  @override
  State<ChoseFormPage> createState() => _ChoseFormPageState();
}

class _ChoseFormPageState extends State<ChoseFormPage> {
  String titulo = 'Escolha um questionário';
  String usuarioVitima = 'Estou sendo abusada(o)?';
  String usuarioAgressor = 'Estou sendo abusiva(o)?';
  final Uri urlGabriel = Uri.parse('https://www.linkedin.com/in/gabriel-goncalves-1611b4174/');
  final Uri urlLucas = Uri.parse('https://www.linkedin.com/in/lucasb-andrade/');
  final Uri urlJoana = Uri.parse('https://www.linkedin.com/in/joanafranz/');

  checkInternet(String questionario) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      if (questionario == "vitima") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contexto) => QuestionPage(
                      choseForms: 'vitima',
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contexto) => QuestionPage(
                      choseForms: 'agressor',
                    )));
      }
    } else {
      context.read<Notificacao>().notificarConexao(context);
    }
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 24.0),
                        child: Text(
                          titulo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 18.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(60, 122, 59, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            checkInternet("vitima");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  usuarioVitima,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 18.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(60, 122, 59, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            checkInternet("agressor");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  usuarioAgressor,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.white,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Link(
                                        uri: urlGabriel,
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx,
                                            FollowLink? openLink) {
                                          return TextButton(
                                            onPressed: openLink,
                                            child: const Text('Gabriel Gonçalves'),
                                          );
                                        },
                                      ),
                                       Link(
                                        uri: urlLucas,
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx,
                                            FollowLink? openLink) {
                                          return TextButton(
                                            onPressed: openLink,
                                            child:
                                                const Text('Lucas Bittencourt Andrade'),
                                          );
                                        },
                                      ),
                                      Link(
                                        uri: urlJoana,
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx,
                                            FollowLink? openLink) {
                                          return TextButton(
                                            onPressed: openLink,
                                            child:
                                                const Text('Joana Yuriko Franz'),
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                                );
                              });
                        },
                        child: const Text('Desenvolvido por'))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
