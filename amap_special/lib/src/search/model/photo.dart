class Photo {
  /// 标题 [Android, iOS]
  String title;

  /// url [Android, iOS]
  String url;

  Photo({
    this.title,
    this.url,
  });

  Photo.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String;
    url = json['url'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }

  Photo copyWith({
    String title,
    String url,
  }) {
    return Photo(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          url == other.url;

  @override
  int get hashCode => title.hashCode ^ url.hashCode;

  @override
  String toString() {
    return '''Photos{
		title: $title,
		url: $url}''';
  }
}
