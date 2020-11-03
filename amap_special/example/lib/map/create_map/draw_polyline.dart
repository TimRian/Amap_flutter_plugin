import 'package:amap_special_example/utils/misc.dart';
import 'package:amap_special_example/utils/view.dart';
import 'package:flutter/material.dart';
import 'package:amap_special/amap_special.dart';

const polylineList = const [
  LatLng(39.999391, 116.135972),
  LatLng(39.898323, 116.057694),
  LatLng(39.900430, 116.265061),
  LatLng(39.955192, 116.140092),
];

class DrawPolylineScreen extends StatefulWidget {
  DrawPolylineScreen();

  factory DrawPolylineScreen.forDesignTime() => DrawPolylineScreen();

  @override
  _DrawPolylineScreenState createState() => _DrawPolylineScreenState();
}

class _DrawPolylineScreenState extends State<DrawPolylineScreen> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制线'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: AMapView(
        onAMapViewCreated: (controller) {
          _controller = controller;
          loading(
            context,
            controller.addPolyline(
              PolylineOptions(
                latLngList: polylineList,
                color: Colors.red,
                isDottedLine: true,
                isGeodesic: true,
                dottedLineType: PolylineOptions.DOTTED_LINE_TYPE_CIRCLE,
                width: 10,
              ),
            ),
          ).catchError((e) => showError(context, e.toString()));
        },
        ampOptions: AMapOptions(
          compassEnabled: true,
          zoomControlsEnabled: true,
          logoPosition: LOGO_POSITION_BOTTOM_CENTER,
          camera: CameraPosition(
            target: LatLng(39.8523323, 116.4033232),
            zoom: 10,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete_forever),
        onPressed: () async {
          _controller.clearMap();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
