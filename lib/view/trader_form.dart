import 'package:debt_manager/model/trade.dart';
import 'package:debt_manager/model/trader.dart';
import 'package:debt_manager/service/trade_service.dart';
import 'package:debt_manager/view/home.dart';
import 'package:debt_manager/widgets/textfield_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class FormTrader extends StatefulWidget {
  final int type;
  final double value;
  final double interest;
  final DateTime deadline;

  FormTrader({this.deadline, this.interest, this.value, this.type});

  @override
  _FormTraderState createState() => _FormTraderState();
}

class _FormTraderState extends State<FormTrader> {
  final TradeService tradeService = TradeService();

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  final accountInfoController = TextEditingController(text: "");
  final telephoneController = MaskedTextController(mask: "(00) 00000-0000");

  Color borderColor;
  Color selectedColor;
  bool isTranfer = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadColors();

    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Cadastrar " + "${widget.type == 1 ? "Dívida" : "Empréstimo"}"),
        ),
        body: SafeArea(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Informações sobre quem vai " +
                                    "${widget.type == 1 ? "receber" : "pagar"}"),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                    controller: nameController,
                                    validator: (value) {
                                      if (value.isEmpty) return "Digite o nome";
                                      return null;
                                    },
                                    decoration: textFieldDecoration("Nome")),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: telephoneController,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite o telefone";
                                      return null;
                                    },
                                    decoration:
                                        textFieldDecoration(("Telefone"))),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite o e-mail";
                                      return null;
                                    },
                                    decoration:
                                        textFieldDecoration(("E-mail"))),
                                paymentField(),
                                SizedBox(
                                  height: 16,
                                ),
                                isTranfer
                                    ? TextFormField(
                                        controller: accountInfoController,
                                        minLines: 2,
                                        maxLines: 10,
                                        decoration: textFieldDecoration(
                                            "Dados bancários"),
                                        validator: (value) {
                                          if (value.isEmpty)
                                            return "Digite os dados bancários. Se não quiser informar, mude a forma de pagamento";
                                          return null;
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: borderColor))),
                            child: Text(
                              "Salvar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              handleSubmit();
                            }
                          })
                    ],
                  ),
                ),
        ));
  }

  Widget paymentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text("Forma de pagamento:"),
        SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isTranfer = !isTranfer;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: isTranfer ? borderColor : selectedColor)),
                child: Text(
                  "Dinheiro",
                  style:
                      TextStyle(color: isTranfer ? borderColor : selectedColor),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isTranfer = !isTranfer;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: isTranfer ? selectedColor : borderColor)),
                child: Text("Transferência",
                    style: TextStyle(
                        color: isTranfer ? selectedColor : borderColor)),
              ),
            )
          ],
        ),
      ],
    );
  }

  void loadColors() {
    Brightness theme = Theme.of(context).brightness;

    if (theme == Brightness.light) {
      borderColor = Colors.black45;
      selectedColor = Colors.green[800];
    } else {
      borderColor = Colors.white38;
      selectedColor = Colors.tealAccent[200];
    }
  }

  Future<void> handleSubmit() async {
    setState(() {
      loading = true;
    });
    Trader trader = Trader(
        email: emailController.text,
        name: nameController.text,
        paymentChoice: isTranfer ? 1 : 0,
        telephone: telephoneController.text,
        accountInfo: accountInfoController.text);

    Trade trade = Trade(
      deadline: widget.deadline,
      interest: widget.interest,
      value: widget.value,
      trader: trader,
      paid: false,
      type: widget.type,
    );

    var response;
    if (widget.type == 1)
      response = await tradeService.addDebt(trade);
    else
      response = await tradeService.addLoan(trade);

    if (response.id.isNotEmpty) {
      if (widget.type == 1)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home(page: 0,)));
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home(page: 1,)));
    }

    setState(() {
      loading = false;
    });
  }
}
