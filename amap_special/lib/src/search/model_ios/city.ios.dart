import 'package:amap_special/src/search/model_ios/district.ios.dart';

// ignore: camel_case_types
class City_iOS {
  ///城市名称
  String city;

  ///城市编码
  String citycode;

  ///城市区域编码
  String adcode;

  ///此区域的建议结果数目, AMapSuggestion 中使用
  int num;

  ///途径区域 AMapDistrict 数组，AMepStep中使用，只有name和adcode。
  List<District_iOS> districts;

  City_iOS({
    this.city,
    this.citycode,
    this.adcode,
    this.num,
    this.districts,
  });

  City_iOS.fromJson(Map<String, dynamic> json) {
    city = json['city'] as String;
    citycode = json['citycode'] as String;
    adcode = json['adcode'] as String;
    num = json['num'] as int;
    if (json['districts'] != null) {
      districts = List<District_iOS>();
      json['districts'].forEach((v) {
        districts.add(District_iOS.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, Object> toJson() {
    return {
      'city': city,
      'citycode': citycode,
      'adcode': adcode,
      'num': num,
      'districts': districts?.map((it) => it.toJson())?.toList(),
    };
  }

  @override
  String toString() {
    return 'City_iOS{city: $city, citycode: $citycode, adcode: $adcode, num: $num, districts: $districts}';
  }
}
