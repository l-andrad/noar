import 'package:app_pm/pages/answer_page.dart';
import 'package:app_pm/services/auth_service.dart';
import 'package:app_pm/widgets/auth_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuestionPage extends StatefulWidget {
  String choseForms;

  QuestionPage({super.key, required this.choseForms});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String pergunta = "";

  String pageCount = '';

  late Map<String, dynamic> respostas = {};

  List<String> respostasLista = [];

  int count = 1;

  int pontuacao = 0;

  double percentual = 0;

  String instrucao = '';

  final db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  late Map<String, dynamic> perguntas;

  getQuestions() async {
    await db
        .collection(widget.choseForms)
        .get()
        .then((value) => {
              for (var doc in value.docs)
                {
                  perguntas = doc.data(),
                },
            })
        // ignore: invalid_return_type_for_catch_error, avoid_print
        .catchError((onError) => print(onError));
  }

  questionControl(int questionNumber, int questionsQuantity) {
    pageCount = '$questionNumber/$questionsQuantity';
  }

  setQuestion(String question) {
    pergunta = question;
  }

  runForms() async {
    await getQuestions();
    setState(() {
      questionControl(count, perguntas.length);
      setQuestion(perguntas['$count']);
    });
  }

  void respondeForms(String resposta) {
    respostasLista.add(resposta);
    setQuestion(perguntas['$count']);
    questionControl(count, perguntas.length);
    
    if (count == perguntas.length) {
      calculaPontuacao();
      if (widget.choseForms == 'vitima') {
        preencheRespostas(respostasLista);
        determinaRespostaVitima();
      } else if (widget.choseForms == 'agressor') {
        determinaRespostaAgressor();
      }
    }
    count++;
  }

  void preencheRespostas(List<String> respostasEnviadas) {
    int idResposta = DateTime.now().microsecondsSinceEpoch;

    respostas['$idResposta'] = respostasEnviadas;
  } 

  void calculaPontuacao() {
    int totalPontuacao;

    for (var i = 0; i < respostasLista.length; i++) {
      if (respostasLista[i] == 'Sim') {
        pontuacao += 10;
      } else if (respostasLista[i] == 'Às Vezes') {
        pontuacao += 5;
      }
    }

    totalPontuacao = respostasLista.length * 10;
    percentual = (pontuacao * 100) / totalPontuacao;
  }

  void determinaRespostaVitima() {
    if (percentual >= 0.0 && percentual <= 15.0) {
      instrucao = 'Ao fazer o teste e demonstrar preocupação com seu relacionamento, você demonstra maturidade para debater o tema. \n\nSeu relacionamento parece ser saudável, maduro e respeitoso, que é como deve ser para todos.';

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage(
                  titulo: 'ESTÁ TUDO BEM', textoInstrutivo: instrucao)));
    } else if (percentual >= 15.5 && percentual <= 50.0) {
      instrucao = 'Os perpetradores de abusos começam gradativamente com o seu comportamento prejudicial, aproveitando-se de suas tendências manipuladoras e esperando a oportunidade certa para agir. \n\nAs vítimas de abuso podem erroneamente perceber essas ações como típicas ou aceitáveis em uma relação devido a seu apego emocional.';


      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage(
                  titulo: 'FIQUE ATENTA', textoInstrutivo: instrucao)));
    } else if (percentual >= 50.5 && percentual <= 100) {
      instrucao = 'A vítima frequentemente não reconhece o abuso devido ao seu forte apego emocional, e o abusador pode não ver o problema já que se acostumou a este padrão de relacionamento, que muitas vezes, é o único que conhece. \n\n As indicações de um relacionamento abusivo incluem auto-isolamento, retirada dos entes queridos e perda da identidade pessoal.';


      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage(
                  titulo: 'ALERTA, RELAÇÃO ABUSIVA', textoInstrutivo: instrucao)));
    }
  }

  void determinaRespostaAgressor() {
    if (percentual >= 0 && percentual <= 15) {
      instrucao = 'Muito bem, parece que você tem um relacionamento saudável, onde se tratam com respeito e evitam comportamentos possessivos. \n\n É provável que seu relacionamento seja em sua maioria pacífico, e você deve esperar o mesmo nível de comportamento dos outros também.';

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage(
                  titulo: 'VOCÊ NÃO É ABUSIVO',
                  textoInstrutivo: instrucao)));
    } else if (percentual >= 15.5 && percentual <= 50.0) {
      instrucao = 'Se você não tiver cuidado, pode acabar sendo um parceiro tóxico. É importante lembrar que um relacionamento não é uma prisão e requer sacrifícios. \n\n Você precisa entender que tudo o que você experimenta em um relacionamento é um dar e receber, e você nem sempre pode conseguir o que quer.';

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage(
                  titulo: 'ATENÇÃO AOS EXAGEROS', textoInstrutivo: instrucao)));
    } else if (percentual >= 50.5 && percentual <= 100.0) {
      instrucao = 'É um equívoco acreditar que a sua companheira é sua posse, desconsiderando o fato de que ambos os indivíduos têm personalidades distintas. \n\n As táticas de manipulação podem ser frequentemente utilizadas para satisfazer seus desejos, muitas vezes sem sequer se darem conta disso.';

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerPage(
                  titulo: 'ALERTA ABUSIVO!', textoInstrutivo: instrucao)));
    }
  }

  @override
  Widget build(BuildContext context) {
    runForms();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background-page.jpeg'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(217, 217, 217, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      pageCount,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 45.0, left: 24.0, right: 24.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromRGBO(
                                          217, 217, 217, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            pergunta,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 45.0, left: 40.0, right: 40.0, bottom: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(60, 122, 59, 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    respondeForms('Sim');
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Sim',
                                          style: TextStyle(fontSize: 19),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(60, 122, 59, 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    respondeForms('Às vezes');
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Às vezes',
                                          style: TextStyle(fontSize: 19),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(60, 122, 59, 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    respondeForms('Não');
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Não',
                                          style: TextStyle(fontSize: 19),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 40.0, right: 40.0, bottom: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthService>().logout();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthCheck()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: Text(
                            'SAIR',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
