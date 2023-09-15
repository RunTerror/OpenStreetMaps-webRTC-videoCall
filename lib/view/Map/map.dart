import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:video/view_model.dart/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final locationprovider = Provider.of<LocationProvider>(context);

    return locationprovider.currentLocation == null
        ? FutureBuilder(
            future: locationprovider.getCurrentLocation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(locationprovider.currentLocation!.latitude,
                        locationprovider.currentLocation!.longitude),
                    zoom: 13.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(markers: locationprovider.markers),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        : FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(locationprovider.currentLocation!.latitude,
                  locationprovider.currentLocation!.longitude),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: locationprovider.markers),
            ],
          );
  }
}
