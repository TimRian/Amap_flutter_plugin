import 'package:amap_special/src/map/model/latlng.dart';

class SubPoiItem {
  /// POI全局唯一ID [Android, iOS]
  String poiId;

  /// POI全称，如“北京大学(西2门)” [Android, iOS]
  String title;

  /// 子POI的子名称，如“西2门” [Android, iOS]
  String subName;

  /// 距中心点距离 [Android, iOS]
  int distance;

  /// 经纬度 [Android, iOS]
  LatLng latLonPoint;

  /// 地址 [Android, iOS]
  String snippet;

  /// 子POI类型 [Android, iOS]
  String subTypeDes;

  SubPoiItem.fromJson(Map<String, dynamic> json) {
    poiId = json['poiId'] as String;
    title = json['title'] as String;
    subName = json['subName'] as String;
    distance = json['distance'] as int;
    latLonPoint = LatLng.fromJson(json['latLonPoint'] as Map<String, Object>);
    snippet = json['snippet'] as String;
    subTypeDes = json['subTypeDes'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['poiId'] = this.poiId;
    data['title'] = this.title;
    data['subName'] = this.subName;
    data['distance'] = this.distance;
    data['latLonPoint'] = this.latLonPoint.toJson();
    data['snippet'] = this.snippet;
    data['subTypeDes'] = this.subTypeDes;
    return data;
  }

  @override
  String toString() {
    return 'SubPoiItem{poiId: $poiId, title: $title, subName: $subName, distance: $distance, latLonPoint: $latLonPoint, snippet: $snippet, subTypeDes: $subTypeDes}';
  }
}
