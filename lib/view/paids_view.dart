import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debt_manager/model/trade.dart';
import 'package:debt_manager/service/trade_service.dart';
import 'package:debt_manager/widgets/trade_card.dart';
import 'package:flutter/material.dart';

class PaidsView extends StatefulWidget {
  @override
  _PaidsViewState createState() => _PaidsViewState();
}

class _PaidsViewState extends State<PaidsView> {
  final tradeService = TradeService();
  final searchController = TextEditingController();

  Color borderColor;
  Color foregroundColor;
  bool search = false;

  List<Trade> list = List<Trade>();

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;

    if (theme == Brightness.light) {
      borderColor = Colors.black;
      foregroundColor = Colors.white;
    } else {
      borderColor = Colors.white;
      foregroundColor = Colors.black;
    }

    return Scaffold(
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: tradeService.getPaids(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.size == 0) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4),
                      child: Center(
                          child: Text(
                        "Nenhum pagamento realizado",
                        style: TextStyle(fontSize: 18),
                      )),
                    );
                  } else {
                    if (!search)
                      list = snapshot.data.docs
                          .map<Trade>((item) => Trade.fromJson(item.data(), item.reference.id))
                          .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          Card(
                            child: Container(
                          margin: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Text("Pagamentos realizados",  textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )),
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 4),
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) async {
                                    List filterList = await tradeService
                                        .filterList(value, list);
                                    setState(() {
                                      if (value.isEmpty) {
                                        search = false;
                                        return;
                                      }
                                      search = true;
                                      list = filterList;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Pesquisar",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2),
                                      isDense: true),
                                ),
                              )
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Column(
                          children: list.map((item) {
                            return tradeCard(item, darkColor: foregroundColor, isPaid: true);
                          }).toList(),
                        ),
                      ],
                    );
                  }
                } else
                  return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Center(child: CircularProgressIndicator()),
                  );
              })
        ],
      ),
    );
  }

 
}
