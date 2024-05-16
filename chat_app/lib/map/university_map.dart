
import 'package:chat_app/map/tile_providers.dart';
import 'package:chat_app/map/zoombuttons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class PluginZoomButtons extends StatelessWidget {
  static const String route = '/plugin_zoombuttons';

   PluginZoomButtons({super.key,});
 final MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alyarmouk map')),
      //drawer: const MenuDrawer(PluginZoomButtons.route),
      body: FlutterMap(
        mapController:mapController ,
        options: const MapOptions(
          initialCenter: LatLng(32.538455, 35.854876),
          initialZoom: 16.5,
        ),
        children: [
          openStreetMapTileLayer,
          const FlutterMapZoomButtons(
            minZoom: 4,
            maxZoom: 19,
           mini: true,
            padding: 10,
            alignment: Alignment.bottomRight,
          ),

        ],
      ),
    );
  }
}

