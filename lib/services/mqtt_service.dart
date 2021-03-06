import 'dart:convert';
import 'dart:math';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:stacked_services/stacked_services.dart';

class MqttService {
  MqttServerClient _client;
  Function connectionSuccessful;
  Function changeDisplayText;
  Function setInitialValues;
  Function setGraphValues;
  Function refreshCallBack;
  String ownMessage;
  String mac;
  String rootTopic = "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/";
  List<MqttReceivedMessage<MqttMessage>> responseList = [];
  final StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  final NavigationService _navigationService = locator<NavigationService>();
  void setupConnection(Function _connectionSuccessful,
      Function _changeDisplayText, Function setInit, Function refresh,
      {Function graphInit}) async {
    String clientID = getRandomString(20).toString();
    connectionSuccessful = _connectionSuccessful;
    changeDisplayText = _changeDisplayText;
    setInitialValues = setInit;
    refreshCallBack = refresh;
    setGraphValues = graphInit;
    _client = MqttServerClient.withPort('mqtt.flespi.io', clientID, 8883);
    _client.logging(on: true);
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onUnsubscribed = onUnsubscribed;
    _client.onSubscribed = onSubscribed;
    _client.onSubscribeFail = onSubscribeFail;
    _client.pongCallback = pong;
    // SecurityContext context = new SecurityContext()
    //   ..setClientAuthorities('package:air_purifier/constants/dioty_ca.crt',
    //       password: '7b35b817');
    _client.secure = true;
    // _client.securityContext = context;-

    final connMessage = MqttConnectMessage()
        .authenticateAs(
          'EeCRXC1jLNcmgXvydXxltgvCfVhAzRw3TZJGrAP0bQciBvGEi2Oz6919U6zkLVbu',
          null,
        )
        .keepAliveFor(60)
        .withWillTopic('will topic')
        .withWillMessage('will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier(clientID);
    _client.connectionMessage = connMessage;
    try {
      await _client.connect();
    } catch (e) {
      print('Exception: $e----------------------');
      _client.disconnect();
    }
  }

  // connection succeeded
  void onConnected() {
    listener();
    int lastDevice =
        _streamingSharedPreferencesService.readIntFromStreamingSP("lastDevice");
    mac = _streamingSharedPreferencesService
        .readStringListFromStreamingSP("MAC")[lastDevice];
    connectionSuccessful();
    print('Connected');
  }

  // unconnected
  void onDisconnected() {
    _navigationService.back();
    print('Disconnected');
  }

  void disconnectBroker() {
    _client.disconnect();
  }

  // subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');

    ///comment in prod
    // if (topic ==
    //     "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/RESPONSE")
    // publishPayload(
    //     '{"AP motor":"OFF","AC motor":"OFF","AP mode":"MANUAL","LED mode":"AUTO","AP speed":1,"AC speed":1,"R color":0,"G color":0,"B color":0}',
    //     rootTopic + mac + "/RESPONSE");
  }

  // subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  // unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

  // PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  void subscribeToTopic(String topic) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void listener() {
    _client.updates.listen((event) {}).onData((c) {
      final MqttPublishMessage message = c[0].payload;
      String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print(
        'Received message:$payload own Message:$ownMessage fromTopic:${c[0].topic}',
      );

      ///comment in prod
      // if (c[0].topic ==
      //     "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/RESPONSE") {
      //   setInitialValues(jsonDecode(payload));
      // }
      // if (c[0].topic == "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/PM 1.0" ||
      //     c[0].topic ==
      //         "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/PM 2.5" ||
      //     c[0].topic ==
      //         "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/PM 10") {
      //   setInitialValues(payload, c[0].topic);
      // }

      if (payload != ownMessage) {
        // if (c[0].topic ==
        //     "/sushrutpatwardhan@gmail.com/AP EMBEDDED/Airpurifier/$mac/IN") {
        //   refreshCallBack();
        // }

        if (c[0].topic ==
            "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/GRAPH") {
          setGraphValues(jsonDecode(payload));
        }
        if (c[0].topic ==
            "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/RESPONSE") {
          setInitialValues(jsonDecode(payload));
        }
        if (c[0].topic ==
                "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/BUTTON" &&
            payload != ownMessage) {
          refreshCallBack();
        }
        if (c[0].topic ==
                "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/SPEED" &&
            payload != ownMessage) {
          refreshCallBack();
        }
        if (c[0].topic == "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/PM 1.0" ||
            c[0].topic ==
                "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/PM 2.5" ||
            c[0].topic ==
                "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/$mac/PM 10") {
          setInitialValues(payload, c[0].topic);
        }
      }
    });
  }

  void publishPayload(String message, String _topic) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    ownMessage = message;

    ///Change root topic
    _client.publishMessage(_topic, MqttQos.atLeastOnce, builder.payload);
  }

  void unSubscribeToTopic(String topic) {
    _client.unsubscribe(topic);
  }

  ///RANDOM generation id
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
