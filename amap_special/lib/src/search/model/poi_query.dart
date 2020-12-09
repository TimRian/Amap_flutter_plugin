/// [Android]
class Query {
  String a;
  String c;
  int d;
  int e;
  String f;
  bool g;
  bool h;
  bool j;

  Query({
    this.a,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.j,
  });

  Query.fromJson(Map<String, dynamic> json) {
    a = json['a'] as String;
    c = json['c'] as String;
    d = json['d'] as int;
    e = json['e'] as int;
    f = json['f'] as String;
    g = json['g'] as bool;
    h = json['h'] as bool;
    j = json['j'] as bool;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['a'] = this.a;
    data['c'] = this.c;
    data['d'] = this.d;
    data['e'] = this.e;
    data['f'] = this.f;
    data['g'] = this.g;
    data['h'] = this.h;
    data['j'] = this.j;
    return data;
  }

  Query copyWith({
    String a,
    String c,
    int d,
    int e,
    String f,
    bool g,
    bool h,
    bool j,
  }) {
    return Query(
      a: a ?? this.a,
      c: c ?? this.c,
      d: d ?? this.d,
      e: e ?? this.e,
      f: f ?? this.f,
      g: g ?? this.g,
      h: h ?? this.h,
      j: j ?? this.j,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Query &&
          runtimeType == other.runtimeType &&
          a == other.a &&
          c == other.c &&
          d == other.d &&
          e == other.e &&
          f == other.f &&
          g == other.g &&
          h == other.h &&
          j == other.j;

  @override
  int get hashCode =>
      a.hashCode ^
      c.hashCode ^
      d.hashCode ^
      e.hashCode ^
      f.hashCode ^
      g.hashCode ^
      h.hashCode ^
      j.hashCode;

  @override
  String toString() {
    return '''Query{
		a: $a,
		c: $c,
		d: $d,
		e: $e,
		f: $f,
		g: $g,
		h: $h,
		j: $j}''';
  }
}
