import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Map extends StatelessWidget {
  final centre = LatLng(43.9457842, -78.895896);

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
          center: centre,
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
                point: centre,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.blue,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Icon clicked');
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
