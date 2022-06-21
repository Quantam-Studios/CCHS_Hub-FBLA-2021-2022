// General
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
// Calendar
import 'package:table_calendar/table_calendar.dart';
// Display of Events
import 'package:expansion_tile_card/expansion_tile_card.dart';
// Popups
import 'package:rflutter_alert/rflutter_alert.dart';
// Events
import '/model/event.dart';
// Hive DataBase
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cchs_hub/helper_scripts/boxes.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  PlannerPageContent createState() => PlannerPageContent();
}

class PlannerPageContent extends State<PlannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      floatingActionButton: FloatingActionButton(
        // ADD EVENT
        onPressed: () => {
          // Push Add Event Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventPage(),
            ),
          )
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            _topSection(context),
            ValueListenableBuilder<Box<Event>>(
              valueListenable: Boxes.getEvents().listenable(),
              builder: (context, box, _) {
                final newEvents = box.values.toList().cast<Event>();
                return buildEvents(newEvents);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TOP SECTION
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
            "Your Plans",
            style: TextStyle(fontSize: 23),
          ),
          // Separation
          const Spacer(),
          // Sort By Button
          TextButton(
            child: const Text(
              "Sort By",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () => {},
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    ),
  );
}

// BUILD EVENTS
// Contruction of the event list happens here
Widget buildEvents(List<Event> allEvents) {
  // Check if any events exist
  if (allEvents.isEmpty) {
    // if not then tell the user
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(text: "Press "),
              TextSpan(text: "+", style: TextStyle(color: Colors.blue)),
              TextSpan(text: " to add an event.")
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
    return Column(
      children: [
        // this dynamically creates a new card (ListTile) for each event
        ListView.builder(
          padding: const EdgeInsets.all(10.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allEvents.length,
          itemBuilder: (BuildContext context, int index) {
            final newEvent = allEvents[index];
            return buildEvent(context, newEvent, index);
          },
        ),
      ],
    );
  }
}

// BUILD EVENT
// This returns a event card
Widget buildEvent(BuildContext context, Event eventInfo, int index) {
  // Determine Time Format
  String finalTimeString = eventInfo.date.toIso8601String().substring(0, 10);
  Widget event;
  // Buttons
  _starButton() {
    IconData icon = Icons.star_outline_rounded;
    if (eventInfo.marked) {
      icon = Icons.star_rounded;
    }

    return IconButton(
      onPressed: () => {
        // toggle marked bool
        if (eventInfo.marked)
          {
            eventInfo.marked = false,
            icon = Icons.star_outline_rounded,
          }
        else
          {
            eventInfo.marked = true,
            icon = Icons.star_rounded,
          },
        eventInfo.save(),
      },
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  _editButton() {
    return IconButton(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
      ),
      onPressed: () => {
        // Push Add Event Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(eventInfo: eventInfo),
          ),
        )
      },
    );
  }

  // this card is what styles the display of events
  // if the description is blank dont use an expandable widget.
  if (eventInfo.description == "") {
    event = ListTile(
      contentPadding: const EdgeInsets.only(right: 5.0, left: 20.0),
      // Class Name
      title: Text(
        eventInfo.name,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      // Date
      subtitle: Text(
        finalTimeString,
        style: const TextStyle(fontSize: 16),
      ),
      // Edit Class Button
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _starButton(),
          _editButton(),
        ],
      ),
      textColor: Colors.grey,
    );
    // else a description exists, use an expandable widget.
  } else {
    event = ExpansionTileCard(
      trailing: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.white,
      ),
      baseColor: const Color(0xFF121212),
      expandedColor: const Color(0xFF353535),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      // Shadow
      shadowColor: Colors.black,
      elevation: 7.0,
      // Event Name
      title: Text(
        eventInfo.name,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      // Event Date
      subtitle: Text(finalTimeString,
          style: const TextStyle(color: Colors.grey, fontSize: 16)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              eventInfo.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            _starButton(),
            _editButton(),
          ],
        ),
      ],
    );
  }
  return Column(
    children: [
      // Dismiss behavior
      Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.greenAccent.shade700,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.check_box_rounded,
              color: Colors.white,
            ),
          ),
        ),
        onDismissed: (direction) => {
          deleteEvent(eventInfo),
        },
        // Actual Card
        child: event,
      ),
      Divider(
        color: Colors.grey.shade700,
      ),
    ],
  );
}

// EVENT ADD/EDIT PAGE
// this holds the "page" that will allow for editing of an event
// if there is an event passed then editing is occuring else adding

