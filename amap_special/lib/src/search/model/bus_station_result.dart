import 'dart:convert';

import 'package:amap_special/src/map/model/latlng.dart';
import 'package:amap_special/src/search/model/suggestion_city.dart';
import 'package:amap_special/src/search/model_ios/bus_station_result.ios.dart';

class BusStationResult {
  List<BusStation> busStations;
  int pageCount;
  Query query;
  List<SuggestionCity> searchSuggestionCities;
  List<String> searchSuggestionKeywords;

  BusStationResult({
    this.busStations,
    this.pageCount,
    this.query,
    this.searchSuggestionCities,
    this.searchSuggestionKeywords,
  });

  BusStationResult.ios(BusStationResult_iOS result) {
    busStations = result.busstops?.map((stop) {
      return BusStation(
        adCode: stop.adcode,
        busLineItems: stop.buslines?.map((busline) {
          return BusLineItem(
            basicPrice: busline.basicPrice.toDouble(),
            busLineId: busline.uid,
            busLineName: busline.name,
            busLineType: busline.type,
            cityCode: busline.citycode,
            distance: busline.distance.toDouble(),
            originatingStation: busline.startStop,
            terminalStation: busline.endStop,
            totalPrice: busline.totalPrice.toDouble(),
          );
        })?.toList(),
        busStationId: stop.uid,
        busStationName: stop.name,
        cityCode: stop.citycode,
        latLng: stop.location,
      );
    })?.toList();
    pageCount = result.count;
//    searchSuggestionCities = result.suggestion.cities?.map((city) {
//      return SuggestionCity(
//        cityName: city.city,
//        cityCode: city.citycode,
//        adCode: city.adcode,
//        suggestionNum: city.num,
//        districts: city.districts?.map((district) {
//          return District(
//
//          );
//        });
//      );
//    });
    searchSuggestionKeywords = result.suggestion.keywords;
  }

