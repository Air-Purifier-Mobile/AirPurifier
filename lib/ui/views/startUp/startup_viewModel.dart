import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:stacked/stacked.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  final StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();

  void onModelReady() {
    Future.delayed(
      Duration(seconds: 0),
      () {
        if (_authenticationService.getLogInStatus()) {
          _firestoreService
              .retrieveUserDocument(_authenticationService.getUID())
              .then((temp) {
            if (!temp.exists || temp.data()['MAC'].isEmpty)
              _navigationService.replaceWith(Routes.addDeviceView);
            else {
              List<String> mac =
                  temp.data()['MAC'].map<String>((s) => s as String).toList();
              List<String> name =
                  temp.data()["name"].map<String>((s) => s as String).toList();
              _streamingSharedPreferencesService.changeStringListInStreamingSP(
                "MAC",
                mac,
              );
              _streamingSharedPreferencesService.changeStringListInStreamingSP(
                "name",
                name,
              );
              _navigationService.replaceWith(Routes.homeView);
            }
          });
        } else {
          _navigationService.replaceWith(Routes.loginView);
        }
        Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
          return <String, dynamic>{
            'version.securityPatch': build.version.securityPatch,
            'version.sdkInt': build.version.sdkInt,
            'version.release': build.version.release,
            'version.previewSdkInt': build.version.previewSdkInt,
            'version.incremental': build.version.incremental,
            'version.codename': build.version.codename,
            'version.baseOS': build.version.baseOS,
            'board': build.board,
            'bootloader': build.bootloader,
            'brand': build.brand,
            'device': build.device,
            'display': build.display,
            'fingerprint': build.fingerprint,
            'hardware': build.hardware,
            'host': build.host,
            'id': build.id,
            'manufacturer': build.manufacturer,
            'model': build.model,
            'product': build.product,
            'supported32BitAbis': build.supported32BitAbis,
            'supported64BitAbis': build.supported64BitAbis,
            'supportedAbis': build.supportedAbis,
            'tags': build.tags,
            'type': build.type,
            'isPhysicalDevice': build.isPhysicalDevice,
            'androidId': build.androidId,
            'systemFeatures': build.systemFeatures,
          };
        }

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        deviceInfo.androidInfo.then((value) {
          FirebaseFirestore.instance
              .collection("Device Information")
              .doc("${value.id}")
              .set(_readAndroidBuildData(value));
        });
      },
    );
  }
}
