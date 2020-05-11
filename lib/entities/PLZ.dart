import 'package:gastrome/entities/Standort.dart';

class PLZ{
  final int id;
  List<Standort> standorte;
  int plz;
  String stadt;

  PLZ(this.id, this.standorte, this.plz, this.stadt);
}