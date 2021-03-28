import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  Position position;
  void logout() {
    _authenticationService.signOut();
  }

  void getPermissions() async {
    Future.delayed(
      Duration(seconds: 0),
      () async {
        Position _position;
        _position = await _authenticationService.getLocation();
        if(_position!=null){
          position = _position;
          //setup http request

        }
        notifyListeners();
      },
    );
  }
}
