// General
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
// Pop Ups
import 'package:rflutter_alert/rflutter_alert.dart';
// Time Management
import 'package:cchs_hub/helper_scripts/time_management.dart';
// Hive Models
import 'package:cchs_hub/model/class.dart';
// Hive
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cchs_hub/helper_scripts/boxes.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  ClassPageContent createState() => ClassPageContent();
}

class ClassPageContent extends State {
  @override
  void initState() {
    // test
    // clear input field controllers
    classAddController.text = "";
    classRoomAddController.text = "";
    // general initialization (flutter method)
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    classAddController.text = "";
    classRoomAddController.text = "";
    // general app (flutter method)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      backgroundColor: const Color(0xFF121212),
      floatingActionButton: FloatingActionButton(
        // ADD EVENT
        onPressed: () => {
          // ensure that no more than 7 classes can be added.
          if (Boxes.getClasses().length < 7)
            // if < 7 then allow for a new class to be made
            {_addClass(context)}
          else
            // if there are already 7 classes then tell the user
            {
              _tooManyClasses(context),
            },
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top
              _topSection(context),
              // List Of Classes
              ValueListenableBuilder<Box<Class>>(
                valueListenable: Boxes.getClasses().listenable(),
                builder: (context, box, _) {
                  final newClasses = box.values.toList().cast<Class>();
                  return buildClasses(newClasses);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TOP SECTION
// this has the title of the page as well as the buttons to add and clear classes
_topSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF222222),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 10.0,
      ),
      child: Row(
        children: [
          // Title
          const Text(
            "Your Classes",
            style: TextStyle(fontSize: 23),
          ),
          // Separation
          const Spacer(),
          // Clear Button
          TextButton(
            style: TextButton.styleFrom(primary: Colors.redAccent),
            child: const Text(
              "Clear",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () => {
              Boxes.getClasses().clear(),
              Boxes.getClasses().compact(),
            },
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    ),
  );
}

// TIME OFFSET
// this regulates class time display of with and without early bird
// if the value is 1 then the class times will start at 1st Hour
// if the value is 0 then the class times will start at early bird hour
int offset = 1;

// BUILD CLASSES
// Contruction of the class list happens here
Widget buildClasses(List<Class> allClasses) {
  // Check if any classes exist
  if (allClasses.isEmpty) {
    // if not then tell the user
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(text: "Press "),
              TextSpan(text: "+", style: TextStyle(color: Colors.blue)),
              TextSpan(text: " to add a class.")
            ]),
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          Divider(
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  } else {
    // if so then display all classes
    // Update time offset see "TIME OFFSET" seciton for explanation
    if (Boxes.getClasses().length < 7) {
      offset = 1;
    } else {
      offset = 0;
    }
    return Column(
      children: [
        // this dynamically creates a new card (ListTile) for each class
        ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: allClasses.length,
          itemBuilder: (BuildContext context, int index) {
            final newClass = allClasses[index];
            return buildClass(context, newClass, index);
          },
        ),
      ],
    );
  }
}

// CLASS CARD
Widget buildClass(BuildContext context, Class classInfo, int index) {
  // Update the time of the class dynamically
  classInfo.time = classTimes[index + offset];
  // Save the time to the existing class
  classInfo.save();
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 0.0,
    ),
    child: Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          // Class Name
          title: Text(
            classInfo.name,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          // Time, Room
          subtitle: Text(
            classInfo.time + '  ' + classInfo.room,
            style: const TextStyle(fontSize: 16),
          ),
          // Edit Class Button
          trailing: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => {_editClass(context, classInfo)},
          ),
          textColor: Colors.grey,
        ),
        Divider(
          color: Colors.grey.shade700,
        ),
      ],
    ),
  );
}

// CONTROLLERS FOR TEXTFIELDS
// Class Name Controller
final classAddController = TextEditingController(text: '');
// Room Controller
final classRoomAddController = TextEditingController(text: '');

// ADD CLASS POPUP
// function called draws a pop up
_addClass(context) {
  // Set Defualt Text To Blank: ''
  classAddController.text = '';
  classRoomAddController.text = '';

  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Add Class",
      content: Column(
        children: <Widget>[
          // Class name input field
          TextField(
            controller: classAddController,
            // limit the string size to a maximum of 18
            inputFormatters: [
              LengthLimitingTextInputFormatter(18),
            ],
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              icon:
                  Icon(Icons.format_list_bulleted_rounded, color: Colors.white),
              labelText: 'Class',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          // room input field
          TextField(
            controller: classRoomAddController,
            // limit the string size to a maximum of 4
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              icon: Icon(Icons.meeting_room_outlined, color: Colors.white),
              labelText: 'Room',
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
            // save the class to the device
            addClass(classAddController.value.text,
                classRoomAddController.value.text),
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// ADD CLASS (HIVE)
// this function saves the newly created class to the systems local storage with hive
Future addClass(String name, String room) async {
  // Create Class() object
  final newClass = Class()
    ..name = name
    ..room = room
    ..time = "";

  // Transfer object types to hive readable
  // Add new class
  // Save to local storage
  final box = Boxes.getClasses();
  box.add(newClass);
}

// MAXIMUM CLASS COUNT REACHED SNACKBAR
// this snackbar will be displayed when a user tries to add another class
// -when the maximum amount of classes (7) has been reached
_tooManyClasses(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('You can only have 7 classes in a day!',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
    ),
  );
}

// CONTROLLERS FOR TEXTFIELDS
// Class Name Controller
final classEditController = TextEditingController(text: '');
// Room Controller
final classRoomEditController = TextEditingController(text: '');

// EDIT CLASS POPUP
// this displays when the user has slected to edit a class
// -that has already been made
_editClass(context, Class classInfo) {
  // Set Initial Values
  classEditController.text = classInfo.name;
  classRoomEditController.text = classInfo.room;
  // Actual pop up object
  Alert(
      style: const AlertStyle(
          backgroundColor: Color(0xff3b3b3b),
          titleStyle: TextStyle(color: Colors.white)),
      context: context,
      title: "Edit Class",
      content: Column(
        children: <Widget>[
          // Class name input field
          TextField(
            controller: classEditController,
            // limit the string size to a maximum of 20
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon:
                  Icon(Icons.format_list_bulleted_rounded, color: Colors.white),
              labelText: 'Class',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          // room input field
          TextField(
            controller: classRoomEditController,
            // limit the string size to a maximum of 4
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(Icons.meeting_room_outlined, color: Colors.white),
              labelText: 'Room',
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
            // save the class to the device
            editClass(classInfo, classEditController.text,
                classRoomEditController.text)
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// EDIT CLASS
// this makes the changes that are chosen in the _editClass() method
void editClass(
  Class classInfo,
  String name,
  String room,
) {
  classInfo.name = name;
  classInfo.room = room;

  // Update values of the existing class
  classInfo.save();
}
