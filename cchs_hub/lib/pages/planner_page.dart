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
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topSection(context),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _eventCard(),
                  _eventCard(),
                  _eventCard(),
                  _eventCard(),
                  _eventCard(),
                ],
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

_eventCard() {
  return Column(
    children: [
      ExpansionTileCard(
        baseColor: const Color(0xFF121212),
        expandedColor: const Color(0xFF353535),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        // Shadow
        shadowColor: Colors.black.withOpacity(0.5),
        elevation: 7.0,
        // Event Name
        title: const Text(
          "Track Meet",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        // Event Date
        subtitle: const Text("12/00/2022",
            style: TextStyle(color: Colors.grey, fontSize: 15)),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("It's probably going to be from 10:00am to 6:00pm"),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {},
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.star_border_rounded),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {},
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.more_vert_rounded),
                  ],
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
