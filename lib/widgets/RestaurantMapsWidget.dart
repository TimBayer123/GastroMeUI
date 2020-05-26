import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart';

class RestaurantMapsWidget extends StatefulWidget {
  Restaurant restaurant;
  RestaurantMapsWidget(this.restaurant);

  @override
  State<RestaurantMapsWidget> createState() => _RestaurantMapsWidget();
}

class _RestaurantMapsWidget extends State<RestaurantMapsWidget> with SingleTickerProviderStateMixin {
  final Geolocator geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
      distanceFilter: 10);

  Map<String, Marker> _markers = {};

  Position currentPosition;

  Future<CameraPosition> _cameraPosition;

  AnimationController controller;

  @override
  initState() {
    _cameraPosition = setCameraPosition();

    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<CameraPosition> setCameraPosition() async {
    currentPosition = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    LatLng restaurantLatLng = LatLng(widget.restaurant.standort.breitengrad, widget.restaurant.standort.laengengrad);
    LatLng currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    return CameraPosition(
        target: calculateCenterPointOf(restaurantLatLng, currentLatLng),
        zoom: 10);
  }

  LatLng calculateCenterPointOf(LatLng point1, LatLng point2){
    double dLon = radians(point2.longitude - point1.longitude);

    double lat1 = radians(point1.latitude);
    double lat2 = radians(point2.latitude);
    double lon1 = radians(point1.longitude);

    double Bx = cos(lat2) * cos(dLon);
    double By = cos(lat2) * sin(dLon);
    double lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + Bx) * (cos(lat1) + Bx) + By * By));
    double lon3 = lon1 + atan2(By, cos(lat1) + Bx);

    return LatLng(degrees(lat3), degrees(lon3));
  }

  Future<void> _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.clear();

      geolocator.getPositionStream((locationOptions)).listen((position) async {
        updateMarkers(position);
      });

      updateMarkers(currentPosition);
    });


  }

  Future<void> updateMarkers(Position position) {
    final marker_restaurant = Marker(
      markerId: MarkerId(widget.restaurant.name),
      position: LatLng(widget.restaurant.standort.breitengrad, widget.restaurant.standort.laengengrad),
      infoWindow: InfoWindow(
        title: widget.restaurant.name,
        snippet: widget.restaurant.standort.asText(),
      ),
    );

    final marker_currentPosition = Marker(
      markerId: MarkerId("Dein Standort"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: "Dein Standort",
        snippet: "Hier befindest du dich gerade",
      ),
    );

    _markers["restaurant"] = marker_restaurant;
    _markers["currentPosition"] = marker_currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 30,
      right: 30,
      top: 330,
      bottom: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: FutureBuilder(
          future: _cameraPosition,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: snapshot.data,
                markers: _markers.values.toSet(),
              );
            }
            else
              return Container(
                child: CircularProgressIndicator(),
              );
          }
        ),
      ),
    );
  }

}