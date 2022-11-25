import 'package:cloud_firestore/cloud_firestore.dart';

class CustTrans {
  String? custID;
  String? shopUID;
  String? custTransID;
  String? transName;
  String? transType;
  String? transInfo;
  Timestamp? transDate;
  Timestamp? publishedDate;
  Timestamp? dueDate;
  Timestamp? closedDate;
  String? thumbnailUrl;
  String? paymentDetails;
  String? status;
  int? transAmount;

  CustTrans({
    this.custID,
    this.shopUID,
    this.custTransID,
    this.transName,
    this.transType,
    this.transInfo,
    this.transDate,
    this.publishedDate,
    this.dueDate,
    this.closedDate,
    this.thumbnailUrl,
    this.paymentDetails,
    this.status,
    this.transAmount,
  });

  CustTrans.fromJson(Map<String, dynamic> json) {
    custID = json['custID'];
    shopUID = json['shopUID'];
    custTransID = json['custTransID'];
    transName = json['transName'];
    transType = json['transType'];
    transInfo = json['transInfo'];
    transDate = json['transDate'];
    publishedDate = json['publishedDate'];
    dueDate = json['dueDate'];
    closedDate = json['closedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    paymentDetails = json['paymentDetails'];
    status = json['status'];
    transAmount = json['transAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['custID'] = custID;
    data['shopUID'] = shopUID;
    data['custTransID'] = custTransID;
    data['transName'] = transName;
    data['transType'] = transType;
    data['transInfo'] = transInfo;
    data['transAmount'] = transAmount;
    data['closedDate'] = closedDate;
    data['transDate'] = transDate;
    data['publishedDate'] = publishedDate;
    data['dueDate'] = dueDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['paymentDetails'] = paymentDetails;
    data['status'] = status;

    return data;
  }
}
