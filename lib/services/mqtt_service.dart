import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService{
  
  MqttServerClient _client;
  Function connectionSuccessful;
  List<MqttReceivedMessage<MqttMessage>> responseList=[];
  
  void setupConnection(Function _connectionSuccessful) async{
    connectionSuccessful = _connectionSuccessful;
     _client =
    MqttServerClient.withPort('mqtt.dioty.co', 'TestBroker', 1883);
     _client.logging(on: true);
     _client.onConnected = onConnected;
     _client.onDisconnected = onDisconnected;
     _client.onUnsubscribed = onUnsubscribed;
     _client.onSubscribed = onSubscribed;
     _client.onSubscribeFail = onSubscribeFail;
     _client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs('sushrutpatwardhan@gmail.com', 'a03131df')
        .keepAliveFor(60)
        .withWillTopic('TestTopic')
        .withWillMessage('Sup Motherfucker')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
         .withClientIdentifier('TestBroker');

     _client.connectionMessage = connMessage;
    try {
      await _client.connect();
    } catch (e) {
      print('Exception: $e----------------------');
      _client.disconnect();
    }

    //  _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final MqttPublishMessage message = c[0].payload;
    //   final payload =
    //   MqttPublishPayload.bytesToStringAsString(message.payload.message);
    //
    //   print('Received message:$payload from topic: ${c[0].topic}>');
    // });
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


    final builder = MqttClientPayloadBuilder();
    builder.addString('from app');
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
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

  void subscribeToTopic(String topic){
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void listener(){
    int i=0;
    _client.updates.listen((event) {

    }).onData((c) {
      while(c.length!=i) {
        final MqttPublishMessage message = c[i++].payload;
        final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print('Received message:$payload from topic: ${c[0].topic}>');
      }
    });
  }
}