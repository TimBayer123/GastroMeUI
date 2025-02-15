library gastrome;

import 'package:gastrome/entities/Rechnung.dart';
import 'package:gastrome/entities/Restaurant.dart';

//Autor: Tim Riebesam, Tim Bayer
//Diese Klasse stellt globale Variablen bereit

int globalIndex = 2;
bool loggedIn = false;

int maxDistanceReloadRestaurants = 10*1000;
String keinZugriffAufStandort = "Gaststätten in deiner Nähe konnten nicht geladen werden...\nGastroMe hat keinen Zugriff auf den Standort Deines Gerätes!";
String keineRestaurantsGefundenTimeout = "Die Suche nach Restaurants in Deiner Nähe dauert zu lange. Prüfe deine Internetverbindung.";

//final String gastroMeApiUrl = "http://10.0.2.2:5000"; //Local Emulator
//final String gastroMeApiUrl = "http://192.168.178.44:5000"; //Local Android Device
final String gastroMeApiUrl = 'http://GastromeApi-prod.eba-gdpwc2as.us-east-2.elasticbeanstalk.com'; //AWS

final String gastroMeApiAuthTokenName = 'gastrome-api-auth-token';
final String gastroMeApiAuthTokenValue = '4df6d7b9-ba79-4ae7-8a1c-cffbb657610a';

Restaurant restaurant;
String tischId;

final String EmailUsername = 'GastroMeWaiterTim@gmail.com';
final String EmailPassword = 'GastroMepwd';

Rechnung rechnungGlobal;
