import 'package:amap_special/amap_special.dart';
import 'package:flutter/material.dart';

class CustomMapScreen extends StatefulWidget {
  @override
  _CustomMapScreenState createState() => _CustomMapScreenState();
}

class _CustomMapScreenState extends State<CustomMapScreen> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义地图'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: AMapView(
        onAMapViewCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.map),
        onPressed: () async {
          print(await _controller.getVisibleRegion().toString());
          var r = await _controller.getVisibleRegion();
          print(r.neLat);
          // await _controller?.setCustomMapStylePath('amap_assets/style.data');
          // await _controller?.setMapCustomEnable(true);
        },
      ),
    );
  }
}
