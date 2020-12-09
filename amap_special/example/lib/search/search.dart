

import 'package:amap_special_example/search/get_data/bound_poi_search.dart';
import 'package:amap_special_example/search/get_data/keyword_poi_search.dart';
import 'package:flutter/material.dart';

class SearchDemo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("搜索"),),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("周边检索POI", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new BoundPoiSearchScreen();
                }));
              },
            ),
            SizedBox(height: 20,),
            GestureDetector(
              child: Center(child: Text("关键字检索POI", style: TextStyle(fontSize: 16, color: Colors.red,),)),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new KeywordPoiSearchScreen();
                }));
              },
            ),
          ],
        ),
      ),

    ) ;

  }



}