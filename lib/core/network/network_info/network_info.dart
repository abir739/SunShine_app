import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
abstract class NetworkInfo {
  Future<bool> get isConnectes;
}
class NetworkinfoImplemt implements NetworkInfo{
  final InternetConnectionChecker internetConnectionChecker;

  NetworkinfoImplemt( this.internetConnectionChecker); 
  @override
  // TODO: implement isConnectes
  Future<bool> get isConnectes => internetConnectionChecker.hasConnection;
}
// class NetworkinfoImplemt2 implements NetworkInfo{
//   final   Connectivity _connectivity ;

//   NetworkinfoImplemt2({required this._connectivity}); 
//   @override
//   // TODO: implement isConnectes
//   Future<ConnectivityResult> get isConnectes => _connectivity.checkConnectivity();
// }