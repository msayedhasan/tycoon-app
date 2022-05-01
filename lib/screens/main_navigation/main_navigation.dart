import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../config/notifications/firebase_notification.dart';
import '../../config/notifications/local_notification.dart';

import '../../screens/screens.dart';
import '../../sockets/init.socket.dart';

class MainNavigation extends StatefulWidget {
  final bool admin;
  const MainNavigation({Key? key, required this.admin}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late List<Widget> _children;
  @override
  void initState() {
    InitSocketIO.initSocket();
    FirebaseNotification.showNotification(context);
    LocalNotification.initialize();
    widget.admin == true
        ? _children = [
            const OrderScreen(),
            // HomeScreen(),
            const DashboardScreen(),
            const BotScreen(),
            const ProfileScreen(),
          ]
        : _children = [
            const DashboardScreen(),
            const BotScreen(),
            const ProfileScreen(),
          ];
    super.initState();
  }

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            List<BottomNavigationBarItem> _items;
            authState.user!.admin == true
                ? _items = const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.timeline),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.computer),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: '',
                    ),
                  ]
                : _items = const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.computer),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: '',
                    ),
                  ];
            return BottomNavigationBar(
              selectedIconTheme: const IconThemeData(size: 28),
              selectedFontSize: 0,
              unselectedFontSize: 0,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.black45,
              onTap: onTabTapped, // new
              currentIndex: _currentIndex, // new
              type: BottomNavigationBarType.fixed,
              items: _items,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
