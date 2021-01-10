import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:debt_manager/service/auth_service.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkTheme;
  Color buttonColor;
  Color borderColor;
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;

    if (theme == Brightness.light) {
      isDarkTheme = false;
      buttonColor = Colors.green[800];
      borderColor = Colors.black45;
    } else {
      isDarkTheme = true;
      buttonColor = Colors.cyanAccent[200];
      borderColor = Colors.white38;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                  child: Container(
                margin: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Text(
                      "Configurações",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Tema: "),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: outlinedButton(
                            isSelected: !isDarkTheme,
                            selectedColor: buttonColor,
                            unselectedColor: borderColor,
                            label: "Claro"),
                        onTap: () {
                          if (isDarkTheme) {
                            AdaptiveTheme.of(context).setLight();
                          }
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: outlinedButton(
                            isSelected: isDarkTheme,
                            selectedColor: buttonColor,
                            unselectedColor: borderColor,
                            label: "Escuro"),
                        onTap: () {
                          if (!isDarkTheme) {
                            AdaptiveTheme.of(context).setDark();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: outlinedButton(
                                isSelected: true,
                                selectedColor: buttonColor,
                                unselectedColor: borderColor,
                                label: "Sair do aplicativo"),
                          ),
                          onTap: handleLogout),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget outlinedButton(
      {Color selectedColor,
      Color unselectedColor,
      bool isSelected,
      String label}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border:
              Border.all(color: isSelected ? selectedColor : unselectedColor)),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: isSelected ? selectedColor : unselectedColor),
      ),
    );
  }

  void handleLogout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Deseja sair?"),
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
                  Navigator.pop(context);
                  authService.logout();
                },
              )
            ],
          );
        });
  }
}
