import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gastrome/widgets/RestaurantCardWidget.dart';
import 'package:gastrome/settings/globals.dart';

class RestaurantOverview extends StatefulWidget {
  @override
  _RestaurantOverviewState createState() => _RestaurantOverviewState();
}

class _RestaurantOverviewState extends State<RestaurantOverview> {
  Future<List<Restaurant>> futureRestaurantsNearby;
  @override
  void initState() {
    futureRestaurantsNearby = fetchRestaurantsNearby();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HeadlineWidget(title: 'Restaurants', subtitle: "für dich", callWaiterButton: false),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                              //return new Text(restaurant.name);
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
            ),
          )
        ],
      ),
    );
  }

  Future<List<Restaurant>> fetchRestaurantsNearby() async {
    final response =
    await http.get(gastroMeApiUrl + '/restaurant/all',
        headers: {
          gastroMeApiAuthTokenName : gastroMeApiAuthTokenValue
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Restaurant> restaurants = new List();

      List<dynamic> restaurantsJSON = json.decode(utf8.decode(response.bodyBytes));
      restaurantsJSON.forEach((restaurant) {
        restaurants.add(Restaurant.fromJson(restaurant));
      });

      return restaurants;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Restaurants laden fehlgeschlagen');
    }

  }

}
