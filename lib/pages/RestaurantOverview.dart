import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gastrome/widgets/RestaurantCardWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_indicators/progress_indicators.dart';

//Autor: Tim Riebesam
//Diese Klasse stellt den Restaurant-Listen-Screen dar. Es werden alle Restaurants aus dem näheren Umkreis geladen und angezeigt.

class RestaurantOverview extends StatefulWidget {
  @override
  _RestaurantOverviewState createState() => _RestaurantOverviewState();
}

class _RestaurantOverviewState extends State<RestaurantOverview> with SingleTickerProviderStateMixin  {
  Future<List<Restaurant>> futureRestaurantsNearby;
  List<Restaurant> restaurants;

  final Geolocator geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
      distanceFilter: 10);

  Position lastSavedPosition;
  AnimationController controller;
  String dropdownValue = 'Entfernung';

  //Funktionsweise: Diese Methode ruft bei Initialisierung die Methoden zum Laden der Restaurants auf hört auf Veränderungen des Standorts des Geräts.
  @override
  void initState() {
    //Lade Rstaurants und listener für Änderungen der Geräteposition
    fetchRestaurantsAndListenOnPositionChange();
    //AnimationController wird initialisiert für HeartbeatProgressIndicator. repeat(reverse: true) damit dieser die Animation ständig wiederholt im Verlauf Vor-Zurück-Vor-Zurück-... und nicht nur Vor-Reset-Vor-Reset-...
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Restaurant-Listen-Screen zurück
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              HeadlineWidget(title: 'Restaurants', subtitle: "für dich", callWaiterButton: false),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 85,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                //DropdownButton mit den Auswahlmöglichkeiten Entfernung und Bewertung. Bei Auswahl einer Option wird die Restaurantliste neu sortiert, entsprechend der Auswahl, durch den Aufruf der Funktion sortRestaurants().
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: TextStyle(color: Colors.black),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      sortRestaurants();
                    });
                  },
                  items: <String>['Entfernung', 'Bewertung']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              // FutureBuilder beschrieben in z.B. CheckInAndLoadData.dart
              child: FutureBuilder(
                  future: futureRestaurantsNearby,
                  builder: (context, snapshot) {
                    // Wenn RestaurantDaten geladen, erstelle Liste aus diesen Daten. Ansonsten zeige Lade-Spinner oder bei Error zeige Fehlermeldung.
                    if (snapshot.hasData) {
                      restaurants = snapshot.data;
                      // Wenn Rückgabe tatsächliche Daten enthält, zeige Liste, ansonsten Zeige Meldung, dass keine Restaurants in der Nähe verfügbar sind.
                      if(restaurants.length > 0){
                        sortRestaurants();
                        return Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: restaurants.length,
                            itemBuilder: (context, index) {
                              Restaurant restaurant = restaurants[index];
                              // Zeige für jedes Restaruant ein RestaurantCardWidget in der Liste an.
                              return RestaurantCardWidget(restaurant: restaurant);
                            },
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.sentiment_dissatisfied,
                                size: 160,
                                color: Theme.of(context).accentColor,
                              ),
                              Text(
                                "In Deiner Nähe nutzt noch kein Restaurant unsere App.\n\nWir geben unser Bestes, um auch Restaurants in deiner Nähe für unsere App zu Gewinnen!",
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      // Fehlerbehandlung abhängig von Error-Meldung.
                      if (snapshot.error.toString() ==
                          'Exception: ' + keinZugriffAufStandort) {
                        return Column(
                          children: <Widget>[
                            Text(snapshot.error.toString() + "\n" +
                                'Mit einem Klick auf den Button "App-Einstellungen" kannst du diese Einstellung ändern und GastroMe die Erlaubnis erteilen, auf deinen Standort zuzugreifen.'),
                            SizedBox(height: 20),
                            RaisedButton.icon(
                                onPressed: openAppSettings,
                                icon: Icon(Icons.settings),
                                label: Text("App-Einstellungen")),
                          ],
                        );
                      }
                      else if (snapshot.error.toString() ==
                          'Exception: ' + keineRestaurantsGefundenTimeout) {
                        return Column(
                          children: <Widget>[
                            Text(snapshot.error.toString()),
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
                        Text(
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

  // Funktionsweise: Diese Methode fordert vom Benutzer den Zugriff auf den Standort. Speichert anschließend diesen Standort als letzten bekannten Standort ab und nutzt diese Positionsdaten um die Restaurants in der Nähe zu Laden über den Aufruf der Methode fetchRestaurantsNearby()
  // Weiter lauscht die Anwendung absofort auf Änderungen des Standorts und ruft die beiden Methoden updateDistanceBetweenRestaurantsAndDevice() und updateRestaurantsList() auf, sobald sich der Standort der Geräts ändert.
  // Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
  Future<void> fetchRestaurantsAndListenOnPositionChange() async {
    if (await Permission.location.request().isGranted) {
      Position currentPosition = await (Geolocator().getCurrentPosition());
      //Position currentPosition = new Position(latitude: 49, longitude: 8);
      setState(() {
        lastSavedPosition = currentPosition;
      });

      futureRestaurantsNearby = fetchRestaurantsNearby(currentPosition)
          .timeout(Duration(seconds: 15), onTimeout: (){
            throw Exception(keineRestaurantsGefundenTimeout);
          }
      );

      geolocator.getPositionStream((locationOptions)).listen((position) async {
        updateDistanceBetweenRestaurantsAndDevice(position);
        updateRestaurantsList(position);
      });

    } else {
      throw Exception(keinZugriffAufStandort);
    }
  }

  // Funktionsweise: Diese Methode sendet einen GET Request ans Backend und erhält eine Liste der Restaurants im Umkreis der übergebenen längen- und breitengrade.
  // Bei erfolgreichem Aufruf wird die Liste der Restaurants zurückgegeben und die Methode updateRestaurantDistance() für jedes Restaurant aufgerufen.
  // Rückgabewert: Die Methode liefert ein Future mit einer Liste von Restaurants zurück.
  Future<List<Restaurant>> fetchRestaurantsNearby(Position currentPosition) async {
    final response = await http.get(gastroMeApiUrl + '/restaurant/all?' +
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

      restaurants.forEach((restaurant) {
        updateRestaurantDistance(restaurant, currentPosition);
      });
      return restaurants;
    } else {
      throw Exception("Error: " + response.statusCode.toString() + "\n" + "Restaurants laden fehlgeschlagen!");
    }
  }

  // Funktionsweise: Diese Methode ruft für jedes Restaurant in der Liste des Future futureRestaurantsNearby die Methode updateRestaurantDistance() auf.
  // Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
  Future<void> updateDistanceBetweenRestaurantsAndDevice(position) async {
    futureRestaurantsNearby.then((restaurants) async {
      for(Restaurant restaurant in restaurants)
        await updateRestaurantDistance(restaurant, position);
      });
  }

  // Funktionsweise: Diese Methode erwartet die Übergabe eines Restaurants und einer Position. Die Methode errechnet die Entfernung zwischen dem Restaurant und der übergebenen Position und speichert diese Entfernung anschließend in der Variable entfernung des Restaurants.
  // Diese Methode wird verwendet um die Entfernung zwischen dem Restaurant und dem Gerät zu speichern, da es sich bei dem Übergabeparameter Position immer um den aktuellen Standort des Gerätes handelt
  // Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
  Future<void> updateRestaurantDistance(restaurant, position) async {
    double currentDistance = await Geolocator().distanceBetween(
        restaurant.standort.breitengrad,
        restaurant.standort.laengengrad,
        position.latitude,
        position.longitude);

    setState(() {
      restaurant.entfernung = currentDistance;
    });
  }

  // Funktionsweise: Diese Methode erwartet die Übergabe einer Position. Die Methode errechnet die Entfernung zwischen der Position und der letzten gespeicherten Position.
  // Ist die Entfernung der letzten bekannten Position zur übergebenen, bzw aktuellen Position (da diese Methode durch jede Veränderung der Geräteposition aufgerugen wird) größer als der definierte Maximalwert (siehe globals.dart), wird die aktuelle Position als neue gepsiechertePosition definiert.
  // Außerdem wird die Restaurantliste durch den Aufruf futureRestaurantsNearby = fetchRestaurantsNearby(currentPosition) und der Methode updateDistanceBetweenRestaurantsAndDevice(position) aktualisiert.
  // Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
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
          lastSavedPosition = currentPosition;
        });
       // Position currentPosition = new Position(latitude: 49, longitude: 8);
        setState(() {
          futureRestaurantsNearby = fetchRestaurantsNearby(currentPosition);
          updateDistanceBetweenRestaurantsAndDevice(position);
        });
      }
    }
  }

  // Funktionsweise: Diese Methode sortiert die im ListView angezeigten Restaurants, davon abhängig welche Sortierung der Benutzer ausgewählt hat.
  // Rückgabewert: Die Methode liefert ein Future ohne Rückgabewert zurück.
  void sortRestaurants(){
    if(restaurants != null && restaurants.length > 0){
      if(dropdownValue == "Entfernung")
        restaurants.sort((a, b) =>
            a.entfernung.compareTo(b.entfernung));
      else
        restaurants.sort((a, b) =>
            b.getGesamtbewertung().compareTo(a.getGesamtbewertung()));
    }
  }

}
