import 'package:app_pm/class/dados_pessoais.dart';
import 'package:app_pm/class/endereco.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool cadastroSucesso = false;

class CadastrarUsuarioService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late bool salvo;

  // registrar(String email, String senha, DadosPessoais dados, Endereco enderco) async {
  //   try {
  //     userCredential = await _auth.signInWithEmailAndPassword(email: email, password: senha);
  //     User? user = userCredential!.user;
  //     if (user != null) {
  //       await registrarDadosPessoais(user.uid, dados, enderco);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       return 'weak-password';
  //     } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
  //       userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
  //       User? user = userCredential!.user;
  //       await registrarDadosPessoais(user!.uid, dados, enderco);
  //     }
  //   }
  // }

  registrar(
      String email, String senha, DadosPessoais dados, Endereco enderco) async {
    UserCredential userCredential;
    User? user;
    try {
      QuerySnapshot querySnapshot = await db
          .collection("dadosPessoais")
          .where("email", isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          registrarDadosPessoais(doc.id, dados, enderco, email);
        }
      } else {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: senha);
        user = userCredential.user;
        registrarDadosPessoais(user!.uid, dados, enderco, email);
      }
    } catch (e) {
      print(e);
    }
  }

  registrarDadosPessoais(String idUsuario, DadosPessoais dados,
      Endereco enderco, String email) async {
    final dadosUsuario = <String, dynamic>{
      "nome": dados.nome,
      "cpf": dados.cpf,
      "data": dados.data,
      "genero": dados.genero,
      "email": email,
      "endereco": {
        "cep": enderco.txtcep,
        "rua": enderco.rua,
        "numero": enderco.numero,
        "complemento": enderco.complemento,
        "bairro": enderco.bairro,
        "estado": enderco.estado,
        "cidade": enderco.cidade,
      }
    };

    await db
        .collection("dadosPessoais")
        .doc(idUsuario)
        .set(dadosUsuario)
        .then((value) => cadastroSucesso = true);
  }

  alterarDadosPessoais(DadosPessoais dados, Endereco enderco, String email,
      BuildContext context) async {
    User? usuario = _auth.currentUser;

    final dadosUsuario = <String, dynamic>{
      "nome": dados.nome,
      "cpf": dados.cpf,
      "data": dados.data,
      "genero": dados.genero,
      "email": email,
      "endereco": {
        "cep": enderco.txtcep,
        "rua": enderco.rua,
        "numero": enderco.numero,
        "complemento": enderco.complemento,
        "bairro": enderco.bairro,
        "estado": enderco.estado,
        "cidade": enderco.cidade,
      }
    };
    await db
        .collection("dadosPessoais")
        .doc(usuario!.uid)
        .set(dadosUsuario)
        .then((value) {
      context
          .read<Notificacao>()
          .notificarSucessoAlterarDados(context, "Dados Alterados!");
    }).catchError((onError) {
      context
          .read<Notificacao>()
          .notificarErro(context, "Algo deu errado, tente mais tarde!");
    });
  }
}
