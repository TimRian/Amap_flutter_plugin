import 'dart:math';

import 'package:amap_special/amap_special.dart';
import 'package:flutter/material.dart';

const markerList = const [
  LatLng(30.308800, 120.0783827),
  LatLng(30.2412, 120.00938),
  LatLng(30.296945, 120.35133),
  LatLng(30.328955, 120.365063),
  LatLng(30.181862, 120.369183),
];

class DrawPointScreen extends StatefulWidget {
  DrawPointScreen();

  factory DrawPointScreen.forDesignTime() => DrawPointScreen();

  @override
  DrawPointScreenState createState() => DrawPointScreenState();
}

class DrawPointScreenState extends State<DrawPointScreen> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制点标记'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return AMapView(
            onAMapViewCreated: (controller) {
              _controller = controller;
              _controller.markerClickedEvent.listen((marker) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(marker.toString())));
              });
              Future.delayed(Duration(milliseconds: 3000), (){
                controller.addMarkers(
                  markerList
                      .map((latLng) => MarkerOptions(
                    icon: 'images/home_map_icon_positioning_nor.png',
                    position: latLng,
                    title: '京A123456',
                    snippet: '呵呵',
                    infoWindowEnable: false,
                    selected: true,
                    titleColor: Color(0XFF991299),
                    allVin: 'VH124K89434343'
                  ))
                      .toList(),
                );
              });
            },
            ampOptions: AMapOptions(
              compassEnabled: true,
              zoomControlsEnabled: true,
              logoPosition: LOGO_POSITION_BOTTOM_CENTER,
              camera: CameraPosition(
                target: LatLng(30.308800, 120.0783827),
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
          final nextLatLng = _nextLatLng();
          await _controller.addMarkers(
            markerList
                .map((latLng) => MarkerOptions(
              icon: 'images/home_map_icon_positioning_nor.png',
              position: latLng,
              title: '起点',
              snippet: '呵呵',
            ))
                .toList(),
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
    double nextLat = (301818 + _random.nextInt(303289 - 301818)) / 10000;
    double nextLng = (1200093 + _random.nextInt(1203691 - 1200093)) / 10000;
    return LatLng(nextLat, nextLng);
  }
}