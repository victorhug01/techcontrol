import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
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
      bottomNavigationBar: DotCurvedBottomNav(
        selectedIndex: initialPage,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorColor: AppTheme.lightTheme.colorScheme.secondary,
        items: [
          Icon(Icons.description, color: AppTheme.lightTheme.colorScheme.secondary,),
          Icon(Icons.assistant_navigation, color: AppTheme.lightTheme.colorScheme.secondary,),
          Icon(Icons.home_filled, color: AppTheme.lightTheme.colorScheme.secondary,),
          Icon(Icons.chat, color: AppTheme.lightTheme.colorScheme.secondary,),
          Icon(Icons.account_circle_outlined, color: AppTheme.lightTheme.colorScheme.secondary,),
        ],
        onTap: (page) {
          pagecontroller.animateToPage(
            page,
            duration: Duration(milliseconds: 100),
            curve: Curves.ease,
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: initialPage,
      //   backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      //   selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      //   type: BottomNavigationBarType.fixed,
      //   unselectedItemColor: AppTheme.lightTheme.primaryColor,
      //   elevation: 0,
      //   useLegacyColorScheme: true,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.description),label: 'Description',),
      //     BottomNavigationBarItem(icon: Icon(Icons.assistant_navigation),label: 'navigation'),
      //     BottomNavigationBarItem(icon: Icon(Icons.assistant_navigation), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      //     BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: 'Profile',),
      //   ],
        // onTap: (page) {
        //   pagecontroller.animateToPage(
        //     page,
        //     duration: Duration(milliseconds: 400),
        //     curve: Curves.easeIn,
        //   );
        // },
      // ),
    );
  }
}
