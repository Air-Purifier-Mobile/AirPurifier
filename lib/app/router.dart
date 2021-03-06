import 'package:air_purifier/ui/views/add%20device/add_device_view.dart';
import 'package:air_purifier/ui/views/bluetoothDiscovery/bluetooth_discovery_view.dart';
import 'package:air_purifier/ui/views/dummyView/dummy_view.dart';
import 'package:air_purifier/ui/views/home/home_view.dart';
import 'package:air_purifier/ui/views/phone%20number/phone_number_view.dart';
import 'package:air_purifier/ui/views/phoneAuth/phone_auth_view.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_view.dart';
import 'package:air_purifier/ui/views/login/login_view.dart';
import 'package:air_purifier/ui/views/startUp/startup_view.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:air_purifier/ui/views/bluetooth/bluetooth_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: StartUpView, initial: false, name: "StartUpView"),
    MaterialRoute(page: DummyView, initial: false, name: "dummyView"),
    MaterialRoute(page: LoginView, initial: false, name: "loginView"),
    MaterialRoute(page: HomeView, initial: false, name: "homeView"),
    MaterialRoute(page: BluetoothView, initial: false, name: "bluetoothView"),
    MaterialRoute(
        page: RemoteControlView, initial: false, name: "remoteControlView"),
    MaterialRoute(page: PhoneAuthView, initial: false, name: "phoneAuthView"),
    MaterialRoute(
        page: PhoneNumberView, initial: false, name: "phoneNumberView"),
    MaterialRoute(page: AddDeviceView, initial: false, name: "addDeviceView"),
    MaterialRoute(
        page: BluetoothDiscoveryView,
        initial: false,
        name: "bluetoothDiscoveryView"),
  ],
)
class $Router {}
