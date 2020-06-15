class Bewertung{
    final String id;
    int essen;
    int atmosphaere;
    int service;
    int preise;
    int sonderwuensche;

    Bewertung({this.id, this.essen, this.atmosphaere, this.service, this.preise,
        this.sonderwuensche});

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

    Map<String, dynamic> toJson() =>
        {
             'id' : id,
             'essen' : essen,
             'atmosphaere' : atmosphaere,
             'service' : service,
             'preise' :  preise,
             'sonderwuensche' :  sonderwuensche,
        };
}