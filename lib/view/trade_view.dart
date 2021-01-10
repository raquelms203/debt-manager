import 'package:debt_manager/model/trade.dart';
import 'package:debt_manager/service/trade_service.dart';
import 'package:debt_manager/util/functions.dart';
import 'package:debt_manager/view/home.dart';
import 'package:flutter/material.dart';

class TradeView extends StatefulWidget {
  final Trade trade;

  TradeView(this.trade);

  @override
  _TradeViewState createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  final TradeService tradeService = TradeService();
  Color buttonColor;
  Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;

    if (theme == Brightness.light) {
      buttonColor = Colors.green[800];
      foregroundColor = Colors.white;
    } else {
      buttonColor = Colors.cyanAccent[200];
      foregroundColor = Colors.black;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trade.type == 1 ? "Dívida" : "Empréstimo"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: handleDelete)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Valor: " + numberToCurrency(widget.trade.value)),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Juros: " + widget.trade.interest.toString() + " %"),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Status: " +
                          "${widget.trade.paid ? "Pago" : "Em aberto"}"),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Data de vencimento: " +
                          dateFormatted(widget.trade.deadline)),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("${widget.trade.type == 1 ? "Para: " : "De: "}" +
                          (widget.trade.trader.name)),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Telefone: " + widget.trade.trader.telephone),
                      SizedBox(
                        height: 6,
                      ),
                      Text("E-mail: " + widget.trade.trader.email),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Card(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Forma de pagamento: " +
                          (widget.trade.trader.paymentChoice == 0
                              ? "Dinheiro"
                              : "Transferência")),
                      SizedBox(
                        height: 8,
                      ),
                      widget.trade.trader.paymentChoice == 1
                          ? Container(
                              child: Text("\nDados bancários:\n" +
                                  widget.trade.trader.accountInfo),
                              width: double.infinity,
                              alignment: Alignment.center,
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlatButton(
                  color: buttonColor,
                  textColor: foregroundColor,
                  child: Text(
                    "Pagar",
                  ),
                  onPressed: () async {
                    if (widget.trade.type == 1)
                      tradeService.addPaidFromDebt(widget.trade);
                    else
                      tradeService.addPaidFromLoan(widget.trade);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home(page: 2)));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleDelete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Deseja excluir ${widget.trade.type == 1 ? "essa dívida" : "esse empréstimo"}?"),
            actions: [
              FlatButton(
                child: Text(
                  "Não",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              InkWell(
                child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey[700])),
                    child: Text(
                      "Sim",
                    )),
                onTap: () {
                  if(widget.trade.type == 1) {  
                    tradeService.removeDebt(widget.trade.reference);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(page: 0,)));
                  } else {  
                    tradeService.removeLoan(widget.trade.reference);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(page: 1,)));
                  }
                },
              )
            ],
          );
        });
  }
}
