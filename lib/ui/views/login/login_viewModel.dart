import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  void login() {
    _authenticationService.signIn();
  }
}
