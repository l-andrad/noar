import 'package:app_pm/pages/register_page_dados_pessoais.dart';
import 'package:app_pm/services/auth_service.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo = 'Bem vindo';
  late String actionButton = 'Login';
  late String toggleButton = 'Cadastre-se';
  bool loading = false;

  bool _passVisibility = true;

  setFormAction(bool acao) {
    setState(() {});
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text, context);
    } on AuthException catch (e) {
      setState(() => loading = false);
      if(e.message != 'network-request-failed') {
        context.read<Notificacao>().notificarAlerta(context, e.message);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 8.0, right: 8.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    titulo,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -1.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: TextFormField(
                                      controller: email,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        labelText: 'Email',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Informe o email corretamente!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24.0),
                                    child: TextFormField(
                                      controller: senha,
                                      obscureText: _passVisibility,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                        horizontal: 18.0, vertical: 18.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              60, 122, 59, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState!.validate()) {
                                          login();
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: (loading)
                                            ? [
                                                const Padding(
                                                  padding: EdgeInsets.all(16),
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
                                                const Icon(Icons.check),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16.0),
                                                  child: Text(
                                                    actionButton,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                )
                                              ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 0.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus(); 
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterPageDadosPessoais()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              217, 217, 217, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              toggleButton,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      Color.fromRGBO(0, 0, 0, 1)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
