import 'package:app_pm/services/auth_service.dart';
import 'package:app_pm/services/connectivity.dart';
import 'package:app_pm/widgets/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class Notificacao extends ChangeNotifier {
  notificarAlerta(BuildContext context, String texto) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.warning,
      title: "Atenção!",
      text: texto,
    );
  }

  notificarAlertaCadastro(BuildContext context, String texto) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.warning,
      title: "Atenção!",
      text: texto,
      onConfirmBtnTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AuthCheck()));
      },
    );
  }

  notificarErro(BuildContext context, String texto) {
    QuickAlert.show(
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.error,
      title: texto,
    );
  }

  notificarSucesso(BuildContext context, String texto) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.success,
      title: texto,
      confirmBtnText: 'Prosseguir',
      onConfirmBtnTap: () async => {
        await context.read<AuthService>().logout(),
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthCheck())),
      },
    );
  }

  notificarSucessoAlterarDados(BuildContext context, String texto) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.success,
      title: texto,
      confirmBtnText: 'Prosseguir',
    );
  }

  void notificarConexao(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              Icon(
                Icons.wifi_off, // Ícone de aviso, você pode escolher o ícone desejado
                color: Colors.blue.shade100, // Cor do ícone
                size: 50.0, // Tamanho do ícone
              ),
              const Text('Sem conexão!'),
              const Text(
                'Verifique sua conexão com a internet.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.read<Connection>().openConnectivity(context);
                Navigator.of(context).pop();
              },
              child: const Text('Atualizar'),
            ),
          ],
        ),
      );
}
