import 'dart:convert';
import 'package:debt_manager/model/auth_github.dart';
import 'package:debt_manager/util/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> loginWithGitHub(String code) async {
    final response = await http.post(
      "https://github.com/login/oauth/access_token",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(GitHubLoginRequest(
        clientId: GITHUB_CLIENT_ID,
        clientSecret: GITHUB_CLIENT_SECRET,
        code: code,
      )),
    );
    GitHubLoginResponse loginResponse =
        GitHubLoginResponse.fromJson(json.decode(response.body));
    final AuthCredential credential =
        GithubAuthProvider.credential(loginResponse.accessToken);

    final User user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    return user;
  }

  Future<User> loginWithGoogle() async {
    User user;

    final googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    user = (await _firebaseAuth.signInWithCredential(credential)).user;

    return user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
