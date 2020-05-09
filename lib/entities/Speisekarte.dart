import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/entities/Speise.dart';

class Speisekarte{
  final int id;
  Restaurant restaurant;
  List<Speise> speisen;
  List<Getraenk> getraenke;

  Speisekarte({this.id, this.restaurant, this.speisen, this.getraenke});

}