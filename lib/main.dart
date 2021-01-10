import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:debt_manager/view/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.grey[900]));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[900],
        cursorColor: Colors.grey[900],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green[800],
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      dark: ThemeData(
          brightness: Brightness.dark,
          cursorColor: Colors.tealAccent[200],
          appBarTheme: AppBarTheme(color: Colors.grey[900]),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.tealAccent[200],
          )),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Debt Launcher',
        theme: theme,
        darkTheme: darkTheme,
        home: Root(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt', 'BR'),
        ],
      ),
    );
  }
}
