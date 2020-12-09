class IndoorData {
  /// 楼层，为0时为POI本身 [Android, iOS]
  int floor;

  /// 楼层名称 [Android, iOS]
  String floorName;

  /// 建筑物ID [Android, iOS]
  String poiId;

  IndoorData({
    this.floor,
    this.floorName,
    this.poiId,
  });

  IndoorData.fromJson(Map<String, dynamic> json) {
    floor = json['floor'] as int;
    floorName = json['floorName'] as String;
    poiId = json['poiId'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['floor'] = this.floor;
    data['floorName'] = this.floorName;
    data['poiId'] = this.poiId;
    return data;
  }

  IndoorData copyWith({
    int floor,
    String floorName,
    String poiId,
  }) {
    return IndoorData(
      floor: floor ?? this.floor,
      floorName: floorName ?? this.floorName,
      poiId: poiId ?? this.poiId,
    );
  }

  @override
  String toString() {
    return '''IndoorData{
		floor: $floor,
		floorName: $floorName,
		poiId: $poiId}''';
  }
}
