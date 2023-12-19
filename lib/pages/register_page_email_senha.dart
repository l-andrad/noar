// ignore_for_file: use_build_context_synchronously

import 'package:app_pm/class/dados_pessoais.dart';
import 'package:app_pm/class/endereco.dart';
import 'package:app_pm/pages/login_page.dart';
import 'package:app_pm/services/cadastrar_usuario_service.dart';
import 'package:app_pm/widgets/barra_navegacao.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pm/services/notificacao.dart';

// ignore: must_be_immutable
class RegisterPageRecuperacaoSenha extends StatefulWidget {
  Endereco endereco;
  DadosPessoais dadosPessoais;
  

  RegisterPageRecuperacaoSenha(
      {super.key, required this.endereco, required this.dadosPessoais});

  @override
  State<RegisterPageRecuperacaoSenha> createState() =>
      _RegisterPageRecuperacaoSenhaState();
}

class _RegisterPageRecuperacaoSenhaState
    extends State<RegisterPageRecuperacaoSenha> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  bool _passVisibility = true;
  bool _passVisibilityComfir = true;
  bool loading = false;

  cadastrarUsuario(Endereco enderco, DadosPessoais dados) async {
    setState(() {
      loading = true;
    });
    try {
      await context
          .read<CadastrarUsuarioService>()
          .registrar(email.text, senha.text, dados, enderco);
      context
          .read<Notificacao>()
          .notificarSucesso(context, 'Cadastrado com sucesso!');
      setState(() {
        loading = false;
      });
    } catch (e) {
      context.read<Notificacao>().notificarAlertaCadastro(
          context, 'Algo deu errado com seu cadastro!');
    }
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.none) {
      cadastrarUsuario(widget.endereco, widget.dadosPessoais);
    } else {
      context.read<Notificacao>().notificarConexao(context);
    }
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
                              'Dados Login',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.5),
                            ),
                            BarraNavegacao(index: 3),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 18.0),
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Email',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.email_outlined),
                                      onPressed: () {},
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe sua email!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 18.0),
                              child: TextFormField(
                                controller: senha,
                                obscureText: _passVisibility,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Senha',
                                    suffixIcon: IconButton(
                                      icon: _passVisibility
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                      onPressed: () {
                                        _passVisibility = !_passVisibility;
    
                                        setState(() {});
                                      },
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe sua senha!';
                                  } else if (value.length < 6) {
                                    return 'Sua senha deve ter no mínimo 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 18.0),
                              child: TextFormField(
                                controller: confirmarSenha,
                                obscureText: _passVisibilityComfir,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Confirmar Senha',
                                    suffixIcon: IconButton(
                                      icon: _passVisibilityComfir
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                      onPressed: () {
                                        _passVisibilityComfir =
                                            !_passVisibilityComfir;
    
                                        setState(() {});
                                      },
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe sua senha!';
                                  } else if (value.length < 6) {
                                    return 'Sua senha deve ter no mínimo 6 caracteres';
                                  } else if (confirmarSenha.text != senha.text) {
                                    return 'Sua confirmação de senha esta diferente da senha!';
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
                                        backgroundColor: const Color.fromRGBO(
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 18.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(60, 122, 59, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          checkInternet();
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: (loading) ? [
                                          const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                          horizontal: 40.0,
                                                          vertical: 9.0),
                                                  child: SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                        ] 
                                        : [
                                          const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              'Cadastrar',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          )
                                        ],
                                      ),
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
