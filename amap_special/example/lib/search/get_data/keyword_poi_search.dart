import 'package:amap_special_example/utils/misc.dart';
import 'package:amap_special_example/utils/view.dart';
import 'package:amap_special_example/widgets/button.widget.dart';
import 'package:amap_special_example/widgets/dimens.dart';
import 'package:flutter/material.dart';
import 'package:amap_special/amap_special.dart';

class KeywordPoiSearchScreen extends StatefulWidget {
  KeywordPoiSearchScreen();

  factory KeywordPoiSearchScreen.forDesignTime() => KeywordPoiSearchScreen();

  @override
  _KeywordPoiSearchScreenState createState() => _KeywordPoiSearchScreenState();
}

class _KeywordPoiSearchScreenState extends State<KeywordPoiSearchScreen> {
  String _result = '';

  TextEditingController _queryController = TextEditingController(text: '肯德基');
  TextEditingController _cityController = TextEditingController(text: '杭州');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关键字检索POI'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入关键字',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              controller: _queryController,
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入关键字';
                }
              },
            ),
            SPACE_NORMAL,
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入城市',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              controller: _cityController,
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入城市';
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
                  AMapSearch().searchPoi(
                    PoiSearchQuery(
                      query: _queryController.text,
                      city: _cityController.text,
                    ),
                  ),
                ).then((poiResult) {
                  setState(() {
                    _result = jsonFormat(poiResult.toJson());
                  });
                }).catchError((e) => showError(context, e.toString()));
              },
            ),
            Text(_result, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
