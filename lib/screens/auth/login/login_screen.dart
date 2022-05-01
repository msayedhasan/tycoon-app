import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:http/http.dart' as http;
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../config/config.dart';
import '../../../blocs/blocs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  _loginWithFB() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final token = result.accessToken?.token;
          final graphResponse = await http.get(
            Uri.parse(
                'https://graph.facebook.com/v2.12/me?fields=name,picture.width(180).height(180),email&access_token=$token'),
          );
          final profile = json.decode(graphResponse.body);

          BlocProvider.of<AuthBloc>(context).add(OnFacebookAuth({
            'id': profile['id'],
            'name': profile['name'],
            'email': profile['email'],
            'image': profile['picture']['data']['url'],
          }));
          // // _authBloc.add(OnFacebookAuth({'access_token': token}));
          break;

        default:
          print('Failed to login with facebook using flutter facebook auth');
          break;
      }
    } catch (err) {
      print(err);
    }
  }

  _loginWithGoogle() async {
    try {
      print('_loginWithGoogle');
      await _googleSignIn.signOut();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      print(account);
      if (account != null) {
        print(account);
        BlocProvider.of<AuthBloc>(context).add(OnGoogleAuth({
          'id': account.id,
          'email': account.email,
          'name': account.displayName!,
        }));
      }
    } catch (err) {
      print(err);
    }
  }

  _loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'MotoBar',
          redirectUri: Uri.parse(
            'https://www.motobar.org',
          ),
        ),
      );

      BlocProvider.of<AuthBloc>(context).add(OnAppleAuth({
        'email': credential.email!,
        'name': credential.givenName! + ' ' + credential.familyName!,
      }));
    } catch (err) {
      print(err);
    }
  }

  Widget _buildSocialBtn(
    context,
    Function onTap,
    String logo,
    String text, {
    backgroundColor,
    Color? color,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 45.0,
          width: 320,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                logo,
                width: 45.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sign in with $text',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: color ?? Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.Splash),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.overlay),
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // FadeAnimation(
                //   0.1,
                Text(
                  Translate.of(context).translate('login'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ),
                Column(
                  children: <Widget>[
                    // FadeAnimation(
                    //   0.6,
                    Platform.isAndroid
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // _buildSocialBtn(
                              //   context,
                              //   _loginWithFB,
                              //   Images.Facebook,
                              //   'Facebook',
                              //   backgroundColor: Colors.blue,
                              //   color: Colors.white,
                              // ),
                              const SizedBox(height: 20),
                              _buildSocialBtn(
                                context,
                                _loginWithGoogle,
                                Images.Google,
                                'Google',
                                backgroundColor: Colors.grey.shade100,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // _buildSocialBtn(
                              //   context,
                              //   _loginWithFB,
                              //   Images.Facebook,
                              //   'Facebook',
                              //   backgroundColor: Colors.blue,
                              //   color: Colors.white,
                              // ),
                              const SizedBox(height: 20),
                              _buildSocialBtn(
                                context,
                                _loginWithGoogle,
                                Images.Google,
                                'Google',
                                backgroundColor: Colors.grey.shade100,
                              ),
                              const SizedBox(height: 20),
                              _buildSocialBtn(
                                context,
                                _loginWithApple,
                                Images.Apple,
                                'Apple',
                                color: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                            ],
                          ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
