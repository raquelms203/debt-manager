import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debt_manager/model/trader.dart';
import 'package:flutter/material.dart';

class Trade {
  Trader trader;
  DateTime deadline;
  double interest;
  double value;
  bool paid;
  int type;
  String reference;

  Trade(
      {@required this.interest,
      @required this.trader,
      @required this.paid,
      @required this.type,
      @required this.deadline,
      @required this.value,
      this.reference});

  factory Trade.fromJson(Map<dynamic, dynamic> json, String reference) {
    return Trade(
        deadline: (json['deadline'] as Timestamp).toDate(),
        paid: json['paid'] as bool,
        interest: json['interest'] as double,
        value: json['value'] as double,
        trader: Trader.fromJson(json['trader']),
        type: json['type'] as int,
        reference: reference
      );
  }
}

Map<String, dynamic> tradeToJson(Trade trade) => <String, dynamic>{
      'deadline': trade.deadline,
      'paid': trade.paid,
      'interest': trade.interest,
      'value': trade.value,
      'trader': traderToJson(trade.trader),
      'type': trade.type
    };
