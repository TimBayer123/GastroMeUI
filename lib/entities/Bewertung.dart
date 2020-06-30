//Autor: Tim Bayer, Tim Riebesam
//Die Bewertung Entität ist äquivalent zur Entität in der Backend Anwendung

class Bewertung{
    final String id;
    int essen;
    int atmosphaere;
    int service;
    int preise;
    int sonderwuensche;

    Bewertung({this.id, this.essen, this.atmosphaere, this.service, this.preise,
        this.sonderwuensche});

    //Diese Methode wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
    factory Bewertung.fromJson(dynamic json){
        if(json != null)
            return Bewertung(
                id: json['id'],
                essen: json['essen'],
                atmosphaere: json['atmosphaere'],
                service: json['service'],
                preise: json['preise'],
                sonderwuensche: json['sonderwuensche']);
        return null;
    }
}