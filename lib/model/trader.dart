import 'package:flutter/material.dart';

class Trader {
  String name;
  String email;
  String telephone;
  int paymentChoice;
  String accountInfo;

  Trader({
    @required this.name,
    @required this.email,
    @required this.telephone,
    @required this.paymentChoice,
    this.accountInfo,
  });

  factory Trader.fromJson(Map<dynamic, dynamic> json) => Trader(
        name: json['name'] as String,
        email: json['email'] as String,
        telephone: json['telephone'] as String,
        paymentChoice: json['payment_choice'] as int,
        accountInfo: json['description'],
      );
}

Map<String, dynamic> traderToJson(Trader trader) => <String, dynamic>{
      'description': trader.accountInfo,
      'payment_choice': trader.paymentChoice,
      'telephone': trader.telephone,
      'email': trader.email,
      'name': trader.name,
    };
