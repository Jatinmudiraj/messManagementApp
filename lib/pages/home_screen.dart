import 'package:firebase_auth/firebase_auth.dart';
import 'package:project3/pages/Profile.dart';
import 'package:project3/pages/SearchWorking.dart';
import 'package:project3/pages/Search_Page.dart';
import 'package:project3/pages/create_gig.dart';
import 'package:project3/pages/SearchWorking.dart';
import 'package:project3/pages/forget_passwor.dart';
import 'package:project3/pages/functionalPage.dart';
import 'package:project3/pages/history.dart';
import 'package:project3/pages/home.dart';
import 'package:project3/pages/login_screen.dart';
import 'package:project3/pages/signup_screen.dart';
import 'package:project3/pages/todayScreen.dart';
import 'package:project3/pages/welcome_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedindex = 0;

  static const List<Widget> _screens = <Widget>[
    Home(),
    Search(),
    Functional(),
    Profile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedindex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
        ),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.diamond_sharp),
              label: 'Home'),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.search),
              label: 'Search'),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.add_circle),
              label: 'Functional'),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.person),
              label: 'Profile'),
        ],
        currentIndex: _selectedindex,
        onTap: _onItemTapped,
      ),
    );
  }
}


// //LOG OUT Code

// Column(
//         children: [
//           Text("Hello $userName"),
//           ElevatedButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 if (!mounted) return;
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return const WelcomeScreen();
//                 }));
//               },
//               child: const Text("Sign Out")),
//         ],
//       ),