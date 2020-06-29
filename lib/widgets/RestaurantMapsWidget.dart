import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart';

//Autor: Tim Riebesam
//Diese Klasse stellt das RestaurantMapsWidget dar, welches in der Klasse RestaurantItemDetails.dart verwendet wird. Es beeinhaltet Informationen über den Standort des Restaurants und den Standort des Gerätes. Diese Informationen werden auf einem GoogleMapsWidget dargestellt.

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

  //Funktionsweise: Diese Methode ruft bei der Initialisierung die Methode zum Laden der Kameraposition auf.
  //Weiter wird der AnimationController initialisiert für den HeartbeatProgressIndicator. repeat(reverse: true) damit dieser die Animation ständig wiederholt im Verlauf Vor-Zurück-Vor-Zurück-... und nicht nur Vor-Reset-Vor-Reset-...
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

  //Funktionsweise: Diese Methode übergibt die Standorte des Gerätes und des Restaurants an die Methode calculateCenterPointOf(). Aus dem generierten Mittelpunkt wird eine CameraPosition zurückgegeben.
  //Rückgabewert: Die Methode liefert eine Kameraposition zurück, welcher dem Mittelpunkt zwischen Gerät- und Restaurantstandort entspricht.
  Future<CameraPosition> setCameraPosition() async {
    currentPosition = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    LatLng restaurantLatLng = LatLng(widget.restaurant.standort.breitengrad, widget.restaurant.standort.laengengrad);
    LatLng currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    return CameraPosition(
        target: calculateCenterPointOf(restaurantLatLng, currentLatLng),
        zoom: 10);
  }

  //Funktionsweise: Diese Methode errechnet den geografischen Mittelpunkt zweier Koordinaten auf Basis des Längen- und Breitengrad. Diese Formel stammt von dogbane (https://stackoverflow.com/questions/4656802/midpoint-between-two-latitude-and-longitude)
  //Rückgabewert: Die Methode liefert ein LatLng-Objekt zurück, welches dem Mittelpunkt der übergebenen LatLng-Objekte entspricht.
  //Übergabeparameter: Zwei LatLng-Objekte werden übergeben.
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

  //Funktionsweise: Diese Methode entfernt alle Marker auf dem GoogleMapWidget und aktiviert einen listener auf den Standort des Gerätes. Bei einer Änderung des Standorts wird die Methode updateMarkers aufgerufen.
  //Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
  //Übergabeparameter: Es wird ein GoogleMapController übergeben.
  Future<void> _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.clear();

      geolocator.getPositionStream((locationOptions)).listen((position) async {
        updateMarkers(position);
      });

      updateMarkers(currentPosition);
    });
  }

  //Funktionsweise: Diese Methode generiert zwei Marker , die der Variable _markers hinzugefügt werden. Bei den beiden Markern handelt es sich um einen Marker für das Restaurant und einen für die aktuelle Position des Gerätes.
  //Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
  //Übergabeparameter: Es wird ein Position-Objekt übergeben, bei diesem handelt es sich um die Position des Gerätes.
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

  //Funktionsweise: Diese Methode liefert die Oberfläche des RestaurantMapWidget
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: MediaQuery.of(context).size.width,
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
              return Positioned(
                height: 100,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              );
          }
        ),
      ),
    );
  }

}