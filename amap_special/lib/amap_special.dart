
import 'dart:async';
import 'dart:convert';

import 'package:amap_special/src/location/amp_locaion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'amap_special.dart';
export 'src/navi/amap_navi.dart';
export 'src/location/amp_locaion.dart';
export 'src/location/model/location.dart';
export 'src/location/model/location_client_options.dart';
export 'src/common/permissions.dart';
export 'src/common/misc.dart';
export 'src/map/model/latlng.dart';
export 'src/map/amap_controller.dart';
export 'src/map/amap_view.dart';
export 'src/map/model/my_location_style.dart';
export 'src/map/model/amap_options.dart';
export 'src/map/model/camera_position.dart';
export 'src/map/model/marker_options.dart';
export 'src/map/model/polyline_options.dart';
export 'src/map/model/circle_options.dart';
export 'src/search/amap_search.dart';
export 'src/search/model/drive_route_result.dart';
export 'src/search/model/geocode_result.dart';
export 'src/search/model/poi_search_query.dart';
export 'src/search/model/regeocode_result.dart';
export 'src/search/model/route_plan_param.dart';
export 'src/search/model/route_poi_result.dart';
export 'src/search/model/route_poi_search_query.dart';
export 'src/search/model/search_bound.dart';


class AmapSpecial {
//  static const MethodChannel _channel =
//      const MethodChannel('amap_special');
//
//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }

  static final _channel = MethodChannel('foton/amap_base');

  static Map<String, List<String>> assetManifest;

  static Future init(String key) async {
    _channel.invokeMethod('setKey', {'key': key});

    // 加载asset相关信息, 供区分图片分辨率用, 因为native端的加载asset方法无法区分分辨率, 这是一个变通方法
    assetManifest =
    await rootBundle.loadStructuredData<Map<String, List<String>>>(
      'AssetManifest.json',
          (String jsonData) {
        if (jsonData == null)
          return SynchronousFuture<Map<String, List<String>>>(null);

        final Map<String, dynamic> parsedJson = json.decode(jsonData);
        final Iterable<String> keys = parsedJson.keys;
        final Map parsedManifest = Map<String, List<String>>.fromIterables(
          keys,
          keys.map<List<String>>((key) => List<String>.from(parsedJson[key])),
        );
        return SynchronousFuture<Map<String, List<String>>>(parsedManifest);
      },
    );

    await AMapLocation().init();
  }

  @Deprecated('使用init方法初始化的时候设置key')
  static Future setKey(String key) {
    return _channel.invokeMethod('setKey', {'key': key});
  }
}
