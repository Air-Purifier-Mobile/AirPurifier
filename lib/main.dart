import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:air_purifier/app/router.gr.dart' as customRouter;
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  setupLocator();
  print("locator initialised");
  StreamingSharedPreferencesService streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  await streamingSharedPreferencesService.init();
  print("Streaming Shared pref initialised");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aeolus',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: customRouter.Routes.startUpView,
      themeMode: ThemeMode.light,
      // ignore: deprecated_member_use
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: customRouter.Router().onGenerateRoute,
    );
  }
}
