import 'package:debt_manager/util/functions.dart';
import 'package:debt_manager/view/trader_form.dart';
import 'package:debt_manager/widgets/textfield_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class FormTrade extends StatefulWidget {
  final int type;

  FormTrade(this.type);

  @override
  _FormTradeState createState() => _FormTradeState();
}

class _FormTradeState extends State<FormTrade> {
  final _formKey = GlobalKey<FormState>();

  final valueController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$ ');

  final interestController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: '',
    rightSymbol: ' %',
  );

  Color borderColor;
  DateTime dateSelected;
  String textDate = "Data de vencimento";
  bool errorDate = false;

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;

    if (theme == Brightness.light)
      borderColor = Colors.black45;
    else
      borderColor = Colors.white38;

    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar " + "${widget.type == 1 ? "Dívida" : "Empréstimo"}"),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            controller: valueController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == "R\$ 0,00") return "Digite um valor";
                              return null;
                            },
                            decoration:
                                textFieldDecoration("Valor", hintText: "R\$")),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            controller: interestController,
                            keyboardType: TextInputType.number,
                            decoration:
                                textFieldDecoration("Juros", hintText: "%")),
                        SizedBox(
                          height: 16,
                        ),
                        deadlineField()
                      ],
                    ),
                  ),
                ),
                InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: borderColor))),
                      child: Text(
                        "Continuar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: handleSubmit)
              ],
            ),
          ),
        ));
  }

  Widget deadlineField() {
    return Column(
      children: [
        SizedBox(
            height: 40.0,
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 23.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.0),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textDate,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                openDatePicker();
              },
              shape: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: errorDate ? Colors.red[700] : borderColor)),
            )),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            errorDate ? "Selecione uma data" : "",
            style: TextStyle(color: Colors.red[700], fontSize: 12),
          ),
        )
      ],
    );
  }

  Future<Null> openDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2024),
        builder: (BuildContext context, Widget child) {
          return Center(
            child: SingleChildScrollView(
                child: Theme(
                    child: child,
                    data: ThemeData.light().copyWith(
                      primaryColor: Colors.grey[900],
                      colorScheme: ColorScheme.light(primary: Colors.grey[900]),
                      buttonTheme:
                          ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      accentColor: Color(0xffF5891F),
                    ))),
          );
        });
    if (date != null) {
      setState(() {
        dateSelected = date;
        textDate = dateFormatted(date);
      });
    }
  }

  void goToFormTrader() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormTrader(
                  deadline: dateSelected,
                  value: currencyToNumber(valueController.text),
                  interest: percentageToNumber(interestController.text),
                  type: widget.type,
                )));
  }

  void handleSubmit() {
    if (dateSelected == null) {
      setState(() {
        errorDate = true;
      });
    } else {
      setState(() {
        errorDate = false;
      });
    }
    if (_formKey.currentState.validate()) {
      goToFormTrader();
    }
  }
}
