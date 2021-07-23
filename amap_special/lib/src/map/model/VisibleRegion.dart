import 'dart:convert';
import 'dart:io';
import 'latlng.dart';

class VisibleRegion {
  LatLng nearLeft;//左下角
  LatLng nearRight;
  LatLng farLeft;
  LatLng farRight;//右上角

  String swLon,swLat,neLon,neLat;//iOS

  VisibleRegion(this.nearLeft, this.nearRight, this.farLeft, this.farRight);

  Map<String, Object> toJson() {
    return {
      'nearLeft': nearLeft.toJson(),
      'nearRight': nearRight.toJson(),
      'farLeft': farLeft.toJson(),
      'farRight': farRight.toJson(),
      'swLon': swLon,
      'swLat': swLat,
      'neLon': neLon,
      'neLat': neLat
    };
  }

  String toJsonString() => jsonEncode(toJson());

  VisibleRegion.fromJson(Map<String, dynamic> json){
    if(Platform.isIOS){
      swLon = json['swLon'];
      swLat = json['swLat'];
      neLon = json['neLon'];
      neLat = json['neLat'];
    }else{
      this.nearLeft = LatLng.fromJson(json['nearLeft']);
      nearRight = LatLng.fromJson(json['nearRight']);
      farLeft = LatLng.fromJson(json['farLeft']);
      farRight = LatLng.fromJson(json['farRight']);
    }
  }
}