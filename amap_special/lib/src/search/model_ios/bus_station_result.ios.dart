import 'dart:convert';

import 'package:amap_special/src/map/model/latlng.dart';
import 'package:amap_special/src/search/model_ios/city.ios.dart';

// ignore: camel_case_types
class BusStationResult_iOS {
  int count;
  Suggestion suggestion;
  List<Busstops> busstops;

  BusStationResult_iOS({
    this.count,
    this.suggestion,
    this.busstops,
  });

  BusStationResult_iOS.fromJson(Map<String, dynamic> json) {
    count = json['count'] as int;
    suggestion = json['suggestion'] != null
        ? Suggestion.fromJson(json['suggestion'])
        : null;
    if (json['busstops'] != null) {
      busstops = List<Busstops>();
      json['busstops'].forEach((v) {
        busstops.add(Busstops.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = this.count;
    if (this.suggestion != null) {
      data['suggestion'] = this.suggestion.toJson();
    }
    if (this.busstops != null) {
      data['busstops'] = this.busstops.map((v) => v.toJson()).toList();
    }
    return data;
  }

  BusStationResult_iOS copyWith({
    int count,
    Suggestion suggestion,
    List busstops,
  }) {
    return BusStationResult_iOS(
      count: count ?? this.count,
      suggestion: suggestion ?? this.suggestion,
      busstops: busstops ?? this.busstops,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusStationResult_iOS &&
          runtimeType == other.runtimeType &&
          count == other.count &&
          suggestion == other.suggestion &&
          busstops == other.busstops;

  @override
  int get hashCode => count.hashCode ^ suggestion.hashCode ^ busstops.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class Suggestion {
  List<City_iOS> cities;
  List<String> keywords;

  Suggestion({
    this.cities,
    this.keywords,
  });

  Suggestion.fromJson(Map<String, dynamic> json) {
    if (json['cities'] != null) {
      cities = List<Null>();
      json['cities'].forEach((v) {
        cities.add(City_iOS.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['keywords'] != null) {
      keywords = List<String>();
      json['keywords'].forEach((v) {
        keywords.add(v as String);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    if (this.keywords != null) {
      data['keywords'] = this.keywords;
    }
    return data;
  }

  Suggestion copyWith({
    List cities,
    List keywords,
  }) {
    return Suggestion(
      cities: cities ?? this.cities,
      keywords: keywords ?? this.keywords,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Suggestion &&
          runtimeType == other.runtimeType &&
          cities == other.cities &&
          keywords == other.keywords;

  @override
  int get hashCode => cities.hashCode ^ keywords.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class Busstops {
  LatLng location;
  String uid;
  String sequence;
  String adcode;
  String citycode;
  List<Busline> buslines;
  String name;

  Busstops({
    this.location,
    this.uid,
    this.sequence,
    this.adcode,
    this.citycode,
    this.buslines,
    this.name,
  });

  Busstops.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? LatLng.fromJson(json['location']) : null;
    uid = json['uid'] as String;
    sequence = json['sequence'] as String;
    adcode = json['adcode'] as String;
    citycode = json['citycode'] as String;
    if (json['buslines'] != null) {
      buslines = List<Busline>();
      json['buslines'].forEach((v) {
        buslines.add(Busline.fromJson(v as Map<String, dynamic>));
      });
    }
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['uid'] = this.uid;
    data['sequence'] = this.sequence;
    data['adcode'] = this.adcode;
    data['citycode'] = this.citycode;
    if (this.buslines != null) {
      data['buslines'] = this.buslines.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }

  Busstops copyWith({
    LatLng location,
    String uid,
    String sequence,
    String adcode,
    String citycode,
    List buslines,
    String name,
  }) {
    return Busstops(
      location: location ?? this.location,
      uid: uid ?? this.uid,
      sequence: sequence ?? this.sequence,
      adcode: adcode ?? this.adcode,
      citycode: citycode ?? this.citycode,
      buslines: buslines ?? this.buslines,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Busstops &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          uid == other.uid &&
          sequence == other.sequence &&
          adcode == other.adcode &&
          citycode == other.citycode &&
          buslines == other.buslines &&
          name == other.name;

  @override
  int get hashCode =>
      location.hashCode ^
      uid.hashCode ^
      sequence.hashCode ^
      adcode.hashCode ^
      citycode.hashCode ^
      buslines.hashCode ^
      name.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class Busline {
  int totalPrice;
  String uid;
  String endStop;
  String company;
  String type;
  LatLng location;
  String endTime;
  String citycode;
  String polyline;
  String startStop;
  int duration;
  int distance;
  String startTime;
  String name;
  int basicPrice;

  Busline({
    this.totalPrice,
    this.uid,
    this.endStop,
    this.company,
    this.type,
    this.location,
    this.endTime,
    this.citycode,
    this.polyline,
    this.startStop,
    this.duration,
    this.distance,
    this.startTime,
    this.name,
    this.basicPrice,
  });

  Busline.fromJson(Map<String, dynamic> json) {
    totalPrice = json['totalPrice'] as int;
    uid = json['uid'] as String;
    endStop = json['endStop'] as String;
    company = json['company'] as String;
    type = json['type'] as String;
    location =
        json['location'] != null ? LatLng.fromJson(json['location']) : null;
    endTime = json['endTime'] as String;
    citycode = json['citycode'] as String;
    polyline = json['polyline'] as String;
    startStop = json['startStop'] as String;
    duration = json['duration'] as int;
    distance = json['distance'] as int;
    startTime = json['startTime'] as String;
    name = json['name'] as String;
    basicPrice = json['basicPrice'] as int;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalPrice'] = this.totalPrice;
    data['uid'] = this.uid;
    data['endStop'] = this.endStop;
    data['company'] = this.company;
    data['type'] = this.type;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['endTime'] = this.endTime;
    data['citycode'] = this.citycode;
    data['polyline'] = this.polyline;
    data['startStop'] = this.startStop;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    data['startTime'] = this.startTime;
    data['name'] = this.name;
    data['basicPrice'] = this.basicPrice;
    return data;
  }

  Busline copyWith({
    int totalPrice,
    String uid,
    String endStop,
    String company,
    String type,
    LatLng location,
    String endTime,
    String citycode,
    String polyline,
    String startStop,
    int duration,
    int distance,
    String startTime,
    String name,
    int basicPrice,
  }) {
    return Busline(
      totalPrice: totalPrice ?? this.totalPrice,
      uid: uid ?? this.uid,
      endStop: endStop ?? this.endStop,
      company: company ?? this.company,
      type: type ?? this.type,
      location: location ?? this.location,
      endTime: endTime ?? this.endTime,
      citycode: citycode ?? this.citycode,
      polyline: polyline ?? this.polyline,
      startStop: startStop ?? this.startStop,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      startTime: startTime ?? this.startTime,
      name: name ?? this.name,
      basicPrice: basicPrice ?? this.basicPrice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Busline &&
          runtimeType == other.runtimeType &&
          totalPrice == other.totalPrice &&
          uid == other.uid &&
          endStop == other.endStop &&
          company == other.company &&
          type == other.type &&
          location == other.location &&
          endTime == other.endTime &&
          citycode == other.citycode &&
          polyline == other.polyline &&
          startStop == other.startStop &&
          duration == other.duration &&
          distance == other.distance &&
          startTime == other.startTime &&
          name == other.name &&
          basicPrice == other.basicPrice;

  @override
  int get hashCode =>
      totalPrice.hashCode ^
      uid.hashCode ^
      endStop.hashCode ^
      company.hashCode ^
      type.hashCode ^
      location.hashCode ^
      endTime.hashCode ^
      citycode.hashCode ^
      polyline.hashCode ^
      startStop.hashCode ^
      duration.hashCode ^
      distance.hashCode ^
      startTime.hashCode ^
      name.hashCode ^
      basicPrice.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}
