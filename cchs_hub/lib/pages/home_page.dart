// General Packages
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cchs_hub/pages/classes_page.dart';
// Popups
import 'package:rflutter_alert/rflutter_alert.dart';
// Time Management
import 'package:cchs_hub/helper_scripts/time_management.dart';
// Network Interfacing
import 'dart:io';
// Models
import 'package:cchs_hub/model/user.dart';
import 'package:cchs_hub/model/class.dart';
// Hive DataBase
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cchs_hub/helper_scripts/boxes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageContent createState() => HomePageContent();
}

// Get user's User() class
User userInfo = Boxes.getUsers().getAt(0)!;

class HomePageContent extends State {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    updateActiveClass();
    super.initState();
  }

  @override
  void dispose() {
    // Get rid of boxes needed for this page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: _optionsMenu(context, userInfo),
        backgroundColor: const Color(0xFF222222),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color(0xFF5C9BED),
              Colors.blue.shade600,
              Colors.blue.shade600,
            ],
          )),
          child: Column(
            children: [
              _topSection(scaffoldKey, context),
              // main section
              _mainSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// TOP SECTION
_topSection(GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // OPTIONS MENU BUTTON
        IconButton(
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
          icon: const Icon(
            Icons.notes_rounded,
            color: Colors.white,
            size: 35,
          ),
        ),
        // WELCOME / NAME SECTION
        Container(
          margin:
              const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  getGreetingText(),
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: ValueListenableBuilder<Box<User>>(
                  valueListenable: Boxes.getUsers().listenable(),
                  builder: (context, box, _) {
                    final newUser = box.getAt(0)!;
                    return buildUser(context, newUser);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// GREETING TEXT DETERMINANCE
// this holds the active greeting text
getGreetingText() {
  String activeGreetingText = '';
  for (int i = 0; i < greetingTimes.length; i++) {
    int status = activeTimeUpdateCheck(greetingTimes[i]);
    if (status >= 0) {
      activeGreetingText = greetingStrings[i];
    }
  }
  return activeGreetingText;
}

// OPTIONS MENU
_optionsMenu(BuildContext context, User userInfo) {
  return SafeArea(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: const [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Options",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
        ListTile(
          title: Row(
            children: const [
              Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
              ),
              Text(
                ' Name',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          onTap: () {
            // Make pop up appear
            _editNamePopUp(context, userInfo);
          },
        ),
        ListTile(
          title: Row(
            children: const [
              Icon(
                Icons.bug_report_rounded,
                color: Colors.white,
              ),
              Text(
                ' Report Issues',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          onTap: () {
            // Make pop up appear
            _reportIssuePopUp(context);
          },
        ),
        ListTile(
          title: Row(
            children: const [
              Icon(
                Icons.lightbulb_rounded,
                color: Colors.white,
              ),
              Text(
                ' Suggest Ideas',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          onTap: () {
            // Make pop up appear
            _suggestIdeaPopUp(context);
          },
        ),
      ],
    ),
  );
}

// BUILD USER
// This returns a text widget
Widget buildUser(BuildContext context, User userInfo) {
  // this text is what displays the users name
  return Text(
    // User Name
    Boxes.getUsers().getAt(0)!.name,
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );
}

// Edit Name Controller
final editNameController = TextEditingController(text: '');
// EDIT NAME
_editNamePopUp(BuildContext context, User userInfo) {
// EDIT NAME POPUP
// this displays when the user has selected to edit the name from the drawer menu
// initialize controller
  editNameController.text = '';
  // Actual pop up object
  Alert(
    style: const AlertStyle(
      backgroundColor: Color(0xff3b3b3b),
      titleStyle: TextStyle(color: Colors.white),
    ),
    context: context,
    title: "Edit Name",
    content: Column(
      children: <Widget>[
        // edit name input field
        TextField(
          controller: editNameController,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
            ),
            labelText: '',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
    // Confirm button
    buttons: [
      DialogButton(
        onPressed: () => {
          // get rid of pop up
          Navigator.pop(context),
          if (editNameController.text != "")
            {
              // save the name to the device
              editUser(userInfo, editNameController.text),
            },
          // display edit made snackbar
          _changedName(context),
        },
        child: const Text(
          "Set Name",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    ],
  ).show();
}

// EDIT USER (HIVE)
// this makes the changes that are chosen in the _editNamePopUp() method
void editUser(
  User userInfo,
  String name,
) {
  userInfo.name = name;
  // Update values of the existing user
  userInfo.save();
}

// CHANGED NAME SNACKBAR
// this snackbar will be displayed when a user changes their name
_changedName(BuildContext context) {
  // Varying Variables
  String message;
  Color color;
  if (editNameController.text != "") {
    message = "Name Updated!";
    color = Colors.greenAccent.shade700;
  } else {
    message = "You can't have a blank name.";
    color = Colors.redAccent;
  }
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16.0),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
  ));
}

// Bug Report Controller
final bugReportController = TextEditingController(text: '');
// REPORT ISSUES
_reportIssuePopUp(BuildContext context) {
// REPORT ISSUES POPUP
// this displays when the user has selected to report an issue from the drawer menu
// initialize controller
  bugReportController.text = '';
  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Report an Issue",
      content: Column(
        children: <Widget>[
          // Guidance
          const Text(
            "Try to include information such as the page it occurred on, and how it can be recreated.",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          // bug report input field
          TextField(
            controller: bugReportController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.bug_report_rounded,
                color: Colors.white,
              ),
              labelText: '',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // Confirm button
      buttons: [
        DialogButton(
          onPressed: () => {
            // get rid of pop up
            Navigator.pop(context),
            // display sent snackbar
            _bugReportSent(context)
          },
          child: const Text(
            "Report",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// BUG REPORT SENT SNACKBAR
// this snackbar will be displayed when a user submits a bug report
Future _bugReportSent(BuildContext context) async {
  // Varying Variables
  String message = "";
  Color color = Colors.transparent;
  // Check Connection
  try {
    final result = await InternetAddress.lookup('google.com');
    // connected
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      message = "Sent, thanks for informing us!";
      color = Colors.greenAccent.shade700;
    }
    // disconnected
  } on SocketException catch (_) {
    message = "You are currently disconnected.";
    color = Colors.redAccent;
  }

  // Return the newly made snackbar values in a snackbar.
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16.0),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
    ),
  );
}

// Suggest an Idea Controller
final suggestionController = TextEditingController(text: '');
// SUGGEST IDEAS
_suggestIdeaPopUp(BuildContext context) {
// SUGGEST IDEAS POPUP
// this displays when the user has selected to suggest an idea from the drawer menu
// initialize controller
  suggestionController.text = '';
  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Suggest an Idea",
      content: Column(
        children: <Widget>[
          // Guidance
          const Text(
            "Tell us about your idea and why you would find it useful.",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          // idea suggestion input field
          TextField(
            controller: suggestionController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.lightbulb_rounded,
                color: Colors.white,
              ),
              labelText: '',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // Confirm button
      buttons: [
        DialogButton(
          onPressed: () => {
            // get rid of pop up
            Navigator.pop(context),
            // display sent snackbar
            _ideaSent(context)
          },
          child: const Text(
            "Suggest",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// SUGGESTION/IDEA SENT SNACKBAR
// this snackbar will be displayed when a user submits a suggestion/idea
Future _ideaSent(BuildContext context) async {
  // Varying Variables
  String message = "";
  Color color = Colors.transparent;
  // Check Connection
  try {
    final result = await InternetAddress.lookup('google.com');
    // connected
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      message = "Sent, thanks for the idea!";
      color = Colors.greenAccent.shade700;
    }
    // disconnected
  } on SocketException catch (_) {
    message = "You are currently disconnected.";
    color = Colors.redAccent;
  }

  // Return the newly made snackbar values in a snackbar.
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16.0),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
  ));
}

// CURRENT CLASS INFORMATION CONTAINER
// this stores the active class index
int activeClass = 0;
// this is the "global" reference allowing for other functions to see the active class
List<dynamic> allClasses = [];
// Compare times, and update active class if needed
updateActiveClass() {
  allClasses = Boxes.getClasses().values.toList().cast();
  // Only run logic if classes exist
  activeClass = 0;
  if (Boxes.getClasses().isNotEmpty) {
    // determine what class should be active
    // ensure that the school day is still happening
    int timeStat = activeTimeUpdateCheck(endOfDay);
    if (timeStat <= 0) {
      // if it is determine the active class
      for (int i = 1; activeClass < i + 1; i++) {
        int status = activeTimeUpdateCheck(checkTimes[activeClass]);
        if (status == 1 && activeClass != 6) {
          activeClass += 1;
        } else {
          print(activeClass);
          break;
        }
      }
    }
  } else {
    print("VALUES NULL");
    return;
  }
  print(activeClass);
}

// this contains the class object that will hold the active class info
Class currentClass = Class();

// CURRENT CLASS
// this contains, and styles the container showing the current class, time, and room
_currentClassInfo() {
  return Container(
    margin: const EdgeInsets.only(
      right: 15.0,
      left: 15.0,
      top: 15.0,
    ),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.blue,
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.blue,
          Color(0xFF5C9BED),
        ],
      ),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      _getActiveClassTime(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _getActiveClassName(),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.meeting_room_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      _getActiveClassRoom(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// GET ACTIVE CLASS INFO

// the functions act to ensure the value given is never null
// returns the active class NAME
String _getActiveClassName() {
  int timeStat = activeTimeUpdateCheck(endOfDay);
  if (timeStat <= 0) {
    // ensures the value is not null
    if (Boxes.getClasses().isEmpty && allClasses.isEmpty) {
      // If there are no classes then say so
      return 'No Classes';
    } else {
      if (Boxes.getClasses().length < activeClass) {
        // If the active class time doesnt match any classes then tell the user
        return "No Class Scheduled";
      } else {
        // Handling early bird times
        if (Boxes.getClasses().length < 7) {
          // no early bird
          return allClasses[activeClass - 1].name;
        } else {
          // early bird
          return allClasses[activeClass].name;
        }
      }
    }
  } else {
    return 'School Is Out';
  }
}

// returns the active class TIME
String _getActiveClassTime() {
  int timeStat = activeTimeUpdateCheck(endOfDay);
  if (timeStat <= 0) {
    // ensures the value is not null
    if (Boxes.getClasses().isEmpty && allClasses.isEmpty) {
      // If there are no classes then say so
      return 'No Classes';
    } else {
      if (Boxes.getClasses().length < activeClass) {
        // If the active class time doesnt match any classes then tell the user
        return "";
      } else {
        // Handling early bird times
        if (Boxes.getClasses().length < 7) {
          // no early bird
          return allClasses[activeClass - 1].time;
        } else {
          // early bird
          return allClasses[activeClass].time;
        }
      }
    }
  } else {
    if (Boxes.getClasses().length < 7) {
      return '3:00(pm)-8:30(am)';
    } else {
      return '3:00(pm)-7:30(am)';
    }
  }
}

// returns the active class ROOM
String _getActiveClassRoom() {
  int timeStat = activeTimeUpdateCheck(endOfDay);
  if (timeStat <= 0) {
    // ensures the value is not null
    if (Boxes.getClasses().isEmpty && allClasses.isEmpty) {
      // If there are no classes then say so
      return 'No Classes';
    } else {
      if (Boxes.getClasses().length < activeClass) {
        // If the active class time doesnt match any classes then tell the user
        return "";
      } else {
        // Handling early bird times
        if (Boxes.getClasses().length < 7) {
          // no early bird
          return allClasses[activeClass - 1].room;
        } else {
          // early bird
          return allClasses[activeClass].room;
        }
      }
    }
  } else {
    return '';
  }
}

_mainSection() {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(0.0),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 0.0),
            blurRadius: 30.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _currentClassInfo(),
          _lunchForTheDay(),
        ],
      ),
    ),
  );
}

// LUNCH FOR THE CURRENT DAY CONTAINER
_lunchForTheDay() {
  return Container(
    margin:
        const EdgeInsets.only(top: 20.0, bottom: 0, left: 15.0, right: 15.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      children: [
        // Top Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              // TITLE
              Text(
                "Today's Lunch",
                style: TextStyle(fontSize: 23),
              ),
              Spacer(),
              // TIME
              Text(
                "11:30-12:00",
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
        // LUNCH ITEMS
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Pizza, fruit cup, breadsticks, milk",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}
