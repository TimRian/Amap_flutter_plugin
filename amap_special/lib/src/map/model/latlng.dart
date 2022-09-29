import 'dart:convert';

class LatLng {
  final double latitude;
  final double longitude;

  //可选的
  ///角度, 标识移动方向，单位度
  final double angle;
  ///速度，单位km/h
  final double speed;
  ///时间，单位毫秒
  final int time;
  // ///时间，单位毫秒
  // final String androidTime;


  const LatLng(this.latitude, this.longitude, {this.angle=0.0, this.speed=0.0, this.time=0});

  Map<String, Object> toJson() {

    final data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['angle'] = angle;
    data['speed'] = speed;
    data['time'] = time;
    return data;

    // return {
    //   'latitude': latitude,
    //   'longitude': longitude,
    //
    // };
  }

  String toJsonString() => jsonEncode(toJson());

  LatLng.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double,
        longitude = json['longitude'] as double,
        angle = json['angle']?.toDouble(),
        speed = json['speed']?.toDouble(),
        time = json['time'] as int;

  LatLng copyWith({
    double latitude,
    double longitude,
  }) {
    return LatLng(
      latitude ?? this.latitude,
      longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'LatLng{lat: $latitude, lng: $longitude, angle: $angle, speed: $speed, time: $time}';
  }
}
