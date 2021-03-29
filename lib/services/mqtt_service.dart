import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient _client;
  Function connectionSuccessful;
  Function changeDisplayText;
  String ownMessage;
  List<MqttReceivedMessage<MqttMessage>> responseList = [];

  void setupConnection(
      Function _connectionSuccessful, Function _changeDisplayText) async {
    connectionSuccessful = _connectionSuccessful;
    changeDisplayText = _changeDisplayText;
    _client =
        MqttServerClient.withPort('mqtt.dioty.co', '3C:61:05:12:EA:F4', 1883);
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
    // _client.secure = true;
    // _client.securityContext = context;

    final connMessage = MqttConnectMessage()
        .authenticateAs('sushrutpatwardhan@gmail.com', 'a03131df')
        .keepAliveFor(60)
        .withWillTopic('will topic')
        .withWillMessage('will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier('3C:61:05:12:EA:F4');

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
    connectionSuccessful();
    print('Connected');
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
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
      if (true) {
        print('Received message:$payload from topic: ${c[0].topic}>');
        changeDisplayText('Received message:$payload');
      }
    });
  }

  void publishPayload(String message, String _topic) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    ownMessage = message;

    ///Change root topic
    _client.publishMessage("/sushrutpatwardhan@gmail.com/" + _topic,
        MqttQos.atLeastOnce, builder.payload);
  }

  void unSubscribeToTopic(String topic) {
    _client.unsubscribe(topic);
  }
}
