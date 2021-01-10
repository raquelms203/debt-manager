import 'package:debt_manager/service/auth_service.dart';
import 'package:debt_manager/view/debts_view.dart';
import 'package:debt_manager/view/loans_view.dart';
import 'package:debt_manager/view/paids_view.dart';
import 'package:debt_manager/view/settings.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final int page;

  Home({this.page});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService authService = AuthService();
  int indexPage = 0;
  final List<Widget> views = [
    DebtsView(),
    LoansView(),
    PaidsView(),
    Settings()
  ];

  @override
  initState() {
    if (widget.page != null)
      setState(() {
        indexPage = widget.page;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[indexPage],
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.white,
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          currentIndex: indexPage,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_rounded),
                label: "Dívidas",
                backgroundColor: Colors.grey[900]),
            BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: "Empréstimos",
                backgroundColor: Colors.grey[900]),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: "Pagos",
                backgroundColor: Colors.grey[900]),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Configuração",
                backgroundColor: Colors.grey[900]),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      indexPage = index;
    });
  }
}
