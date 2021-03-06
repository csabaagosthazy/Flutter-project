import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/pages/calendar_page.dart';
import 'package:flutter_group2_tshirt_project/pages/about_page.dart';
import 'package:flutter_group2_tshirt_project/pages/main_page.dart';
import 'package:flutter_group2_tshirt_project/pages/profile_page.dart';

///
///This class represents the main frame where other pages will be shown.
///Depending on which button was clicked on the bottom navigaton bar,
///it will charge the appropriate page.
///
///
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    CalendarPage(),
    ProfilePage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Smart T-shirt App'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.deepPurple.shade300,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Calendar',
            backgroundColor: Colors.orange,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color(0xFFEB5C6D),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
