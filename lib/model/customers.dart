import 'package:cloud_firestore/cloud_firestore.dart';

class Customers {
  String? custID;
  String? shopUID;
  String? custName;
  String? custInfo;
  String? custContact;
  String? custAddress;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;
  int? transTotal;
  int? cashTotal;
  int? creditTotal;

  Customers({
    this.custID,
    this.shopUID,
    this.custName,
    this.custInfo,
    this.custContact,
    this.custAddress,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
    this.transTotal,
    this.cashTotal,
    this.creditTotal,
  });

  Customers.fromJson(Map<String, dynamic> json) {
    custID = json["custID"];
    shopUID = json['shopUID'];
    custName = json['custName'];
    custInfo = json['custInfo'];
    custContact = json['custContact'];
    custAddress = json["custAddress"];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
    transTotal = json['transTotal'];
    cashTotal = json['cashTotal'];
    creditTotal = json['creditTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["custID"] = custID;
    data['sellerUID'] = shopUID;
    data['custName'] = custName;
    data['custName'] = custInfo;
    data['custContact'] = custContact;
    data['custAddress'] = custAddress;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;
    data['transTotal'] = transTotal;
    data['cashTotal'] = cashTotal;
    data['creditTotal'] = creditTotal;

    return data;
  }
}
