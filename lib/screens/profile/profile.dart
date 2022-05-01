import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../components/secodary_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../blocs/blocs.dart';
import '../../config/config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _item({text, route}) {
    return GestureDetector(
      onTap:
          route != null ? () => Navigator.of(context).pushNamed(route) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.blur_circular,
              size: 15,
              color: Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(text ?? ''),
          ],
        ),
      ),
    );
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

//** Start flutter facebook auth */
  _syncFB() async {
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

  _syncGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        BlocProvider.of<AuthBloc>(context).add(SyncGoogle({
          'id': account.id,
          'email': account.email,
          'name': account.displayName!,
        }));
      }
    } catch (err) {
      print(err);
    }
  }

  _syncApple() async {
    try {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'Tycoon',
            redirectUri: Uri.parse(
              'https://tycoon-e14e8.firebaseapp.com/__/auth/handler',
            ),
          ),
        );

        if (credential != null) {
          BlocProvider.of<AuthBloc>(context).add(SyncApple({
            'email': credential.email!,
            'name': credential.givenName! + ' ' + credential.familyName!,
          }));
        }
      } catch (err) {
        print(err);
      }
    } catch (err) {
      print(err);
    }
  }

  String apiKey = '';
  String apiSecret = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return Scaffold(
            appBar: AppBar(title: Text(authState.user!.name!)),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        authState.user!.apiKey != null
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Api key'),
                                    Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.all(15.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8),
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.white,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Api key',
                                                    hintText: 'Api key',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (String value) {
                                                    apiKey = value;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Api secret',
                                                    hintText: 'Api secret',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (String value) {
                                                    apiSecret = value;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SecondaryButton(
                                                title: 'submit',
                                                onTap: () {
                                                  BlocProvider.of<AuthBloc>(
                                                          context)
                                                      .add(
                                                    UpdateUserData(
                                                      apiKey: apiKey,
                                                      apiSecret: apiSecret,
                                                    ),
                                                  );
                                                  return Navigator.of(context)
                                                      .pop();
                                                },
                                                // rounded: true,
                                                verticalPadding: 8,
                                                borderSize: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Add Exchange',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        _item(
                          text: Translate.of(context).translate('language'),
                          // 'Language'
                          route: Routes.language,
                        ),
                        Platform.isIOS
                            ? !authState.user!.loginMethods!.contains('apple')
                                ? GestureDetector(
                                    child: _item(text: 'Sync Apple'),
                                    onTap: _syncApple,
                                  )
                                : Container()
                            : Container(),
                        !authState.user!.loginMethods!.contains('facebook')
                            ? GestureDetector(
                                child: _item(text: 'Sync facebook'),
                                onTap: _syncFB,
                              )
                            : Container(),
                        !authState.user!.loginMethods!.contains('google')
                            ? GestureDetector(
                                child: _item(text: 'Sync google'),
                                onTap: _syncGoogle,
                              )
                            : Container(),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: SecondaryButton(
                        verticalPadding: 8,
                        borderSize: 1,
                        title: Translate.of(context).translate('logout'),
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context).add(Logout());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (authState is SameScreenChecking) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    BlocProvider.of<AuthBloc>(context).add(CheckAuth()),
              ),
            ),
          );
        }
      },
    );
  }
}
