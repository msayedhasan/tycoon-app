import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../components/secodary_button.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Images.Background,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.4),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Container(),
                  // Container(),
                  Column(
                    children: <Widget>[
                      SecondaryButton(
                        title: Translate.of(context).translate('login'),
                        // 'Log in',
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        rounded: true,
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.login);
                        },
                      ),
                      const SizedBox(height: 5.0),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /// To set white line (Click to open code)
                            Container(
                              height: 1,
                              width: 60.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: Text(
                                Translate.of(context).translate('or'),
                                // "OR",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Sans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            /// To set white line (Click to open code)
                            Container(
                              color: Colors.white,
                              height: 1,
                              width: 60.0,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
