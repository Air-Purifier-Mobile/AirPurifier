// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:air_purifier/ui/views/bluetoothDiscovery/bluetooth_discovery_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/bluetooth/bluetooth_view.dart';
import '../ui/views/dummyView/dummy_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/remote%20control/remote_control_view.dart';
import '../ui/views/startUp/startup_view.dart';
import '../ui/views/phoneAuth/phone_auth_view.dart';
import '../ui/views/phone number/phone_number_view.dart';
import '../ui/views/add device/add_device_view.dart';

class Routes {
  static const String startUpView = '/start-up-view';
  static const String dummyView = '/dummy-view';
  static const String loginView = '/login-view';
  static const String homeView = '/home-view';
  static const String bluetoothView = '/bluetooth-view';
  static const String remoteControlView = '/remote-control-view';
  static const String phoneAuthView = '/phone-auth-view';
  static const String phoneNumberView = '/phone-number-view';
  static const String addDeviceView = '/add-device-view';
  static const String bluetoothDiscoveryView = "/bluetooth-discovery-view";
  static const all = <String>{
    startUpView,
    dummyView,
    loginView,
    homeView,
    bluetoothView,
    remoteControlView,
    phoneAuthView,
    phoneNumberView,
    addDeviceView,
    bluetoothDiscoveryView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.dummyView, page: DummyView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.bluetoothView, page: BluetoothView),
    RouteDef(Routes.remoteControlView, page: RemoteControlView),
    RouteDef(Routes.phoneAuthView, page: PhoneAuthView),
    RouteDef(Routes.phoneNumberView, page: PhoneNumberView),
    RouteDef(Routes.addDeviceView, page: AddDeviceView),
    RouteDef(Routes.bluetoothDiscoveryView, page: BluetoothDiscoveryView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    DummyView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DummyView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    BluetoothView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => BluetoothView(
          device: data.arguments,
        ),
        settings: data,
      );
    },
    BluetoothDiscoveryView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const BluetoothDiscoveryView(),
        settings: data,
      );
    },
    RemoteControlView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RemoteControlView(
          refreshCallBack: data.arguments,
        ),
        settings: data,
      );
    },
    PhoneAuthView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PhoneAuthView(
          phoneNo: data.arguments,
        ),
        settings: data,
      );
    },
    PhoneNumberView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PhoneNumberView(),
        settings: data,
      );
    },
    AddDeviceView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AddDeviceView(),
        settings: data,
      );
    },
  };
}
