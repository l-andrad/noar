import 'dart:convert';
import 'package:app_pm/class/dados_pessoais.dart';
import 'package:app_pm/class/endereco.dart';
import 'package:app_pm/services/cadastrar_usuario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ignore: prefer_final_fields
  late List<bool> _isOpen = [false, false, false];
  var formKeyDadosLogin = GlobalKey<FormState>();
  var formKeyDadosPessoais = GlobalKey<FormState>();
  var formkeyEndereco = GlobalKey<FormState>();
  var nome = TextEditingController();
  var cpf = TextEditingController();
  var data = TextEditingController();
  var txtcep = TextEditingController();
  late var rua = TextEditingController();
  late var numero = TextEditingController();
  late var complemento = TextEditingController();
  late var bairro = TextEditingController();
  late var cidade = TextEditingController();
  late var estado = TextEditingController();
  var email = TextEditingController();
  late var resultadoCep;
  var _generoValue;

  void dropdownCallback(Object? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _generoValue = selectedValue;
      });
    }
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

  bool validaCpf() {
    var cpfValido = UtilBrasilFields.isCPFValido(cpf.text);
    return cpfValido;
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
    context
        .read<Notificacao>()
        .notificarErro(context, "Algo deu errado, Tente mais tarde!");
  }

  modalAlerta() {
    context.read<Notificacao>().notificarAlerta(context, "CEP inválido!");
  }

  void buscaCepAwesome() async {
    String cep = txtcep.text.replaceAll(RegExp(r'[^\w\s]+'), '');
    var client = http.Client();
    Uri url;

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
    Uri url;

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

  void alterarDadosPessoais() {
    Endereco endereco = Endereco(txtcep.text, rua.text, numero.text,
        complemento.text, bairro.text, cidade.text, estado.text);

    DadosPessoais dados =
        DadosPessoais(nome.text, cpf.text, data.text, _generoValue);

    context
        .read<CadastrarUsuarioService>()
        .alterarDadosPessoais(dados, endereco, email.text, context);
  }

  void getDadosUsuario() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? usuario = auth.currentUser;
    final userRef = FirebaseFirestore.instance
        .collection('dadosPessoais')
        .doc(usuario!.uid);
    final docSnapshot = await userRef.get();
    final userData = docSnapshot.data();

    setState(() {
      nome.text = userData!['nome'];
      cpf.text = userData['cpf'];
      data.text = userData['data'];
      _generoValue = userData['genero'];
      txtcep.text = userData['endereco']['cep'];
      rua.text = userData['endereco']['rua'];
      numero.text = userData['endereco']['numero'];
      complemento.text = userData['endereco']['complemento'];
      bairro.text = userData['endereco']['bairro'];
      cidade.text = userData['endereco']['cidade'];
      estado.text = userData['endereco']['estado'];
      email.text = userData['email'];
    });
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      alterarDadosPessoais();
    } else {
      context.read<Notificacao>().notificarConexao(context);
    }
  }

  @override
  void initState() {
    getDadosUsuario();
    super.initState();
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
              Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Perfil",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5),
                      ),
                    ),
                    ExpansionPanelList(
                        expansionCallback: (i, isOpen) {
                          setState(() {
                            _isOpen[i] = isOpen;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            isExpanded: _isOpen[0],
                            canTapOnHeader: true,
                            headerBuilder: (context, isExpanded) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _isOpen[0]
                                            ? const Color.fromRGBO(
                                                60, 120, 62, 50)
                                            : Colors.black12,
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Dados Pessoais"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            body: Column(
                              children: [
                                Form(
                                    key: formKeyDadosPessoais,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: TextFormField(
                                            controller: nome,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                                  context
                                                      .read<Notificacao>()
                                                      .notificarAlerta(context,
                                                          "CPF Invalido!");
                                                }
                                              }
                                            },
                                            child: TextFormField(
                                              controller: cpf,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                labelText: 'CPF',
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                CpfInputFormatter(),
                                              ],
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                String mensagem;
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
                                              suffixIcon: const Icon(
                                                  Icons.calendar_today),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              labelText: 'Data de Nascimento',
                                            ),
                                            readOnly: true,
                                            onTap: () {
                                              _selectDate();
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
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
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  )),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Informe sua gênero!';
                                                }
                                                return null;
                                              },
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 18.0),
                                          child: TextFormField(
                                            controller: email,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                labelText: 'Email',
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                      Icons.email_outlined),
                                                  onPressed: () {},
                                                )),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Informe sua email!';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          ExpansionPanel(
                            isExpanded: _isOpen[1],
                            canTapOnHeader: true,
                            headerBuilder: (context, isExpanded) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _isOpen[1]
                                            ? const Color.fromRGBO(
                                                60, 120, 62, 50)
                                            : Colors.black12,
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Endereço"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            body: Column(
                              children: [
                                Form(
                                  key: formkeyEndereco,
                                  child: Column(
                                    children: [
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
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                  labelText: 'CEP',
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  CepInputFormatter(),
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 45.0, left: 0.0, right: 0.0, bottom: 0.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 0.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            bool isValido = true;
                            if (!formKeyDadosPessoais.currentState!.validate()) {
                              isValido = false;
                            }
                            if (!formkeyEndereco.currentState!.validate()) {
                              isValido = false;
                            }
                            if(!isValido) {
                              context.read<Notificacao>()
                                .notificarAlerta(
                                  context, 
                                  "Campo obrigatório não preenchido, verifique os campos."
                                );
                            }
                            if (isValido) {
                              checkInternet();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(60, 122, 59, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
