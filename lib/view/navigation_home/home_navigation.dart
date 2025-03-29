import 'package:flutter/material.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/view/chat/chat_page.dart';
import 'package:techcontrol/view/home/home_page.dart';
import 'package:techcontrol/view/map/maps_page.dart';
import 'package:techcontrol/view/profile/profile_page.dart';
import 'package:techcontrol/view/work/work_page.dart';

class NavigationHomeScreens extends StatefulWidget {
  const NavigationHomeScreens({super.key});

  @override
  State<NavigationHomeScreens> createState() => _NavigationHomeScreensState();
}

class _NavigationHomeScreensState extends State<NavigationHomeScreens> {
  int initialPage = 2;
  late PageController pagecontroller;

  @override
  void initState() {
    super.initState();
    pagecontroller = PageController(initialPage: initialPage);
  }

  setActualPage(page) {
    setState(() {
      initialPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: initialPage == 1 ? NeverScrollableScrollPhysics() : ScrollPhysics(),
        controller: pagecontroller,
        onPageChanged: setActualPage,
        children: [
          WorkPage(),
          MapsPage(),
          HomePage(),
          ChatPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: initialPage,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppTheme.lightTheme.primaryColor,
        elevation: 0,
        useLegacyColorScheme: true,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.description),label: 'Description',),
          BottomNavigationBarItem(icon: Icon(Icons.assistant_navigation),label: 'navigation'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: 'Profile',),
        ],
        onTap: (page) {
          pagecontroller.animateToPage(
            page,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }
}
