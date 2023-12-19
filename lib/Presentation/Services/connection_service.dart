import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
