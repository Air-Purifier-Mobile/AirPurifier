import 'package:air_purifier/ui/views/dummyView/dummy_view.dart';
import 'package:air_purifier/ui/views/home/home_view.dart';
import 'package:air_purifier/ui/views/startUp/startup_view.dart';
import 'package:air_purifier/ui/views/login/login_view.dart';
import 'package:air_purifier/ui/views/wifi/wifi_view.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:air_purifier/ui/views/bluetooth/bluetooth_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: StartUpView, initial: false, name: "startUpView"),
    MaterialRoute(page: DummyView, initial: false, name: "dummyView"),
    MaterialRoute(page: LoginView, initial: false, name: "loginView"),
    MaterialRoute(page: HomeView, initial: false, name: "homeView"),
    MaterialRoute(page: BluetoothView, initial: false, name: "bluetoothView"),
    MaterialRoute(page: WifiView, initial: false, name: "wifiView"),
  ],
)
class $Router {}
