class ParseMarker {
  List<Documents> documents;
  String nextPageToken;

  ParseMarker({this.documents, this.nextPageToken});

  ParseMarker.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = List<Documents>();
      json['documents'].forEach((v) {
        documents.add(Documents.fromJson(v));
      });
    }
    nextPageToken = json['nextPageToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (documents != null) {
      data['documents'] = documents.map((v) => v.toJson()).toList();
    }
    data['nextPageToken'] = nextPageToken;
    return data;
  }
}

class Documents {
  String name;
  Fields fields;
  String createTime;
  String updateTime;

  Documents({this.name, this.fields, this.createTime, this.updateTime});

  Documents.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fields = json['fields'] != null ? Fields.fromJson(json['fields']) : null;
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    if (fields != null) {
      data['fields'] = fields.toJson();
    }
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    return data;
  }
}

class Fields {
  Email email;
  Email name;
  Email url;
  Email info;
  Email company;
  IsClosed isClosed;
  Location location;
  Lat lat;
  Lat long;
  Email code;

  Fields(
      // ignore: lines_longer_than_80_chars
      {this.email,
      this.name,
      this.url,
      this.info,
      this.company,
      this.isClosed,
      this.location,
      this.lat,
      this.long,
      this.code});

  Fields.fromJson(Map<String, dynamic> json) {
    email = json['email'] != null ? Email.fromJson(json['email']) : null;
    name = json['name'] != null ? Email.fromJson(json['name']) : null;
    url = json['url'] != null ? Email.fromJson(json['url']) : null;
    info = json['info'] != null ? Email.fromJson(json['info']) : null;
    company = json['company'] != null ? Email.fromJson(json['company']) : null;
    isClosed =
        json['isClosed'] != null ? IsClosed.fromJson(json['isClosed']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    lat = json['lat'] != null ? Lat.fromJson(json['lat']) : null;
    long = json['long'] != null ? Lat.fromJson(json['long']) : null;
    code = json['code'] != null ? Email.fromJson(json['code']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (email != null) {
      data['email'] = email.toJson();
    }
    if (name != null) {
      data['name'] = name.toJson();
    }
    if (url != null) {
      data['url'] = url.toJson();
    }
    if (info != null) {
      data['info'] = info.toJson();
    }
    if (company != null) {
      data['company'] = company.toJson();
    }
    if (isClosed != null) {
      data['isClosed'] = isClosed.toJson();
    }
    if (location != null) {
      data['location'] = location.toJson();
    }
    if (lat != null) {
      data['lat'] = lat.toJson();
    }
    if (long != null) {
      data['long'] = long.toJson();
    }
    if (code != null) {
      data['code'] = code.toJson();
    }
    return data;
  }
}

class Email {
  String stringValue;

  Email({this.stringValue});

  Email.fromJson(Map<String, dynamic> json) {
    stringValue = json['stringValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['stringValue'] = stringValue;
    return data;
  }
}

class IsClosed {
  bool booleanValue;

  IsClosed({this.booleanValue});

  IsClosed.fromJson(Map<String, dynamic> json) {
    booleanValue = json['booleanValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['booleanValue'] = booleanValue;
    return data;
  }
}

class Location {
  GeoPointValue geoPointValue;

  Location({this.geoPointValue});

  Location.fromJson(Map<String, dynamic> json) {
    geoPointValue = json['geoPointValue'] != null
        ? GeoPointValue.fromJson(json['geoPointValue'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (geoPointValue != null) {
      data['geoPointValue'] = geoPointValue.toJson();
    }
    return data;
  }
}

class GeoPointValue {
  double latitude;
  double longitude;

  GeoPointValue({this.latitude, this.longitude});

  GeoPointValue.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Lat {
  double doubleValue;

  Lat({this.doubleValue});

  Lat.fromJson(Map<String, dynamic> json) {
    doubleValue = json['doubleValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['doubleValue'] = doubleValue;
    return data;
  }
}
