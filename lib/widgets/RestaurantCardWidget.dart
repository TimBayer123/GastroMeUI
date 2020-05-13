import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantCardWidget extends StatefulWidget {
  final Restaurant item;

  const RestaurantCardWidget ({ Key key, this.item }): super(key: key);

  @override
  _RestaurantCardWidgetState createState() => _RestaurantCardWidgetState();
}

class _RestaurantCardWidgetState extends State<RestaurantCardWidget>{
  String distance = "";
  Geolocator geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
      distanceFilter: 10);

  @override
  void initState() {
    super.initState();
    getDistanceBetweenItemAndDevice(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(2.0, 0.0, 4.0, 16.0),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 100,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    bottomLeft: const Radius.circular(10.0)),
                child: Container(
                  width: 100,
                  child: Image.memory(widget.item.bild)
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    widget.item.name,
                                    style: Theme.of(context).textTheme.headline6,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      children: <Widget>[
                                        Text(widget.item.getGesamtbewertung(), style: Theme.of(context).textTheme.headline6),
                                        Icon(Icons.star_border, size: 18, color: Theme.of(context).accentColor,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Text(
                                widget.item.beschreibung.replaceAll("\n", " ").replaceAll("\r", ""),
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,),
                              SizedBox(height: 3),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    distance,
                                    style: Theme.of(context).textTheme.bodyText2,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> getDistanceBetweenItemAndDevice(Restaurant item) async {
    //TODO Optimieren und verschönern
    try {
      GeolocationStatus geolocationStatus = await geolocator.checkGeolocationPermissionStatus();
      if(geolocationStatus == GeolocationStatus.granted && item.standort != null){
        geolocator.getPositionStream((locationOptions)).listen((position) async {
          double _distance = await Geolocator().distanceBetween(item.standort.breitengrad, item.standort.laengengrad, position.latitude, position.longitude);
          setState(() {
            if(_distance > 999.99)
              this.distance = double.parse((_distance/1000).toStringAsFixed(2)).toString().replaceAll(".", ",") + " km entfernt";
            else
              this.distance = (_distance).round().toString() + " m entfernt";
          });
        });
      }
      else{
        await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        GeolocationStatus geolocationStatus = await geolocator.checkGeolocationPermissionStatus();
        if(geolocationStatus != GeolocationStatus.granted){
          //TODO Meldung: Standort aktivieren
        }
        else{
          //TODO Handle
        }
      }

    } catch (e) {
      print(e);
    }
  }

}
