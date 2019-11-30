import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatelessWidget {
  final erc = LatLng(43.9457342, -78.896296);
  final ub = LatLng(43.9451842, -78.895996);
  final ua = LatLng(43.9446842, -78.896550);
  final sirc = LatLng(43.947750, -78.899262);
  final lib = LatLng(43.9458842, -78.897296);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            "Campus Map",
          )),
      body: FlutterMap(
        options: MapOptions(
          minZoom: 16.0, // Stop them from zooming out too much
          center: erc,
        ),
        layers: [
          TileLayerOptions(
            // for MapBox:
            urlTemplate:
                'https://api.mapbox.com/styles/v1/danbullockcs/ck3gs4cdb0e4k1cp7pkt5pcvd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFuYnVsbG9ja2NzIiwiYSI6ImNrM2RjN3hybDB2bm4zb3BiZHN4a25hbjAifQ.76_zGIc3VpbmIH9R0Ygpaw',
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 45.0,
                height: 45.0,
                point: erc,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 45.0,
                    onPressed: () {
                      print('ERC Icon clicked');
                    },
                  ),
                ),
              ),
              Marker(
                width: 45.0,
                height: 45.0,
                point: ub,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.lightBlue,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Business Building(UB) Icon clicked');
                    },
                  ),
                ),
              ),
              Marker(
                width: 45.0,
                height: 45.0,
                point: ua,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.green,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Science Building(UA) Icon clicked');
                    },
                  ),
                ),
              ),
              Marker(
                width: 45.0,
                height: 45.0,
                point: sirc,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {
                      print('SIRC Icon clicked');
                    },
                  ),
                ),
              ),
              Marker(
                width: 45.0,
                height: 45.0,
                point: lib,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.orange,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Library Icon clicked');
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "?",
          textScaleFactor: 3.0,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LegendPage(title: "Map Legend")));
        },
      ),
    );
  }
}

class LegendPage extends StatefulWidget {
  LegendPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LegendPageState createState() => _LegendPageState();
}

class _LegendPageState extends State<LegendPage> {
  var _geolocator = Geolocator();
  var _posMessage = "";
  var address = "";

  void _updateLocation(userLocation) {
    if (this.mounted) {
      setState(() {
        _posMessage =
            'Lat: ${userLocation.latitude} , Long: ${userLocation.longitude}';
        _geolocator
            .placemarkFromCoordinates(
                userLocation.latitude, userLocation.longitude)
            .then((List<Placemark> places) {
          for (Placemark place in places) {
            address = '${place.subThoroughfare} ${place.thoroughfare}';
          }
        });
      });
    }
  }

  @override
  void initState() {
    _geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best, timeInterval: 5000))
        .listen((userLocation) {
      _updateLocation(userLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text(
              "Map Legend",
            )),
        body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("ERC", textScaleFactor: 4.0),
                  Icon(Icons.location_on, color: Colors.purple, size: 50)
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("UB", textScaleFactor: 4.0),
                  Icon(Icons.location_on, color: Colors.lightBlue, size: 50),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("UA", textScaleFactor: 4.0),
                  Icon(Icons.location_on, color: Colors.green, size: 50),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("SIRC", textScaleFactor: 4.0),
                  Icon(Icons.location_on, color: Colors.red, size: 50),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("LIB", textScaleFactor: 4.0),
                  Icon(Icons.location_on, color: Colors.orange, size: 50),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      " Your Current location: \n $_posMessage \n Current Address:\n$address",
                      textScaleFactor: 1.5),
                ]),
              ]),
        ));
  }
}
