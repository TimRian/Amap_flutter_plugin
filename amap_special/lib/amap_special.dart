
import 'dart:async';

import 'package:flutter/services.dart';

class AmapSpecial {
  static const MethodChannel _channel =
      const MethodChannel('amap_special');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
