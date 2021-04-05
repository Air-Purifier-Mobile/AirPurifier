import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:air_purifier/app/router.gr.dart' as customRouter;
import 'package:stacked_services/stacked_services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  StreamingSharedPreferencesService streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  await streamingSharedPreferencesService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DirectBill',
      debugShowCheckedModeBanner: false,
      initialRoute: customRouter.Routes.StartUpView,
      theme: ThemeData(fontFamily: 'Noah'),
      // ignore: deprecated_member_use
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: customRouter.Router().onGenerateRoute,
    );
  }
}
