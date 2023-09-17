
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;
  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;
  Location location = Location();

  getCurrentLocation() async {
    final userlocation = await location.getLocation();
    print(userlocation);
    if (userlocation.latitude != null && userlocation.longitude != null) {
      _currentLocation =
          LatLng(userlocation.latitude!, userlocation.longitude!);
      _markers.add(Marker(
        point: LatLng(userlocation.latitude!, userlocation.longitude!),
        builder: (context) {
          return const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          );
        },
      ));
      notifyListeners();
    }
  }
}
