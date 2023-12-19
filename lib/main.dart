import 'package:app_pm/pages/inicial_page.dart';
import 'package:app_pm/services/auth_service.dart';
import 'package:app_pm/services/cadastrar_usuario_service.dart';
import 'package:app_pm/services/connectivity.dart';
import 'package:app_pm/services/notificacao.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Notificacao()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => Connection()),
        ChangeNotifierProvider(create: (context) => CadastrarUsuarioService()),
  ],
      child:MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Noar',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InicialPage(),
    );
  }
}
