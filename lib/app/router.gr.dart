// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/bluetooth/bluetooth_view.dart';
import '../ui/views/dummyView/dummy_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/startUp/startup_view.dart';
import '../ui/views/wifi/wifi_view.dart';

class Routes {
  static const String startUpView = '/start-up-view';
  static const String dummyView = '/dummy-view';
  static const String loginView = '/login-view';
  static const String homeView = '/home-view';
  static const String bluetoothView = '/bluetooth-view';
  static const String wifiView = '/wifi-view';
  static const all = <String>{
    startUpView,
    dummyView,
    loginView,
    homeView,
    bluetoothView,
    wifiView,
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
    RouteDef(Routes.wifiView, page: WifiView),
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
        builder: (context) => const BluetoothView(),
        settings: data,
      );
    },
    WifiView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const WifiView(),
        settings: data,
      );
    },
  };
}
