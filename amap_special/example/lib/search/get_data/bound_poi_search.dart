import 'package:amap_special_example/utils/misc.dart';
import 'package:amap_special_example/utils/view.dart';
import 'package:amap_special_example/widgets/button.widget.dart';
import 'package:amap_special_example/widgets/setting.widget.dart';
import 'package:flutter/material.dart';
import 'package:amap_special/amap_special.dart';

class BoundPoiSearchScreen extends StatefulWidget {
  BoundPoiSearchScreen();

  factory BoundPoiSearchScreen.forDesignTime() => BoundPoiSearchScreen();

  @override
  _BoundPoiSearchScreenState createState() => _BoundPoiSearchScreenState();
}

class _BoundPoiSearchScreenState extends State<BoundPoiSearchScreen> {

  String _result = '';

  TextEditingController _centerController = TextEditingController(text: '天安门');
  TextEditingController _keywordController = TextEditingController(text: '厕所');
  TextEditingController _rangeController = TextEditingController(text: '1000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('周边检索POI'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入中心',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              enabled: false,
              controller: _centerController,
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入中心';
                }
              },
            ),
            SPACE_NORMAL,
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入关键字',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              controller: _keywordController,
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入关键字';
                }
              },
            ),
            SPACE_NORMAL,
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入半径/米',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              controller: _rangeController,
              validator: (value) {
                try {
                  int.parse(value);
                } catch (e) {
                  return '请输入数字';
                }
              },
            ),
            SPACE_NORMAL,
            Button(
              label: '开始搜索',
              onPressed: (context) async {
                if (!Form.of(context).validate()) {
                  return;
                }

                loading(
                  context,
                  AMapSearch().searchPoiBound(
                    PoiSearchQuery(
                      query: _keywordController.text,
                      location: LatLng(39.909604, 116.397228), // iOS必须
                      searchBound: SearchBound(
                        center: LatLng(39.909604, 116.397228),
                        range: int.parse(_rangeController.text),
                      ), // Android必须
                    ),
                  ),
                ).then((poiResult) {
                  setState(() {
                    _result = poiResult.toString();
                  });
                }).catchError((e) => showError(context, e.toString()));
              },
            ),
            SPACE_NORMAL,
            Text(_result, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _centerController.dispose();
    _keywordController.dispose();
    _rangeController.dispose();
    super.dispose();
  }
}