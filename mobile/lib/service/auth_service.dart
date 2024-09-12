import 'package:pi_mobile/service/auth_data.dart';

/// This class currently serves as a mock and so it is to be redone in the future.
class AuthService {
  AuthData? data;

  bool isAuthenticated() {
    return data != null;
  }

  AuthData? getData() {
    return data;
  }
}
