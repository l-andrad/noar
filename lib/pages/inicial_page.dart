// import 'package:app_pm/services/connectivity.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:app_pm/services/auth_service.dart';
import 'package:app_pm/widgets/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 6), () async {
        final preferences = await SharedPreferences.getInstance();
        if(preferences.getString('token') != null) {
          await context.read<AuthService>().logout();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthCheck()));
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthCheck()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(60, 120, 62, 50),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/ic_launcher.png'),
                const Text(
                  'Noar', 
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(70),
              child: LoadingAnimationWidget.prograssiveDots(
                color: Colors.white, 
                size: 50),
            ),
          ),
        ],
      ),
    );
  }
}
