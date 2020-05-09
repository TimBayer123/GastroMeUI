import 'package:gastrome/entities/Bewertung.dart';
import 'package:gastrome/entities/Restaurant.dart';

class Rezession{
    final int id;
    Restaurant restaurant;
    Bewertung bewertung;
    String anmerkung;

    Rezession({this.id, this.restaurant, this.bewertung, this.anmerkung});


}