class EventPage extends StatefulWidget {
  const EventPage({this.eventInfo, Key? key}) : super(key: key);
  final Event? eventInfo;

  @override
  // ignore: no_logic_in_create_state
  EventContent createState() => EventContent(eventInfo);
}

class EventContent extends State<EventPage> {
  // Calendar Initialization
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  // Event
  final Event? _eventInfo;
  EventContent(this._eventInfo);
  // TEXT CONTROLLERS
  // Name
  TextEditingController nameController = TextEditingController(text: '');
  // Description
  TextEditingController descriptionController = TextEditingController(text: '');

  // Varying Variables
  String submitText = '';
  String titleText = '';

  @override
  void initState() {
    // If Editing
    if (_eventInfo != null) {
      nameController.text = _eventInfo!.name;
      descriptionController.text = _eventInfo!.description;
      submitText = 'Edit';
      titleText = 'Edit Event';
      // Else Adding
    } else {
      submitText = 'Add';
      titleText = 'Add Event';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: const Color(0xFF212121),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // SET DATE
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              side: BorderSide(color: Color(0xff333333), width: 2.0),
            ),
            color: const Color(0xff121212),
            margin:
                const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            // CALENDAR WIDGET
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2021),
              lastDay: DateTime(2023),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              // Calendar Header Styling
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xff333333),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                formatButtonShowsNext: false,
                formatButtonTextStyle:
                    TextStyle(color: Colors.white, fontSize: 16.0),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.blue,
                  size: 28,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              // Calendar Days Styling
              daysOfWeekStyle: const DaysOfWeekStyle(
                // Weekend days color (Sat,Sun)
                weekendStyle: TextStyle(color: Color(0xff82B7FF)),
              ),
              // Calendar Dates styling
              calendarStyle: CalendarStyle(
                // Weekend dates color (Sat & Sun Column)
                weekendTextStyle: const TextStyle(color: Color(0xff82B7FF)),
                // highlighted color for today
                // get rid of all decoration for the current day
                todayDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.0),
                ),
                // highlighted color for selected day
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                withinRangeTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                defaultTextStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Contiains the "form section"
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                // SET EVENT NAME
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: nameController,
                    // set length
                    maxLength: 30,
                    decoration: const InputDecoration(
                      labelText: 'Name*',
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline_rounded,
                      ),
                      counterStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // SET EVENT DESCRIPTION (might be nothing)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.short_text_rounded),
                    ),
                  ),
                ),
                // EDIT BUTTON
                // Acts as a "submit" button
                TextButton(
                  onPressed: () => {
                    // Ensure Name Is Set
                    if (nameController.text != "")
                      {
                        exitMenu(context),
                        // If Editing
                        if (_eventInfo != null)
                          {
                            editEvent(
                              _eventInfo,
                              nameController.text,
                              _selectedDay,
                              descriptionController.text,
                            ),
                          }
                        // Else Adding
                        else
                          {
                            addEvent(
                              nameController.text,
                              _selectedDay,
                              descriptionController.text,
                            ),
                          },
                      }
                    else
                      {
                        // display error snackbar
                        _changeEvent(context)
                      }
                  },
                  child: Text(
                    submitText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// EXIT MENU
exitMenu(BuildContext context) {
  Navigator.pop(context);
}

// ADD EVENT (HIVE)
// this function saves the newly created event to the systems local storage with hive
Future addEvent(String name, DateTime date, String description) async {
  // Create Evet() object
  final newEvent = Event()
    ..name = name
    ..description = description
    ..marked = false
    ..date = date;

  // Transfer object types to hive readable
  // Add new event
  // Save to local storage
  final box = Boxes.getEvents();
  box.add(newEvent);
}

// CONTROLLERS FOR TEXTFIELDS
// Event Name Controller
final eventEditController = TextEditingController(text: '');

// EDIT EVENT
// this makes the changes that are chosen in the _editEvent() method
void editEvent(
  Event? eventInfo,
  String name,
  DateTime date,
  String description,
) {
  eventInfo!.name = name;
  eventInfo.date = date;
  eventInfo.description = description;
  // Update values of the existing event
  eventInfo.save();
}

// DELETE EVENT
void deleteEvent(Event eventInfo) {
  eventInfo.delete();
}

// ADD/EDIT EVENT SNACKBAR
// this will be displayed when the add/edit event button is pressed
_changeEvent(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        "Events must be named.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.0),
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
    ),
  );
}
