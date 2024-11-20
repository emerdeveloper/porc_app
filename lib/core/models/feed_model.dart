// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeedModel {
  final String pigLotId;
  final String pigFeedName;
  final double pigFeedPrice;
  final DateTime paymentDate;
  final int numberPackages;
  final bool isPaymentDone;
  final DateTime date;
  FeedModel({
    required this.pigLotId,
    required this.pigFeedName,
    required this.pigFeedPrice,
    required this.paymentDate,
    required this.numberPackages,
    required this.isPaymentDone,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pigLotId': pigLotId,
      'pigFeedName': pigFeedName,
      'pigFeedPrice': pigFeedPrice,
      'paymentDate': paymentDate.millisecondsSinceEpoch,
      'numberPackages': numberPackages,
      'isPaymentDone': isPaymentDone,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory FeedModel.fromMap(Map<String, dynamic> map) {
    return FeedModel(
      pigLotId: map['pigLotId'] as String,
      pigFeedName: map['pigFeedName'] as String,
      pigFeedPrice: map['pigFeedPrice'] as double,
      paymentDate: DateTime.fromMillisecondsSinceEpoch(map['paymentDate'] as int),
      numberPackages: map['numberPackages'] as int,
      isPaymentDone: map['isPaymentDone'] as bool,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedModel.fromJson(String source) => FeedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FeedModel(pigLotId: $pigLotId, pigFeedName: $pigFeedName, pigFeedPrice: $pigFeedPrice, paymentDate: $paymentDate, numberPackages: $numberPackages, isPaymentDone: $isPaymentDone, date: $date)';
  }
}