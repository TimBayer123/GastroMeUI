import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gastrome/widgets/RestaurantCardWidget.dart';

class RestaurantOverview extends StatefulWidget {
  @override
  _RestaurantOverviewState createState() => _RestaurantOverviewState();
}

class _RestaurantOverviewState extends State<RestaurantOverview> {
  Future<List<Restaurant>> futureRestaurantsNearby;

  Geolocator geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
      distanceFilter: 10);

  @override
  void initState() {
    futureRestaurantsNearby = fetchRestaurantsNearby();
    getDistanceBetweenRestaurantsAndDevice();
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
                      return Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            Restaurant restaurant = restaurants[index];
                            return RestaurantCardWidget(item: restaurant);
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<List<Restaurant>> fetchRestaurantsNearby() async {
    //Position position = await (Geolocator().getCurrentPosition());
    Position position = Position(latitude: 49, longitude: 8);
    GeolocationStatus geolocationStatus = await geolocator.checkGeolocationPermissionStatus();
    if(geolocationStatus == GeolocationStatus.granted) {
        final response =
        await http.get(gastroMeApiUrl + '/restaurant/all?lat='+
            position.latitude.toString() + "&lng=" +
            position.longitude.toString(),
            headers: {
              gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue
            });

        if (response.statusCode == 200) {
          List<Restaurant> restaurants = new List();
          List<dynamic> restaurantsJSON = json.decode(
              utf8.decode(response.bodyBytes));
              restaurantsJSON.forEach((restaurantJson) async {
              restaurants.add(Restaurant.fromJson(restaurantJson));
          });

          return restaurants;
        } else {
          throw Exception('Restaurants laden fehlgeschlagen');
        }
    }
    else
      //TODO Handle no Permission
      print("error");
  }

  Future<void> getDistanceBetweenRestaurantsAndDevice() async {
    try {
        geolocator.getPositionStream((locationOptions)).listen((position) async {
          futureRestaurantsNearby.then((restaurants) {
            restaurants.forEach((restaurant) async {
              double entfernung = await Geolocator().distanceBetween(restaurant.standort.breitengrad, restaurant.standort.laengengrad, position.latitude, position.longitude);
              setState(() {
                restaurant.entfernung = entfernung;
              });
            });
          });
        });
    } catch (e) {
      print(e);
    }
  }

}
