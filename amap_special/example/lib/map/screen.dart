

import 'package:amap_special_example/map/create_map/circle_map.dart';
import 'package:amap_special_example/map/create_map/custom_map.dart';
import 'package:amap_special_example/map/create_map/draw_point.dart';
import 'package:amap_special_example/map/create_map/draw_polyline.dart';
import 'package:amap_special_example/map/create_map/show_map.dart';
import 'package:flutter/material.dart';

class MapDemo extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Map"),),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("显示地图", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new ShowMapScreen();
                }));
              },
            ),
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("绘制点标记", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new DrawPointScreen();
                }));
              },
            ),
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("绘制折线", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new DrawPolylineScreen();
                }));
              },
            ),
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("自定义地图", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new CustomMapScreen();
                }));
              },
            ),
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("画圈圈", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new DrawCircleScreen();
                }));
              },
            ),
          ],
        ),
      ),

    ) ;

  }

}