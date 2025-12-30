import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  /// Returns true if device has internet connection
  static Future<bool> hasInternet() async {
    final List<ConnectivityResult> results =
    await Connectivity().checkConnectivity();

    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }
}
