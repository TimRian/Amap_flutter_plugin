import 'dart:convert';

import 'package:amap_special/amap_special.dart';
import 'package:amap_special/src/map/model/latlng.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class CircleOptions {

  static const DOTTED_LINE_TYPE_CIRCLE = 1;
  static const DOTTED_LINE_TYPE_SQUARE = 0;

  static const LINE_CAP_TYPE_BUTT = 0;
  static const LINE_CAP_TYPE_SQUARE = 1;
  static const LINE_CAP_TYPE_ARROW = 2;
  static const LINE_CAP_TYPE_ROUND = 3;

  static const LINE_JOIN_BEVEL = 0;
  static const LINE_JOIN_MITER = 1;
  static const LINE_JOIN_ROUND = 2;


  /// Circle的fillColor透明度 [Android, iOS]
  final num alpha;

  /// Circle的半径 [Android, iOS]
  final num radius;

  /// Circle覆盖物的位置坐标 [Android, iOS]
  final LatLng position;

  /// 线段的宽度 [Android, iOS]
  final double width;

  /// 笔触颜色 [Android, iOS]
  final Color strokeColor;

  /// 填充颜色 [Android, iOS]
  final Color fillColor;

  /// 线段是否画虚线，默认为false，画实线 [Android, iOS]
  final bool isDottedLine;

  /// 虚线形状 [Android, iOS]
  final int dottedLineType;

  /// Polyline尾部形状 [Android, iOS]
  final int lineCapType;

  /// Polyline连接处形状 [Android, iOS]
  final int lineJoinType;

  CircleOptions({
    this.alpha = 0.1,
    this.radius = 1000,
    this.width = 1.0,
    this.strokeColor = Colors.blue,
    this.fillColor = Colors.blue,
    this.isDottedLine = false,
    this.dottedLineType = DOTTED_LINE_TYPE_SQUARE,
    this.lineCapType = LINE_CAP_TYPE_BUTT,
    this.lineJoinType = LINE_JOIN_BEVEL,
    @required this.position
  });

  Map<String, Object> toJson() {
    return {
      'alpha': alpha,
      'width': width,
      'radius':radius,
      'strokeColor': strokeColor.value.toRadixString(16),
      'fillColor': fillColor.value.toRadixString(16),
      'isDottedLine': isDottedLine,
      'dottedLineType': dottedLineType,
      'lineCapType': lineCapType,
      'lineJoinType': lineJoinType,
      'position':position
    };
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() {
    return 'CircleOptions{alpha: $alpha, width: $width, strokeColor: $strokeColor, fillColor: $fillColor, '
        'isDottedLine: $isDottedLine, dottedLineType: $dottedLineType, lineCapType: $lineCapType, '
        'lineJoinType: $lineJoinType, position:$position}';
  }
}
