import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debt_manager/model/trade.dart';
import 'package:debt_manager/util/functions.dart';

class TradeService {
  final CollectionReference loans =
      FirebaseFirestore.instance.collection('loans');

  final CollectionReference debts =
      FirebaseFirestore.instance.collection('debts');

  final CollectionReference paids =
      FirebaseFirestore.instance.collection('paids');

  Stream<QuerySnapshot> getLoans() {
    return loans.orderBy("deadline").snapshots();
  }

  Stream<QuerySnapshot> getDebts() {
    return debts.orderBy("deadline").snapshots();
  }

  Stream<QuerySnapshot> getPaids() {
    return paids.orderBy("deadline").snapshots();
  }

  Future<DocumentReference> addLoan(Trade trade) async {
    return loans.add(tradeToJson(trade));
  }

  Future<DocumentReference> addDebt(Trade trade) async {
    return debts.add(tradeToJson(trade));
  }

  Future<DocumentReference> addPaidFromDebt(Trade trade) async {
    debts.doc(trade.reference).delete();
    return paids.add(tradeToJson(trade));
  }

  Future<DocumentReference> addPaidFromLoan(Trade trade) async {
    loans.doc(trade.reference).delete();
    return paids.add(tradeToJson(trade));
  }

  Future removeDebt(String reference) {
    return debts.doc(reference).delete();
  }

  Future removeLoan(String reference) {
    return loans.doc(reference).delete();
  }

  Future<List<Trade>> filterList(String filter, List list) async {
    return list
        .where((item) =>
            item.trader.name.toLowerCase().startsWith(filter.toLowerCase()) ||
            item.value.toString().startsWith(filter))
        .toList();
  }

  String sumBalance(List<Trade> list) {
    double sum = 0.0;
    for (int i = 0; i < list.length; i++) sum = sum + list[i].value;
    return numberToCurrency(sum);
  }
}
