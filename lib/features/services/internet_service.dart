import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  static Future<bool> Function()? override;

  static Future<bool> check() async {
    if (override != null) return override!();

    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}


Future<bool> hasInternet() async {
  return await InternetService.check();
}
