import 'dart:math';

import 'package:amap_special/amap_special.dart';
import 'package:amap_special_example/utils/misc.dart';
import 'package:amap_special_example/utils/view.dart';
import 'package:flutter/material.dart';

const markerList = const [
  LatLng(30.308800, 120.0783827),
  LatLng(30.2412, 120.00938),
  LatLng(30.296945, 120.35133),
  LatLng(30.328955, 120.365063),
  LatLng(30.181862, 120.369183),
];

class DrawCircleScreen extends StatefulWidget {
  DrawCircleScreen();

  factory DrawCircleScreen.forDesignTime() => DrawCircleScreen();

  @override
  DrawCircleScreenState createState() => DrawCircleScreenState();
}

class DrawCircleScreenState extends State<DrawCircleScreen> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制圆'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(icon: Image.asset("images/home_map_icon_positioning_nor.png"), onPressed: () {


//            _controller.addMarker(
//              MarkerOptions(
//                icon: 'images/home_map_icon_positioning_nor.png',
//                position: LatLng(39, 116),
//                title: '起点',
//                snippet: '呵呵',
//              )
//            );

          _controller.clearMap();

          }),
        ],
      ),
      body: Builder(
        builder: (context) {
          return AMapView(
            onAMapViewCreated: (controller) {
              _controller = controller;

              loading(
                context,
                controller.addCircle(
                  CircleOptions(
                      position: LatLng(39, 116),
                    alpha: 0.1,
                    width: 1.0,
                    radius: 5000,
                    fillColor: Colors.blue,
                    strokeColor: Colors.blue,
                  ),
                ),
              ).catchError((e) => showError(context, e.toString()));

              //来自插件消息的接收
              _controller.markerClickedEvent.listen((marker) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(marker.toString())));
              });

               _controller.regionDidChangeEvent.listen((event) async{
                 Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(event.toJsonString())));

                 //画随机圆
                 final nextLatLng = event;
                 await _controller.addCircle(
                   CircleOptions(
                     position: nextLatLng,
                     alpha: 0.1,
                     width: 1.0,
                     radius: 5000,
                     fillColor: Colors.blue,
                     strokeColor: Colors.blue,
                   ),
                 );

               });

               _controller.regionWillChangeEvent.listen((event) {
                 Scaffold.of(context)
                     .showSnackBar(SnackBar(content: Text(event)));
                 _controller.clearMap();
               });
            },
            ampOptions: AMapOptions(
              compassEnabled: true,
              zoomControlsEnabled: true,
              logoPosition: LOGO_POSITION_BOTTOM_CENTER,
              camera: CameraPosition(
                target: LatLng(39, 116),
                zoom: 10,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          //画随机圆
          final nextLatLng = _nextLatLng();
          await _controller.addCircle(
            CircleOptions(
              position: nextLatLng,
              alpha: 0.1,
              width: 1.0,
              radius: 5000,
              fillColor: Colors.blue,
              strokeColor: Colors.blue,
            ),
          );
          await _controller.changeLatLng(nextLatLng);

        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LatLng _nextLatLng() {
    final _random = Random();
    double nextLat = (391818 + _random.nextInt(303289 - 301818)) / 10000;
    double nextLng = (1160093 + _random.nextInt(1203691 - 1200093)) / 10000;
    return LatLng(nextLat, nextLng);
  }

}