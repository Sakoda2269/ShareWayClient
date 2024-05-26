import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_page.dart';

class Home extends StatelessWidget{

  String token;
  String accountId;

  Home(this.token, this.accountId, {super.key});





  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
        screens: [HomeScreen(token, accountId),  MyPageScreen(token, accountId)],
        navBarStyle: NavBarStyle.style6,
        items: [
          PersistentBottomNavBarItem(icon: const Icon(CupertinoIcons.home), title: "Home"),
          PersistentBottomNavBarItem(icon: const Icon(CupertinoIcons.person), title: "MyPage"),
                ]
    );
  }

}

class HomeScreen extends StatefulWidget{

  String token;
  String accountId;

  HomeScreen(this.token, this.accountId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}


class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}