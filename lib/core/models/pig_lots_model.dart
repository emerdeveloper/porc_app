import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PigLotsModel {
  final String? id;
  final String? ownerId;
  final double? pigletPrice;
  final bool? isPaymentDone;
  final DateTime? paymentDate;
  final DateTime? weaningDate;
  final String? loteName;
  final int? males;
  final int? females;
  
  PigLotsModel({
    this.id,
    this.ownerId,
    this.pigletPrice,
    this.isPaymentDone,
    this.paymentDate,
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
      'isPaymentDone': isPaymentDone,
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
      isPaymentDone: map['isPaymentDone'] != null ? map['isPaymentDone'] as bool : null,
      weaningDate: map['weaningDate'] != null ? (map['weaningDate'] as Timestamp).toDate() : null,
      loteName: map['loteName'] != null ? map['loteName'] as String : null,
      males: map['males'] != null ? map['males'] as int : null,
      females: map['females'] != null ? map['females'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PigLotsModel.fromJson(String source) => PigLotsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PigLotsModel(id: $id, ownerId: $ownerId, pigletPrice: $pigletPrice, isPaymentDone: $isPaymentDone, weaningDate: $weaningDate, loteName: $loteName, males: $males, females: $females)';
  }
}
