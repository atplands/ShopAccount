import 'package:cloud_firestore/cloud_firestore.dart';

class SupTrans {
  String? supplierID;
  String? shopUID;
  String? supTransID;
  String? transName;
  String? transInfo;
  String? transType;
  Timestamp? transDate;
  Timestamp? publishedDate;
  Timestamp? transDueDate;
  Timestamp? transClosedDate;
  String? thumbnailUrl;
  String? paymentDetails;
  String? status;
  int? transAmount;

  SupTrans({
    this.supplierID,
    this.shopUID,
    this.supTransID,
    this.transName,
    this.transInfo,
    this.transType,
    this.transDate,
    this.publishedDate,
    this.transDueDate,
    this.transClosedDate,
    this.thumbnailUrl,
    this.paymentDetails,
    this.transAmount,
  });

  SupTrans.fromJson(Map<String, dynamic> json) {
    supplierID = json['supplierID'];
    shopUID = json['shopUID'];
    supTransID = json['supTransID'];
    transName = json['transName'];
    transInfo = json['transInfo'];
    transType = json['transType'];
    transDate = json['transDate'];
    publishedDate = json['publishedDate'];
    transDueDate = json['transDueDate'];
    transClosedDate = json['transClosedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    paymentDetails = json['paymentDetails'];
    status = json['status'];
    transAmount = json['transAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['supplierID'] = supplierID;
    data['shopUID'] = shopUID;
    data['supTransID'] = supTransID;
    data['transName'] = transName;
    data['transInfo'] = transInfo;
    data['transAmount'] = transAmount;
    data['transDate'] = transDate;
    data['publishedDate'] = publishedDate;
    data['transDueDate'] = transDueDate;
    data['transClosedDate'] = transClosedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['paymentDetails'] = paymentDetails;
    data['status'] = status;

    return data;
  }
}
