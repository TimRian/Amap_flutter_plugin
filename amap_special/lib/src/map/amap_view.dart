import 'dart:convert';
import 'package:amap_special/amap_special.dart';
import 'package:amap_special/src/map/amap_controller.dart';
import 'package:amap_special/src/map/model/amap_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const _viewType = 'foton/AMapView';

typedef void MapCreatedCallback(AMapController controller); //暴露Map控制器

class AMapView extends StatelessWidget {

//  Flutter 嵌入原生
  const AMapView({
    Key key,
    this.onAMapViewCreated,
    this.hitTestBehavior = PlatformViewHitTestBehavior.opaque,
    this.layoutDirection,
    this.ampOptions = const AMapOptions(),
  }) : super(key: key);

  final MapCreatedCallback onAMapViewCreated;
  final PlatformViewHitTestBehavior hitTestBehavior;
  final TextDirection layoutDirection;
  final AMapOptions ampOptions;

  @override
  Widget build(BuildContext context) {
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    ].toSet();

    final String params = jsonEncode(ampOptions.toJson());

    final messageCodec = StandardMessageCodec();

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewType,
        hitTestBehavior: hitTestBehavior,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: _onViewCreated,
        layoutDirection: layoutDirection,
        creationParams: params,
        creationParamsCodec: messageCodec,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS){
      return UiKitView(
        viewType: _viewType,
        hitTestBehavior: hitTestBehavior,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: _onViewCreated,
        layoutDirection: layoutDirection,
        creationParams: params,
        creationParamsCodec: messageCodec,
      );
    } else {
      return Text('$defaultTargetPlatform is not yet supported by the maps plugin');
    }
  }


  void _onViewCreated(int id) {
    final controller = AMapController.withId(id);
    if (onAMapViewCreated != null) {
      onAMapViewCreated(controller);
    }
  }
}
