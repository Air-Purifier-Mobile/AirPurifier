import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthenticationService {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final StreamingSharedPreferencesService _sharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool getLogInStatus() {
    return _auth.currentUser != null;
  }

  String getUID() {
    return _auth.currentUser?.uid;
  }

  Future<Position> getLocation() async {
    return await Geolocator.requestPermission().then((permissions) async {
      if (permissions == LocationPermission.whileInUse ||
          permissions == LocationPermission.always) {
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      } else {
        return null;
      }
    });
  }

  void signOut() {
    _auth.signOut();
    _googleSignIn.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  void signIn() async {
    print("---------Logging User In---------");
    await _googleSignIn.signIn().then((googleUser) async {
      print("---------Got Google account---------");
      await googleUser.authentication.then((googleCredentials) {
        AuthCredential credentials = GoogleAuthProvider.credential(
          accessToken: googleCredentials.accessToken,
          idToken: googleCredentials.idToken,
        );
        _auth.signInWithCredential(credentials).then((userCredentials) {
          print("---------Signed in ---------");
          _firestoreService
              .retrieveUserDocument(userCredentials.user.uid)
              .then((snap) {
            if (snap.exists) {
              Map map = snap.data();
              List<String> mac =
                  map["MAC"].map<String>((s) => s as String).toList();
              List<String> name =
                  map["name"].map<String>((s) => s as String).toList();
              _sharedPreferencesService.changeStringListInStreamingSP(
                "MAC",
                mac,
              );
              _sharedPreferencesService.changeStringListInStreamingSP(
                "name",
                name,
              );
              _navigationService.replaceWith(Routes.homeView);
            } else {
              _navigationService.replaceWith(Routes.addDeviceView);
            }
          });

          print("--------- Going to Home View ---------");
        });
      });
    }).onError((error, stackTrace) {
      print(error.toString());
      Fluttertoast.showToast(msg: error.toString());
    });
  }
}
