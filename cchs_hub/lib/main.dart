// General Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Pages
import 'pages/home_page.dart';
import 'pages/socials_page.dart';
// Hive Database
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';
// Hive Models
import 'package:cchs_hub/model/user.dart';

Future main() async {
  // Hive Initialization
  await Hive.initFlutter();
  // User
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  // Check if it's the first run or if the user has not finished setting it up
  if (Boxes.getUsers().length == 0) {
    addUser("Set name in settings");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // disable the debug banner
      debugShowCheckedModeBanner: false,
      title: 'CCHS Hub',
      theme: ThemeData(
          textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
        headline1: TextStyle(color: Colors.white),
      )),
      home: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

// MAIN DYNAMIC CLASS OF THE APP
// Bottom Navigation
int _selectedIndex = 0;

class _PageState extends State<Page> {
  @override
  void initState() {
    // General Initialization (flutter method)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // STYLE OF SYSTEM SPECIFIC THINGS
    // styles the System's navigation bar, and status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: const Color(0xFF212121),
        statusBarColor: const Color(0xFF212121)));
    // LIMIT ROTATION
    // this ensures the app can not be forced to render horizontally.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // PAGE REFERENCES
    List<Widget> _pages = <Widget>[
      // HOME
      const HomePage(),
      // PLANNER
      const HomePage(),
      // CLASSES
      const HomePage(),
      // SOCIALS
      SocialPage(),
    ];

    return Scaffold(
      // Bottom Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF212121),
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          onTap: _onNewPageSelected,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.shifting,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.house_rounded,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.event_note_rounded,
              ),
              label: 'Planner',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.format_list_bulleted_rounded,
              ),
              label: 'Classes',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF212121),
              icon: Icon(
                Icons.share,
              ),
              label: 'Socials',
            ),
          ],
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }

  //Bottom Bar Functionality
  void _onNewPageSelected(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }
}

// ADD USER (HIVE)
// this function saves the newly created user to the systems local storage with hive
// this function should only be called once per device.
Future addUser(String name) async {
  // Create User() object
  final newUser = User()..name = name;

  // Transfer object types to hive readable
  // Add new event
  // Save to local storage
  final box = Boxes.getUsers();
  box.add(newUser);
}
