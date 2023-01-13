import 'package:cloud_firestore/cloud_firestore.dart';

class CashBook {
  String? cashBookID;
  String? shopUID;
  String? cashBookInfo;
  int? cashInAmount;
  int? cashOutAmount;
  int? onlineInAmount;
  int? onlineOutAmount;
  Timestamp? publishedDate;
  String? status;

  CashBook({
    this.cashBookID,
    this.shopUID,
    this.cashBookInfo,
    this.cashInAmount,
    this.cashOutAmount,
    this.onlineInAmount,
    this.onlineOutAmount,
    this.publishedDate,
    this.status,
  });

  CashBook.fromJson(Map<String, dynamic> json) {
    cashBookID = json["cashBookID"];
    shopUID = json['shopUID'];
    cashBookInfo = json['cashBookInfo'];
    cashInAmount = json["cashInAmount"];
    cashOutAmount = json["cashOutAmount"];
    onlineInAmount = json["onlineInAmount"];
    onlineOutAmount = json["onlineOutAmount"];
    publishedDate = json['publishedDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["cashBookID"] = cashBookID;
    data['sellerUID'] = shopUID;
    data['cashBookInfo'] = cashBookInfo;
    data['cashInAmount'] = cashInAmount;
    data['cashOutAmount'] = cashOutAmount;
    data['onlineInAmount'] = onlineInAmount;
    data['onlineOutAmount'] = onlineOutAmount;
    data['publishedDate'] = publishedDate;
    data['status'] = status;

    return data;
  }
}
