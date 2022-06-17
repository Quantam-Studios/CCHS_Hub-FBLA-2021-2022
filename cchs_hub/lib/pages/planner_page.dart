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
              builder: (context) => AddEventPage(),
            ),
          )
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topSection(context),
            Padding(
              padding: const EdgeInsets.all(10),
              // EVENT LIST ITEMS
              child: ValueListenableBuilder<Box<Event>>(
                valueListenable: Boxes.getEvents().listenable(),
                builder: (context, box, _) {
                  final newEvents = box.values.toList().cast<Event>();
                  return buildEvents(newEvents);
                },
              ),
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
    return const Center(
      child: Text(
        "Press the + to add an event.",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  } else {
    return Column(
      children: [
        // this dynamically creates a new card (ListTile) for each event
        ListView.builder(
          padding: const EdgeInsets.all(0.0),
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

  // Event Card
  // this card is what styles the display of events
  return Column(
    children: [
      ExpansionTileCard(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.star_border_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade700,
      ),
    ],
  );
}

// EDIT EVENT
// calendar initialization
CalendarFormat _calendarFormat = CalendarFormat.month;
DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();

// this holds the "page" that wil allow for creation of an event
class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  AddEventContent createState() => AddEventContent();
}

class AddEventContent extends State<AddEventPage> {
  // TEXT CONTROLLERS
  // Name
  TextEditingController nameController = TextEditingController(text: '');
  // Description
  TextEditingController descriptionController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Add Event"),
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
                    controller: nameController,
                    // set length
                    maxLength: 30,
                    decoration: const InputDecoration(
                      labelText: 'Name',
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
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.short_text_rounded),
                    ),
                  ),
                ),
                // ADD BUTTON
                // Acts as a "submit" button
                TextButton(
                  onPressed: () => {
                    exitMenu(context),
                    addEvent(nameController.text, _selectedDay,
                        descriptionController.text)
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 16),
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
