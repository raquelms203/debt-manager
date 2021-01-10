import 'package:debt_manager/model/trade.dart';
import 'package:debt_manager/util/functions.dart';
import 'package:flutter/material.dart';

Card tradeCard(Trade item, {Color darkColor, bool isPaid}) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  int difference = item.deadline.difference(today).inDays;
  String complement;
  if (isPaid == null) {
    if (difference < 0)
      complement = "vencida\n${dateFormatted(item.deadline)}";
    else if (difference == 0)
      complement = "hoje\n${dateFormatted(item.deadline)}";
    else if (difference == 1)
      complement = "em $difference dia\n${dateFormatted(item.deadline)}";
    else
      complement = "em $difference dias\n${dateFormatted(item.deadline)}";
  } else {
    complement = "${dateFormatted(item.deadline)}";
  }

  return Card(
      child: ListTile(
    title: Text(
      numberToCurrency(item.value),
      style: TextStyle(
          color: item.type == 1 ? Colors.red[200] : Colors.green[200],
          fontWeight: FontWeight.bold),
    ),
    subtitle: Text(item.trader.name),
    leading: item.type == 1 ? debtAvatar(darkColor) : loanAvatar(darkColor),
    trailing: Text(complement,
        textAlign: TextAlign.center, style: TextStyle(height: 1.5)),
  ));
}

Widget loanAvatar(Color darkColor) {
  return CircleAvatar(
      backgroundColor: Colors.green[200],
      child: Icon(Icons.post_add_rounded, color: darkColor ?? Colors.white));
}

Widget debtAvatar(Color darkColor) {
  return CircleAvatar(
      backgroundColor: Colors.red[200],
      child: Icon(Icons.attach_money, color: darkColor ?? Colors.white));
}
