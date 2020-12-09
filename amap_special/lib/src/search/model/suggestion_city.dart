class SuggestionCity {
  /// 城市名称 [Android, iOS]
  String cityName;

  /// 城市编码 [Android, iOS]
  String cityCode;

  /// 城市区域编码 [Android, iOS]
  String adCode;

  /// 此区域的建议结果数目 [Android, iOS]
  int suggestionNum;

  /// 途径区域 [iOS暂未实现]
  Object districts;

  SuggestionCity({
    this.cityName,
    this.cityCode,
    this.adCode,
    this.suggestionNum,
    this.districts,
  });

  SuggestionCity.fromJson(Map<String, Object> json) {
    cityName = json['cityName'] as String;
    cityCode = json['cityCode'] as String;
    adCode = json['adCode'] as String;
    suggestionNum = json['suggestionNum'] as int;
    districts = json['districts'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cityName'] = this.cityName;
    data['cityCode'] = this.cityCode;
    data['adCode'] = this.adCode;
    data['suggestionNum'] = this.suggestionNum;
    data['districts'] = this.districts;
    return data;
  }

  @override
  String toString() {
    return 'SuggestionCity{cityName: $cityName, cityCode: $cityCode, adCode: $adCode, suggestionNum: $suggestionNum, districts: $districts}';
  }
}
