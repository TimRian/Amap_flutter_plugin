import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AMapNavi {
  static final _channel = MethodChannel('foton/navi');

  static const drive = 0;
  static const walk = 1;
  static const ride = 2;

  static AMapNavi _instance;

  AMapNavi._();

  factory AMapNavi() {
    if (_instance == null) {
      _instance = AMapNavi._();
      return _instance;
    } else {
      return _instance;
    }
  }

  void startNavi({
    @required double lat,
    @required double lon,
    int naviType = drive,
  }) {
    _channel.invokeMethod(
      'navi#startNavi',
      {'lat': lat, 'lon': lon, 'naviType': naviType},
    );
  }
}
