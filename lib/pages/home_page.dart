import 'package:app_pm/pages/chose_form_page.dart';
import 'package:app_pm/pages/info_page.dart';
import 'package:app_pm/pages/profile_page.dart';
import 'package:app_pm/services/auth_service.dart';
import 'package:app_pm/widgets/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String titulo = 'Escolha um questionário';
  String usuarioVitima = 'Estou sendo abusada(o)?';
  String usuarioAgressor = 'Estou sendo abusiva(o)?';

  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) => {
            
            setState(
              () {
                currentPageIndex = index;
              },
            ),
            if (currentPageIndex == 3) {
              context.read<AuthService>().logout(),
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthCheck()))
              },
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.person, size: 35,),
              icon: Icon(Icons.person_outline, size: 35,),
              label: 'Perfil',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.check, size: 35,),
              icon: Icon(Icons.check_box_outlined, size: 35,),
              label: 'Formulários',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.info,
                size: 35,
              ),
              icon: Icon(
                Icons.info_outline,
                size: 35,
              ),
              label: 'Informações',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.logout, size: 35,),
              icon: Icon(Icons.logout_outlined, size: 35,),
              label: 'Sair',
            ),
          ],
        ),
        body: <Widget>[
          const ProfilePage(),
          const ChoseFormPage(),
          const InfoPage(),
          Column(),
        ][currentPageIndex],
      ),
    );
  }
}
