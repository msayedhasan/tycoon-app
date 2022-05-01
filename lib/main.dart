import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import './screens/auth/login/login_screen.dart';
import './screens/main_navigation/main_navigation.dart';
import './screens/splash/splash.dart';
import './blocs/blocs.dart';
import './config/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final Routes route = Routes();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('An Error occured try again later'),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<LanguageBloc>(create: (context) => LanguageBloc()),
              BlocProvider<TradesCubit>(
                create: (context) => TradesCubit()..getTrades(),
              ),
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc()..add(CheckAuth()),
              ),
              BlocProvider<ApplicationBloc>(
                create: (context) =>
                    ApplicationBloc(LanguageBloc())..add(StartApp()),
              ),
              BlocProvider<WalletCubit>(
                create: (context) => WalletCubit()..getWallet(),
              ),
              BlocProvider<PairsCubit>(
                create: (context) => PairsCubit()..getUsdtPairs(),
              ),
            ],
            child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, lang) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: route.generateRoute,
                  navigatorKey: navigatorKey,
                  theme: ThemeData(
                    primaryColor: const Color(0xff0c425d),
                    scaffoldBackgroundColor: Colors.grey[50],
                    appBarTheme: const AppBarTheme(
                      centerTitle: true,
                      backgroundColor: Color(0xff0c425d),
                    ),
                    textTheme: const TextTheme(
                      bodyText1: TextStyle(
                        color: Colors.black87,
                      ),
                      bodyText2: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  locale: AppLanguage.defaultLanguage,
                  localizationsDelegates: const [
                    // this line is important
                    RefreshLocalizations.delegate,
                    //**// */
                    Translate.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: AppLanguage.supportLanguage,
                  localeResolutionCallback: (
                    Locale? locale,
                    Iterable<Locale> supportedLocales,
                  ) {
                    //print("change language");
                    return locale;
                  },
                  home: BlocBuilder<ApplicationBloc, ApplicationState>(
                    builder: (context, appState) {
                      if (appState is ApplicationStarted) {
                        return AnimatedSwitcher(
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          duration: const Duration(milliseconds: 500),
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, authState) {
                              if (authState is AuthFail) {
                                // return ScaffoldMessenger.of(context)
                                //     .showSnackBar(
                                //   SnackBar(
                                //     content: Text(authState.message),
                                //     backgroundColor: Colors.red,
                                //   ),
                                // );
                                print(authState.message);
                              }
                            },
                            builder: (context, authState) {
                              if (authState is Authenticated) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: MainNavigation(
                                    admin: authState.user!.admin!,
                                  ),
                                );
                              } else if (authState is AuthChecking) {
                                return const AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  child: SplashScreen(),
                                );
                              } else if (authState is UnAuthenticated) {
                                return const AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  child: LoginScreen(),
                                );
                              }
                              return const AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                child: SplashScreen(),
                              );
                            },
                          ),
                        );
                      }
                      return const AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: SplashScreen(),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
