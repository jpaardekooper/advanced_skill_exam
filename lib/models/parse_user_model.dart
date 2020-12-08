class DAta {
  List<Documents> documents;

  DAta({this.documents});

  DAta.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = List<Documents>();
      json['documents'].forEach((v) {
        documents.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (documents != null) {
      data['documents'] = documents.map((v) => v.toJson()).toList();
    }
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
  Email userName;
  Email role;
  Email uid;

  Fields({this.email, this.userName, this.role, this.uid});

  Fields.fromJson(Map<String, dynamic> json) {
    email = json['email'] != null ? Email.fromJson(json['email']) : null;
    userName =
        json['userName'] != null ? Email.fromJson(json['userName']) : null;
    role = json['role'] != null ? Email.fromJson(json['role']) : null;
    uid = json['uid'] != null ? Email.fromJson(json['uid']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (email != null) {
      data['email'] = email.toJson();
    }
    if (userName != null) {
      data['userName'] = userName.toJson();
    }
    if (role != null) {
      data['role'] = role.toJson();
    }
    if (uid != null) {
      data['uid'] = uid.toJson();
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
