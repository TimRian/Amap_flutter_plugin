import 'package:amap_special_example/location/location_page.dart';
import 'package:amap_special_example/map/screen.dart';
import 'package:amap_special_example/search/search.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amap_special/amap_special.dart';

void main(){
  runApp(new MaterialApp(home:new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
//    initMapKey();
//    initPlatformState();
  }

  void initMapKey() async{
    await AmapSpecial.init('27940e6f9d8c458f6771748968097ccd');
  }

//  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await AmapSpecial.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _platformVersion = platformVersion;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Running on: 13\n'),
            RaisedButton(
              child: Text('开始导航'),
              onPressed: () {
                AMapNavi().startNavi(
                  lat: 29.12,
                  lon: 119.64,
                  naviType: AMapNavi.ride,
                );
              },
            ),
            RaisedButton(
              child: Text('定位页'),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new LocationDemo();
                }));
              },
            ),
            RaisedButton(
              child: Text('地图'),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new MapDemo();
                }));
              },
            ),
            RaisedButton(
              child: Text('搜索'),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new SearchDemo();
                }));
              },
            ),
          ],
        ),
    );
  }
}
