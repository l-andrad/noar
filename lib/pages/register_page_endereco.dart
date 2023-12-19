import 'dart:convert';
import 'package:app_pm/class/dados_pessoais.dart';
import 'package:app_pm/class/endereco.dart';
import 'package:app_pm/pages/login_page.dart';
import 'package:app_pm/widgets/barra_navegacao.dart';
import 'package:app_pm/pages/register_page_email_senha.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class RegisterPageEndereco extends StatefulWidget {
  DadosPessoais dadosPessoais;

  RegisterPageEndereco({super.key, required this.dadosPessoais});

  @override
  State<RegisterPageEndereco> createState() => _RegisterPageEnderecoState();
}

class _RegisterPageEnderecoState extends State<RegisterPageEndereco> {
  final formKey = GlobalKey<FormState>();
  final txtcep = TextEditingController();
  late var rua = TextEditingController();
  late var numero = TextEditingController();
  late var complemento = TextEditingController();
  late var bairro = TextEditingController();
  late var cidade = TextEditingController();
  late var estado = TextEditingController();

  late var resultadoCep;

  navegarTelaComParametro() {
    Endereco endereco = Endereco(txtcep.text, rua.text, numero.text,
        complemento.text, bairro.text, cidade.text, estado.text);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPageRecuperacaoSenha(
                  endereco: endereco,
                  dadosPessoais: widget.dadosPessoais,
                )));
  }

  loading() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
    });
  }

  handLoading() {
    Navigator.of(context).pop(true);
  }

  modalErro() {
    context.read<Notificacao>().notificarErro(context, "Algo deu errado, Tente mais tarde!");
  }

  modalAlerta() {
    context.read<Notificacao>().notificarAlerta(context, "CEP inválido!");
  }

  void buscaCepAwesome() async {
    String cep = txtcep.text.replaceAll(RegExp(r'[^\w\s]+'), '');
    var client = http.Client();
    var url;

    try {
      loading();
      http.Response response;
      url = Uri.http("cep.awesomeapi.com.br", "/json/$cep");
      response = await client.get(url);
      resultadoCep = response.body;

      Map<String, dynamic> jsonMap = json.decode(resultadoCep);

      if (response.statusCode == 200) {
        var rua = jsonMap['address'];
        var bairro = jsonMap["district"];
        var cidade = jsonMap["city"];
        var estado = jsonMap["state"];

        preencherCamposCep(rua, bairro, cidade, estado);
        handLoading();
      } else if (response.statusCode == 400) {
        handLoading();
        modalAlerta();
      } else {
        handLoading();
        buscarViaCep(cep);
      }
    } catch (e) {
      handLoading();
      modalErro();
    } finally {
      client.close();
    }
  }

  void buscarViaCep(String cep) async {
    var client = http.Client();
    var url;

    try {
      loading();
      http.Response response;
      url = Uri.http("viacep.com.br", "/ws/$cep/json/");
      response = await client.get(url);
      resultadoCep = response.body;

      Map<String, dynamic> jsonMap = json.decode(resultadoCep);

      if (jsonMap["erro"] != true) {
        var rua = jsonMap["logradouro"];
        var bairro = jsonMap["bairro"];
        var cidade = jsonMap["localidade"];
        var estado = jsonMap["uf"];

        preencherCamposCep(rua, bairro, cidade, estado);
        handLoading();
      } else {
        handLoading();
        modalAlerta();
      }
    } catch (e) {
      handLoading();
      modalErro();
    } finally {
      client.close();
    }
  }

  void preencherCamposCep(
      String rua, String bairro, String cidade, String estado) {
    this.rua.text = rua;
    this.bairro.text = bairro;
    this.cidade.text = cidade;
    this.estado.text = estado;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/top-left.jpeg'),
                  Flexible(
                    child: Image.asset('assets/images/top-right.jpeg'),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(children: [
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 18, left: 8, right: 8),
                        child: Form(
                          key: formKey,
                          child: Column(children: [
                            const Text(
                              'Endereço',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.5),
                            ),
                            BarraNavegacao(index: 2),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                children: [
                                  Focus(
                                    onFocusChange: (hasFocus) {
                                      if (!hasFocus) {
                                        buscaCepAwesome();
                                      }
                                    },
                                    child: TextFormField(
                                      controller: txtcep,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        labelText: 'CEP',
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CepInputFormatter(),
                                      ],
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Informe seu CEP!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: rua,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Rua',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe seu rua!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: numero,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Número',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe o número da residencia!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: complemento,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Complemento',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe o complemento!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Focus(
                                child: TextFormField(
                                  showCursor: true,
                                  controller: bairro,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Bairro',
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Informe o bairro!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: cidade,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Cidade',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe a cidade!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: estado,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Estado',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe o estado!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(
                                            217, 217, 217, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            const Color.fromRGBO(60, 122, 59, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        navegarTelaComParametro();
                                      }
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Text(
                                            'Continuar',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      )
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
