import 'package:app_project/pages/post_create_page.dart';
import 'package:app_project/pages/prediction_page.dart';
import 'package:app_project/pages/user_info_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.orange, // More prominent indicator color
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NavigationDestination(
              selectedIcon: Icon(Icons.search),
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NavigationDestination(
              selectedIcon: Icon(Icons.create), // More visually appealing icon
              icon: Icon(Icons.create_outlined),
              label: 'Post',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NavigationDestination(
              icon: Badge(child: Icon(Icons.notifications_sharp)),
              label: 'Predict',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: NavigationDestination(
              selectedIcon: Icon(Icons.info),
              icon: Icon(Icons.info_outlined),
              label: 'Info',
            ),
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Home(),

        /// Notifications page
        SearchPage(),

        /// Post page
        PostScreen(),

        /// Prediction page
        SymptomPage(),

        /// User Info page
        UserInfoPage()
      ][currentPageIndex],
    );
  }
}
