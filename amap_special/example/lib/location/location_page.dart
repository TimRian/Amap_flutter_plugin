import 'dart:convert';

import 'package:amap_special/amap_special.dart';
import 'package:amap_special_example/widgets/button.widget.dart';
import 'package:amap_special_example/widgets/dimens.dart';
import 'package:flutter/material.dart';

class LocationDemo extends StatefulWidget {
  @override
  _LocationDemoState createState() {
    // TODO: implement createState
    return _LocationDemoState();
  }
}

class _LocationDemoState extends State<LocationDemo>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final _amapLocation = AMapLocation();

  List<Location> _result = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amapLocation.init();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('location'),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView(
                children:
                    _result.map((location) => _ResultItem(location)).toList(),
              ),
            ),
            SizedBox(width: 8, height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Button(
                  label: '单次定位',
                  onPressed: (context) async {
                    final options = LocationClientOptions(
                      isOnceLocation: true,
                      locatingWithReGeocode: true,
                    );

                    if (await Permissions().requestPermission()) {
                      _amapLocation
                          .getLocation(options)
                          .then(_result.add)
                          .then((_) => setState(() {}));
                    } else {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('请打开定位权限')));
                    }
                  },
                ),
                Button(
                  label: '连续定位',
                  onPressed: (context) async {
                    final options = LocationClientOptions(
                      isOnceLocation: false,
                      locatingWithReGeocode: true,
                    );

                    if (await Permissions().requestPermission()) {
                      _amapLocation
                          .startLocate(options)
                          .map(_result.add)
                          .listen((_) => setState(() {}));
                    } else {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('请打开定位权限')));
                    }
                  },
                ),
                Button(
                  label: '停止定位',
                  onPressed: (context) {
                    _amapLocation.stopLocate();
                  },
                ),
              ],
            ),
            SizedBox(width: 8, height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amapLocation.stopLocate();
    super.dispose();
  }
}

class _ResultItem extends StatelessWidget {
  final Location _data;

  const _ResultItem(this._data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            DateTime.now().toIso8601String(),
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SPACE_SMALL,
          Text(
            jsonFormat(_data.toJson()),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String jsonFormat(Map<String, Object> json) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}
