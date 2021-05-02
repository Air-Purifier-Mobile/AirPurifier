import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/rgbColor_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class RemoteControlViewModel extends BaseViewModel {
  bool isConnected = false;

  /// Reactive variables provider class
  RGBService _rgbService = locator<RGBService>();
  MqttService _mqttService = locator<MqttService>();

  ///Setting up led
  /// If [ledState] is true it means LED is in Manual Mode
  /// else it is in Auto Mode and User will be disabled from changing led color
  bool ledState = true;

  /// [red], [green], [blue] are the  RGB values for LED color.
  /// They are set up in RGBService class which provides Reactive variables.
  /// It helps in the real-time responsive behaviour of LED color.
  int get red => _rgbService.red;
  int get green => _rgbService.green;
  int get blue => _rgbService.blue;

  /// Fan Controls
  /// [fanState] is set true if Fan is On and false if off
  /// [fanSpeed] ranges from 1 to 4 and holds fan speed value
  bool fanState;
  int fanSpeed;

  /// Purifier Controls
  /// [purifierState] is set true if Purifier is On and false if off
  /// [purifierSpeed] ranges from 1 to 4 and holds purifier strength value
  bool purifierState;
  int purifierSpeed;

  /// Purifier Mode
  /// [purifierMode] holds mode of operation of purifier
  /// 0 = Auto Mode
  /// 1 = Manual Mode
  /// 2 = Sleep Mode
  int purifierMode;

  String mac;
  String rootTopic = "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/";
  final StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  bool isDeviceOn = false;

  /// Following functions change the state of Device and remote
  /// usually they update UI as well as send a command to broker requesting update in device
  /// There is no verification method about device state change
  /// Control fan speeds
  void changeFanSpeed(int speed) {
    fanSpeed = speed;
    publishMessage(("AC" + speed.toString()).trim());
    notifyListeners();
  }

  /// Control purifier speeds
  void changePurifierSpeed(int speed) {
    purifierSpeed = speed;
    publishMessage(speed.toString());
    notifyListeners();
  }

  /// Toggle fan
  void toggleFan() {
    fanState = !fanState;
    publishMessage(fanState ? "ACON" : "ACOFF");
    notifyListeners();
  }

  /// Toggle Purifier
  void togglePurifier() {
    purifierState = !purifierState;
    publishMessage(purifierState ? "APON" : "APOFF");
    notifyListeners();
  }

  /// Toggle LED's
  void toggleLedMode() {
    ledState = !ledState;
    // publishMessage(ledState ? "APLM" : "APLA");
    notifyListeners();
  }

  /// Change Red value of LED color
  void changeRed(double val, bool changeEnd) {
    _rgbService.changeColor("r", val.toInt());
    notifyListeners();
    if (changeEnd) {
      publishMessage("rgb($red,$green,$blue)");
    }
  }

  /// Change Blue value of LED color
  void changeBlue(double val, bool changeEnd) {
    _rgbService.changeColor("b", val.toInt());
    notifyListeners();
    if (changeEnd) {
      publishMessage("rgb($red,$green,$blue)");
    }
  }

  /// Change Green value of LED color
  void changeGreen(double val, bool changeEnd) {
    _rgbService.changeColor("g", val.toInt());
    notifyListeners();
    if (changeEnd) {
      publishMessage("rgb($red,$green,$blue)");
    }
  }

  /// Set Purifier Mode
  void setPurifierMode(int val) {
    purifierMode = val;
    notifyListeners();
  }

  /// Disconnects user from Broker
  void unsubscribeToTopic() {
    Fluttertoast.showToast(msg: 'Disconnect');
    _mqttService.disconnectBroker();
  }

  /// Called once on init
  void onModelReady() {
    // Used when MQTT is disconnected
    // setInitialValues({});
    setBusy(true);
    _mqttService.setupConnection(
      connectionSuccessful,
      changeDisplayText,
      setInitialValues,
      refreshDeviceState,
    );
  }

  /// Fetches device state from broker
  /// Updates UI
  void refreshDeviceState() {
    _mqttService.publishPayload("GET", rootTopic + mac + "DEVICE");
    notifyListeners();
  }

  /// Callback on successful connection with the Broker
  /// Subscribes to some topics
  void connectionSuccessful() {
    isConnected = true;
    mac =
        _streamingSharedPreferencesService.readStringListFromStreamingSP("MAC")[
                _streamingSharedPreferencesService
                    .readIntFromStreamingSP("lastDevice")] +
            "/";
    _mqttService.subscribeToTopic(rootTopic + mac + "SPEED");
    _mqttService.subscribeToTopic(rootTopic + mac + "BUTTON");
    _mqttService.subscribeToTopic(rootTopic + mac + "RESPONSE");
    //_mqttService.subscribeToTopic(rootTopic + mac + "IN");
    _mqttService.publishPayload("GET", rootTopic + mac + "DEVICE");
    notifyListeners();
  }

  /// Publishes message on "IN" topic requesting a device component's state change
  void publishMessage(String message) {
    String topic = rootTopic + mac + "IN";
    // _mqttService.publishPayload(
    //     '{"AP motor":"OFF","AP mode":"MANUAL","LED mode":"AUTO","AP speed":1,"R color":0,"G color":0,"B color":0}',
    //     rootTopic + mac + "RESPONSE");
    _mqttService.publishPayload(message, topic);
  }

  /// MQTT service callback
  /// Provides status of responses and requests from broker
  /// Not used in Remote UI
  /// Just a placeholder used for debugging purposes
  void changeDisplayText(String display) {
    print("Display Text: " + display);
  }

  /// Sets values for all variables
  /// This is called whenever broker sends response to GET request
  /// or when broker sends device state
  void setInitialValues(Map map) {
    print(map.toString() + '-------------------------');
    setBusy(false);
    if (map.isEmpty) {
      /// This sets default values in the variables,
      /// provided there is an error in the response from broker
      /// Set Purifier state
      purifierSpeed = 1;
      purifierState = false;

      /// Set Fan State
      fanSpeed = 1;
      fanState = true;

      /// Set Purifier Mode
      purifierMode = 0;

      /// Set Led state
      ledState = true;
      _rgbService.changeColor("r", 26);
      _rgbService.changeColor('g', 17);
      _rgbService.changeColor('b', 155);
    } else {
      /// Set Purifier state
      purifierSpeed = map["AP speed"];
      purifierState = map["AP motor"] == "ON";

      /// Set Fan State
      fanSpeed = map["AC speed"];
      fanState = map["AC motor"] == "ON";

      /// Set Led state
      ledState = map["LED mode"] != "AUTO";
      _rgbService.changeColor("r", map["R color"]);
      _rgbService.changeColor('g', map["G color"]);
      _rgbService.changeColor('b', map["B color"]);

      /// Set Purifier Mode
      if (map["AP mode"] == "AUTO") {
        purifierMode = 0;
        purifierState = false;
      } else if (map["AP mode"] == "MANUAL") {
        purifierMode = 1;
        purifierState = true;
      } else {
        purifierMode = 2;
        purifierState = false;
      }
    }
    notifyListeners();
  }
}
