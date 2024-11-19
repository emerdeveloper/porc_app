// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PigLotsModel {
  final String? id;
  final String? ownerId;
  final double? pigletPrice;
  final String? paymentStatus;
  final DateTime? weaningDate;
  final String? loteName;
  final int? males;
  final int? females;
  
  PigLotsModel({
    this.id,
    this.ownerId,
    this.pigletPrice,
    this.paymentStatus,
    this.weaningDate,
    this.loteName,
    this.males,
    this.females,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'pigletPrice': pigletPrice,
      'paymentStatus': paymentStatus,
      'weaningDate': weaningDate?.millisecondsSinceEpoch,
      'loteName': loteName,
      'males': males,
      'females': females,
    };
  }

  factory PigLotsModel.fromMap(Map<String, dynamic> map) {
    return PigLotsModel(
      id: map['id'] != null ? map['id'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      pigletPrice: map['pigletPrice'] != null ? (map['pigletPrice'] as num).toDouble() : null,
      paymentStatus: map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      weaningDate: map['weaningDate'] != null
    ? (map['weaningDate'] as Timestamp).toDate()
    : null,
      loteName: map['loteName'] != null ? map['loteName'] as String : null,
      males: map['males'] != null ? map['males'] as int : null,
      females: map['females'] != null ? map['females'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PigLotsModel.fromJson(String source) => PigLotsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PigLotsModel(id: $id, ownerId: $ownerId, pigletPrice: $pigletPrice, paymentStatus: $paymentStatus, weaningDate: $weaningDate, loteName: $loteName, males: $males, females: $females)';
  }
}
