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

    return data;
  }
}
