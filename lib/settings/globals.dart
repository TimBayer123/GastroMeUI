library gastrome;

import 'package:gastrome/entities/Restaurant.dart';

int globalIndex = 2;
bool loggedIn = false;

int maxDistanceReloadRestaurants = 10*1000;
String keinZugriffAufStandort = "Gaststätten in deiner Nähe konnten nicht geladen werden...\nGastroMe hat keinen Zugriff auf den Standort Deines Gerätes!";
String keineRestaurantsGefunden = "Wir haben keine Restaurants in Deiner Nähe finden können...";

final String gastroMeApiUrlLocal = "http://10.0.2.2:5000";
//final String gastroMeApiUrl = "http://192.168.178.44:5000";
final String gastroMeApiUrl = 'http://GastromeApi-env.eba-gdpwc2as.us-east-2.elasticbeanstalk.com';
final String gastroMeApiAuthTokenName = 'gastrome-api-auth-token';
final String gastroMeApiAuthTokenValue = '4df6d7b9-ba79-4ae7-8a1c-cffbb657610a';

String rechnungId;
Restaurant restaurant;
String tischNr;
