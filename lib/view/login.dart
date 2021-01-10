import 'dart:async';

import 'package:debt_manager/service/auth_service.dart';
import 'package:debt_manager/util/keys.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  StreamSubscription _subs;

  @override
  void initState() {
    _initDeepLinkListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Text(
                "Bem vindo(a) ao\nDebt Manager",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              Image.asset(
                "assets/icon.png",
                height: 130,
                width: 130,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    "Para continuar faça o login em uma das plataforma abaixo:",
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
             Container(
               padding: const EdgeInsets.all(20),
               child: FlatButton(
                  color: Colors.blue[400],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/google.png", height: 25, width: 25,),
                        SizedBox(width: 10,),
                        Text("Google", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  onPressed: () async {  
                    await googleAuth();
                  },
                ),
             ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FlatButton(
                  color: Colors.deepPurple[400],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/git.png", height: 25, width: 25,),
                        SizedBox(width: 10,),
                        Text("GitHub", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  onPressed: () async {  
                    await githubAuth();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future googleAuth() async {
    await authService.loginWithGoogle();
  }

  Future githubAuth() async {
    const String url = "https://github.com/login/oauth/authorize" +
        "?client_id=" +
        GITHUB_CLIENT_ID +
        "&scope=public_repo%20read:user%20user:email";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      ).catchError((error) {  
        print(error);
      });
    } else {  
      print("error");
    }
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      authService.loginWithGitHub(code).then((firebaseUser) {});
    }
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    super.dispose();
  }
}
