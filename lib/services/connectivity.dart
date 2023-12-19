import 'dart:developer' as developer;
import 'package:app_pm/services/notificacao.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Connection extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();

  openConnectivity(BuildContext context) async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();

      if(result == ConnectivityResult.none) {
        context.read<Notificacao>().notificarConexao(context);
      }
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
  }
}

//OBS: Esse método esta funcionando, ele ouve a alteração da conexão da internet no aparelho,
// mas esta com problema quando é utilizado na construção do widget.
//TODO: Revisar método.
// class ConnectivityService with ChangeNotifier {
//   ConnectivityResult _connectivityResult = ConnectivityResult.none;

//   ConnectivityService() {
//     Connectivity().onConnectivityChanged.listen((result) {
//       _connectivityResult = result;
//       if(_connectivityResult == ConnectivityResult.none) {
//       }
//       notifyListeners(); // Notificar ouvintes quando houver uma alteração.
//     });
//   }

//   ConnectivityResult get connectivityResult => _connectivityResult;
// }