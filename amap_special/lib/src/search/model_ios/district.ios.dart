import 'package:amap_special/amap_special.dart';

// ignore: camel_case_types
class District_iOS {
  ///区域编码
  String adcode;

  ///城市编码
  String citycode;

  ///行政区名称
  String name;

  ///级别
  String level;

  ///城市中心点
  LatLng center;

  ///下级行政区域数组
  List<District_iOS> districts;

  ///行政区边界坐标点, String 数组
  List<String> polylines;

  District_iOS({
    this.adcode,
    this.citycode,
    this.name,
    this.level,
    this.center,
    this.districts,
    this.polylines,
  });

  District_iOS.fromJson(Map<String, dynamic> json) {
    adcode = json['adcode'] as String;
    citycode = json['citycode'] as String;
    name = json['name'] as String;
    level = json['level'] as String;
    if (json['center'] != null) {
      center = LatLng.fromJson(json['center'] as Map<String, Object>);
    }
    if (json['districts'] != null) {
      districts = List<District_iOS>();
      json['districts'].forEach((v) {
        districts.add(District_iOS.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['polylines'] != null) {
      polylines = List<String>();
      json['polylines'].forEach((v) {
        polylines.add(v as String);
      });
    }
  }

  Map<String, Object> toJson() {
    return {
      'adcode': adcode,
      'citycode': citycode,
      'name': name,
      'level': level,
      'center': center,
      'districts': districts,
      'polylines': polylines,
    };
  }

  @override
  String toString() {
    return 'District_iOS{adcode: $adcode, citycode: $citycode, name: $name, level: $level, center: $center, districts: $districts, polylines: $polylines}';
  }
}
