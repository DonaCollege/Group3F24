import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackwise/services/api_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> _markers = {};
  final ApiService apiService = ApiService(); // Create an instance of ApiService
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // Check permissions on initialization
  }

  void _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage('Location permissions are permanently denied');
      return;
    }

    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _fetchAndDisplayPlaces(position.latitude, position.longitude);
    } catch (e) {
      _showMessage('Error getting location: $e');
    }
  }

  void _fetchAndDisplayPlaces(double latitude, double longitude) async {
    try {
      _markers.clear(); // Clear existing markers
      final places = await apiService.fetchPlaces(latitude, longitude);

      setState(() {
        for (var place in places) {
          _markers.add(Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']),
            infoWindow: InfoWindow(title: place['name']),
          ));
        }
        mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
        _isLoading = false; // Stop loading when done
      });
    } catch (e) {
      _showMessage('Error fetching places: $e');
      print('Error: $e'); // Log error for debugging
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Example')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194), // Initial position
                zoom: 14.0,
              ),
              markers: _markers,
            ),
    );
  }
}
