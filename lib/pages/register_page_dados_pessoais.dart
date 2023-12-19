import 'package:app_pm/class/dados_pessoais.dart';
import 'package:app_pm/widgets/auth_check.dart';
import 'package:app_pm/widgets/barra_navegacao.dart';
import 'package:app_pm/pages/register_page_endereco.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterPageDadosPessoais extends StatefulWidget {
  const RegisterPageDadosPessoais({super.key});

  @override
  State<RegisterPageDadosPessoais> createState() =>
      _RegisterPageDadosPessoaisState();
}

class _RegisterPageDadosPessoaisState extends State<RegisterPageDadosPessoais>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final cpf = TextEditingController();
  final data = TextEditingController();

  var _generoValue;

  void dropdownCallback(Object? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _generoValue = selectedValue;
      });
    }
  }

  bool validaCpf() {
    var cpfValido = UtilBrasilFields.isCPFValido(cpf.text);
    return cpfValido;
  }

  Future<void> _selectDate() async {
    DateTime dataModal;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        dataModal = picked;
        data.text = UtilData.obterDataDDMMAAAA(dataModal);
      });
    }
  }

  navegarTelaComParametro() {
    DadosPessoais dados =
        DadosPessoais(nome.text, cpf.text, data.text, _generoValue);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPageEndereco(
          dadosPessoais: dados,
        ),
      ),
    );
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
                              'Dados Pessoais',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.5),
                            ),
                            BarraNavegacao(index: 1),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: nome,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Nome',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe seu nome!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) {
                                    if (!validaCpf()) {
                                      context.read<Notificacao>().notificarAlerta(
                                          context, "CPF Invalido!");
                                    }
                                  }
                                },
                                child: TextFormField(
                                  controller: cpf,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'CPF',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CpfInputFormatter(),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    var mensagem;
                                    if (value!.isEmpty) {
                                      mensagem = 'Informe seu cpf!';
                                      return mensagem;
                                    } else {
                                      if (!validaCpf()) {
                                        mensagem = 'CPF inválido!';
                                        return mensagem;
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: TextFormField(
                                controller: data,
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Data de Nascimento',
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectDate();
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  DataInputFormatter(),
                                ],
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe sua data de nascimento!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(18),
                                child: DropdownButtonFormField(
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Masculino',
                                        child: Text('Masculino')),
                                    DropdownMenuItem(
                                      value: 'Feminino',
                                      child: Text('Feminino'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Outros',
                                      child: Text('Outros'),
                                    ),
                                  ],
                                  value: _generoValue,
                                  onChanged: dropdownCallback,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                      label: const Text('Gênero'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                  borderRadius: BorderRadius.circular(20),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Informe sua gênero!';
                                    }
                                    return null;
                                  },
                                )),
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
                                                  const AuthCheck()));
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
                                        backgroundColor:
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
                                          padding: EdgeInsets.all(10.0),
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
