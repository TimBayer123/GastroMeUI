import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gastrome/widgets/RestaurantCardWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RestaurantOverview extends StatefulWidget {
  @override
  _RestaurantOverviewState createState() => _RestaurantOverviewState();
}

class _RestaurantOverviewState extends State<RestaurantOverview> with SingleTickerProviderStateMixin  {
  Future<List<Restaurant>> futureRestaurantsNearby;

  final Geolocator geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
      distanceFilter: 10);

  Position lastSavedPosition;

  AnimationController controller;

  @override
  void initState() {
    fetchRestaurantsAndListenOnPositionChange();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HeadlineWidget(title: 'Restaurants', subtitle: "für dich", callWaiterButton: false),
          Expanded(
            child: Container(
              child: FutureBuilder(
                  future: futureRestaurantsNearby,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Restaurant> restaurants = snapshot.data;
                      restaurants.sort((a, b) =>
                          a.entfernung.compareTo(b.entfernung));
                      return Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            Restaurant restaurant = restaurants[index];
                            return RestaurantCardWidget(restaurant: restaurant);
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      if (snapshot.error.toString() ==
                          'Exception: ' + keinZugriffAufStandort) {
                        return Column(
                          children: <Widget>[
                            Text(snapshot.error.toString() + "\n" +
                                'Mit einem Klick auf den Button "App-Einstellungen" kannst du diese Einstellung ändern und GastroMe die Erlaubnis erteilen, auf deinen Standort zuzugreifenn.'),
                            SizedBox(height: 20),
                            RaisedButton.icon(
                                onPressed: openAppSettings,
                                icon: Icon(Icons.settings),
                                label: Text("App-Einstellungen")),

                          ],
                        );
                      }
                    }
                    // By default, show a loading spinner.
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeartbeatProgressIndicator(
                          child: AnimatedIcon(
                            icon: AnimatedIcons.search_ellipsis,
                            progress: controller,
                            color: Theme.of(context).accentColor,
                            size: 40,
                          ),
                          duration: new Duration(seconds: 1),
                        ),
                        SizedBox(height: 40),
                        FadingText(
                          'Wir suchen Gasstätten in deiner Nähe...',
                          style: Theme.of(context).textTheme.headline4,)
                      ],
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> fetchRestaurantsAndListenOnPositionChange() async {
    if (await Permission.location.request().isGranted) {
    Position currentPosition = await (Geolocator().getCurrentPosition());
    setState(() {
    lastSavedPosition = currentPosition;
    });

    futureRestaurantsNearby = fetchRestaurantsNearby(currentPosition);

    geolocator.getPositionStream((locationOptions)).listen((position) async {
      updateDistanceBetweenRestaurantsAndDevice(position);
      updateRestaurantsList(position);
    });

    } else {
    throw Exception(keinZugriffAufStandort);
    }
  }

  Future<List<Restaurant>> fetchRestaurantsNearby(Position currentPosition) async {
    final response = await http.get(gastroMeApiUrlLocal + '/restaurant/all?' +
        'lat=' + currentPosition.latitude.toString() +
        "&lng=" + currentPosition.longitude.toString(),
        headers: {
          gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue
        });

    if(response.statusCode == 200){
      List<Restaurant> restaurants = new List();
      List<dynamic> restaurantsJSON = json.decode(utf8.decode(response.bodyBytes));

      restaurantsJSON.forEach((restaurantJson) async {
        restaurants.add(Restaurant.fromJson(restaurantJson));
      });

      return restaurants;
    } else {
      throw Exception("Error: " + response.statusCode.toString() + "\n" + "Restaurants laden fehlgeschlagen!");
    }
  }

  Future<void> updateDistanceBetweenRestaurantsAndDevice(position) async {
    futureRestaurantsNearby.then((restaurants) async {
      for(Restaurant restaurant in restaurants)
        await updateRestaurantDistance(restaurant, position);
      });
  }


  Future<bool> updateRestaurantDistance(restaurant, position) async {
    double currentDistance = await Geolocator().distanceBetween(
        restaurant.standort.breitengrad,
        restaurant.standort.laengengrad,
        position.latitude,
        position.longitude);

    setState(() {
      restaurant.entfernung = currentDistance;
    });
    return true;
  }

  Future<void>updateRestaurantsList(position) async {
    if(lastSavedPosition != null){
      double currentDistanceToLastSavedLocation = await Geolocator().distanceBetween(
          lastSavedPosition.latitude,
          lastSavedPosition.longitude,
          position.latitude,
          position.longitude);
      if(currentDistanceToLastSavedLocation > maxDistanceReloadRestaurants){
        Position currentPosition = await (Geolocator().getCurrentPosition());
        setState(() {
          futureRestaurantsNearby = fetchRestaurantsNearby(currentPosition);
          updateDistanceBetweenRestaurantsAndDevice(position);
        });
      }
    }
  }

}
