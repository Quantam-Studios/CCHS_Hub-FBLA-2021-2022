// General Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Bottom Navigation
import 'package:google_nav_bar/google_nav_bar.dart';
// Pages
import 'pages/home_page.dart';
import 'pages/socials_page.dart';
import 'pages/classes_page.dart';
import 'pages/planner_page.dart';
// Hive Database
import 'package:hive_flutter/hive_flutter.dart';
import 'helper_scripts/boxes.dart';
// Hive Models
import 'package:cchs_hub/model/user.dart';
import 'package:cchs_hub/model/class.dart';
import 'package:cchs_hub/model/event.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialization
  await Hive.initFlutter();
  // User
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  // Classes
  Hive.registerAdapter(ClassAdapter());
  await Hive.openBox<Class>('classes');
  // Events
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>('events');

  // Check if it's the first run or if the user has not finished setting it up
  if (Boxes.getUsers().length == 0) {
    addUser("Set name in settings");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // disable the debug banner
      debugShowCheckedModeBanner: false,
      title: 'CCHS Hub',
      // theme
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
        ),
        splashColor: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF353535), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          labelStyle: TextStyle(color: Colors.white),
          prefixIconColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
// active index for Bottom Navigation
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
      const PlannerPage(),
      // CLASSES
      const ClassPage(),
      // SOCIALS
      SocialPage(),
    ];

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF212121),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          // Bottom Bar
          child: GNav(
            backgroundColor: const Color(0xFF212121),
            color: Colors.grey,
            activeColor: Colors.blue,
            tabBackgroundColor: Colors.blue.shade600.withOpacity(0.3),
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            gap: 4,
            padding: const EdgeInsets.all(16),
            onTabChange: _onNewPageSelected,
            tabs: const [
              GButton(
                icon: Icons.house_rounded,
                text: "Home",
              ),
              GButton(
                icon: Icons.event_note_rounded,
                text: "Planner",
              ),
              GButton(
                icon: Icons.format_list_bulleted_rounded,
                text: "Classes",
              ),
              GButton(
                icon: Icons.share,
                text: "Socials",
              ),
            ],
          ),
        ),
      ),
      // App
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
