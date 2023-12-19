import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_pm/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;
  UserCredential? userCredential;
  final db = FirebaseFirestore.instance;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  login(String email, String senha, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
      if(usuario != null) {
        storeToken(usuario!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw AuthException('E-mail ou senha não foi encontrado. Cadastre-se.');
      } else if(e.code == 'network-request-failed') {
        // ignore: use_build_context_synchronously
        context.read<Connection>().openConnectivity(context);
        throw AuthException(e.code);
      } else {
        throw AuthException("Algo deu errado, Tente mais tarde!");
      }
    }
  }

  logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    await _auth.signOut();
    _getUser();
    notifyListeners();
  }

  void storeToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
  }
}