  BusStationResult.fromJson(Map<String, dynamic> json) {
    if (json['busStations'] != null) {
      busStations = List<BusStation>();
      json['busStations'].forEach((v) {
        busStations.add(BusStation.fromJson(v as Map<String, dynamic>));
      });
    }
    pageCount = json['pageCount'] as int;
    query = json['query'] != null ? Query.fromJson(json['query']) : null;
    if (json['searchSuggestionCities'] != null) {
      searchSuggestionCities = List<Null>();
      json['searchSuggestionCities'].forEach((v) {
        searchSuggestionCities
            .add(SuggestionCity.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['searchSuggestionKeywords'] != null) {
      searchSuggestionKeywords = List<String>();
      json['searchSuggestionKeywords'].forEach((v) {
        searchSuggestionKeywords.add(v as String);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.busStations != null) {
      data['busStations'] = this.busStations.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = this.pageCount;
    if (this.query != null) {
      data['query'] = this.query.toJson();
    }
    if (this.searchSuggestionCities != null) {
      data['searchSuggestionCities'] =
          this.searchSuggestionCities.map((v) => v.toJson()).toList();
    }
    if (this.searchSuggestionKeywords != null) {
      data['searchSuggestionKeywords'] = this.searchSuggestionKeywords;
    }
    return data;
  }

  BusStationResult copyWith({
    List busStations,
    int pageCount,
    Query query,
    List searchSuggestionCities,
    List searchSuggestionKeywords,
  }) {
    return BusStationResult(
      busStations: busStations ?? this.busStations,
      pageCount: pageCount ?? this.pageCount,
      query: query ?? this.query,
      searchSuggestionCities:
          searchSuggestionCities ?? this.searchSuggestionCities,
      searchSuggestionKeywords:
          searchSuggestionKeywords ?? this.searchSuggestionKeywords,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusStationResult &&
          runtimeType == other.runtimeType &&
          busStations == other.busStations &&
          pageCount == other.pageCount &&
          query == other.query &&
          searchSuggestionCities == other.searchSuggestionCities &&
          searchSuggestionKeywords == other.searchSuggestionKeywords;

  @override
  int get hashCode =>
      busStations.hashCode ^
      pageCount.hashCode ^
      query.hashCode ^
      searchSuggestionCities.hashCode ^
      searchSuggestionKeywords.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class BusStation {
  String adCode;
  List<BusLineItem> busLineItems;
  String busStationId;
  String busStationName;
  String cityCode;
  LatLng latLng;

  BusStation({
    this.adCode,
    this.busLineItems,
    this.busStationId,
    this.busStationName,
    this.cityCode,
    this.latLng,
  });

  BusStation.fromJson(Map<String, dynamic> json) {
    adCode = json['adCode'] as String;
    if (json['busLineItems'] != null) {
      busLineItems = List<BusLineItem>();
      json['busLineItems'].forEach((v) {
        busLineItems.add(BusLineItem.fromJson(v as Map<String, dynamic>));
      });
    }
    busStationId = json['busStationId'] as String;
    busStationName = json['busStationName'] as String;
    cityCode = json['cityCode'] as String;
    latLng = json['latLng'] != null ? LatLng.fromJson(json['latLng']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['adCode'] = this.adCode;
    if (this.busLineItems != null) {
      data['busLineItems'] = this.busLineItems.map((v) => v.toJson()).toList();
    }
    data['busStationId'] = this.busStationId;
    data['busStationName'] = this.busStationName;
    data['cityCode'] = this.cityCode;
    if (this.latLng != null) {
      data['latLng'] = this.latLng.toJson();
    }
    return data;
  }

  BusStation copyWith({
    String adCode,
    List busLineItems,
    String busStationId,
    String busStationName,
    String cityCode,
    LatLng latLng,
  }) {
    return BusStation(
      adCode: adCode ?? this.adCode,
      busLineItems: busLineItems ?? this.busLineItems,
      busStationId: busStationId ?? this.busStationId,
      busStationName: busStationName ?? this.busStationName,
      cityCode: cityCode ?? this.cityCode,
      latLng: latLng ?? this.latLng,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusStation &&
          runtimeType == other.runtimeType &&
          adCode == other.adCode &&
          busLineItems == other.busLineItems &&
          busStationId == other.busStationId &&
          busStationName == other.busStationName &&
          cityCode == other.cityCode &&
          latLng == other.latLng;

  @override
  int get hashCode =>
      adCode.hashCode ^
      busLineItems.hashCode ^
      busStationId.hashCode ^
      busStationName.hashCode ^
      cityCode.hashCode ^
      latLng.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class BusLineItem {
  double basicPrice;
  List<LatLng> bounds;
  String busLineId;
  String busLineName;
  String busLineType;
  List<BusStation> busStations;
  String cityCode;
  double distance;
  String originatingStation;
  String terminalStation;
  double totalPrice;

  BusLineItem({
    this.basicPrice,
    this.bounds,
    this.busLineId,
    this.busLineName,
    this.busLineType,
    this.busStations,
    this.cityCode,
    this.distance,
    this.originatingStation,
    this.terminalStation,
    this.totalPrice,
  });

  BusLineItem.fromJson(Map<String, dynamic> json) {
    basicPrice = json['basicPrice'] as double;
    if (json['bounds'] != null) {
      bounds = List<Null>();
      json['bounds'].forEach((v) {
        bounds.add(LatLng.fromJson(v as Map<String, dynamic>));
      });
    }
    busLineId = json['busLineId'] as String;
    busLineName = json['busLineName'] as String;
    busLineType = json['busLineType'] as String;
    if (json['busStations'] != null) {
      busStations = List<Null>();
      json['busStations'].forEach((v) {
        busStations.add(BusStation.fromJson(v as Map<String, dynamic>));
      });
    }
    cityCode = json['cityCode'] as String;
    distance = json['distance'] as double;
    originatingStation = json['originatingStation'] as String;
    terminalStation = json['terminalStation'] as String;
    totalPrice = json['totalPrice'] as double;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['basicPrice'] = this.basicPrice;
    if (this.bounds != null) {
      data['bounds'] = this.bounds.map((v) => v.toJson()).toList();
    }
    data['busLineId'] = this.busLineId;
    data['busLineName'] = this.busLineName;
    data['busLineType'] = this.busLineType;
    if (this.busStations != null) {
      data['busStations'] = this.busStations.map((v) => v.toJson()).toList();
    }
    data['cityCode'] = this.cityCode;
    data['distance'] = this.distance;
    data['originatingStation'] = this.originatingStation;
    data['terminalStation'] = this.terminalStation;
    data['totalPrice'] = this.totalPrice;
    return data;
  }

  BusLineItem copyWith({
    double basicPrice,
    List bounds,
    String busLineId,
    String busLineName,
    String busLineType,
    List busStations,
    String cityCode,
    double distance,
    String originatingStation,
    String terminalStation,
    double totalPrice,
  }) {
    return BusLineItem(
      basicPrice: basicPrice ?? this.basicPrice,
      bounds: bounds ?? this.bounds,
      busLineId: busLineId ?? this.busLineId,
      busLineName: busLineName ?? this.busLineName,
      busLineType: busLineType ?? this.busLineType,
      busStations: busStations ?? this.busStations,
      cityCode: cityCode ?? this.cityCode,
      distance: distance ?? this.distance,
      originatingStation: originatingStation ?? this.originatingStation,
      terminalStation: terminalStation ?? this.terminalStation,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusLineItem &&
          runtimeType == other.runtimeType &&
          basicPrice == other.basicPrice &&
          bounds == other.bounds &&
          busLineId == other.busLineId &&
          busLineName == other.busLineName &&
          busLineType == other.busLineType &&
          busStations == other.busStations &&
          cityCode == other.cityCode &&
          distance == other.distance &&
          originatingStation == other.originatingStation &&
          terminalStation == other.terminalStation &&
          totalPrice == other.totalPrice;

  @override
  int get hashCode =>
      basicPrice.hashCode ^
      bounds.hashCode ^
      busLineId.hashCode ^
      busLineName.hashCode ^
      busLineType.hashCode ^
      busStations.hashCode ^
      cityCode.hashCode ^
      distance.hashCode ^
      originatingStation.hashCode ^
      terminalStation.hashCode ^
      totalPrice.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class Query {
  String city;
  int pageNumber;
  int pageSize;
  String queryString;

  Query({
    this.city,
    this.pageNumber,
    this.pageSize,
    this.queryString,
  });

  Query.fromJson(Map<String, dynamic> json) {
    city = json['city'] as String;
    pageNumber = json['pageNumber'] as int;
    pageSize = json['pageSize'] as int;
    queryString = json['queryString'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['city'] = this.city;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['queryString'] = this.queryString;
    return data;
  }

  Query copyWith({
    String city,
    int pageNumber,
    int pageSize,
    String queryString,
  }) {
    return Query(
      city: city ?? this.city,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      queryString: queryString ?? this.queryString,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Query &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          pageNumber == other.pageNumber &&
          pageSize == other.pageSize &&
          queryString == other.queryString;

  @override
  int get hashCode =>
      city.hashCode ^
      pageNumber.hashCode ^
      pageSize.hashCode ^
      queryString.hashCode;

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}
