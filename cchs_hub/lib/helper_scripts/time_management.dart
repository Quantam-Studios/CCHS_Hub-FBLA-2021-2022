// General
// handles TimeOfDay data type
import 'package:flutter/material.dart';

// CLASS TIME TEXT
// this holds all class times as strings
// this is for displaying of class times
final List<String> classTimes = [
  // Early Bird
  '7:30-8:20(am)',
  // 1st Hour
  '8:30-9:25(am)',
  // 2nd Hour
  '9:30-10:25(am)',
  // 3rd Hour
  '10:30-11:25(am)',
  // 4th Hour
  '12:05-1:00(pm)',
  // 5th Hour
  '1:05-2:00(pm)',
  // 6th Hour
  '2:05-3:00(pm)',
];

// CLASS TIME CHECK VALUES
// this holds all class times as TimeOfDay values
final List<TimeOfDay> checkTimes = [
  // Early Bird
  const TimeOfDay(hour: 7, minute: 30),
  // 1st Period
  const TimeOfDay(hour: 8, minute: 30),
  // 2nd Period
  const TimeOfDay(hour: 9, minute: 30),
  // 3rd Period
  const TimeOfDay(hour: 10, minute: 30),
  // 4th Period
  const TimeOfDay(hour: 12, minute: 5),
  // 5th Period
  const TimeOfDay(hour: 13, minute: 5),
  // 6th Period
  const TimeOfDay(hour: 14, minute: 5),
];

// CLASS TIME TEXT
// this holds all class times as strings
// this is for displaying of class times
final List<String> greetingStrings = [
  // Morning
  'Good Morning',
  // Afternoon
  'Good Afternoon',
  // Evening
  'Good Evening',
];

// CLASS TIME CHECK VALUES
// this holds all class times as TimeOfDay values
final List<TimeOfDay> greetingTimes = [
  // Morning
  const TimeOfDay(hour: 0, minute: 0),
  // Afternoon
  const TimeOfDay(hour: 12, minute: 1),
  // Evening
  const TimeOfDay(hour: 18, minute: 0)
];

const endOfDay = TimeOfDay(hour: 15, minute: 0);

// GET CURRENT TIME
// returns the current time from the device formmated like 00:00 hh/mm
getCurrentTime() {
  TimeOfDay dateTime = TimeOfDay.now();
  return dateTime.toString();
}

// ACTIVE CLASS UPDATE CHECK
// The method for comparing times in TimeOfDay formats returns an int
// 0 = no difference, -1 = less, 1 = greater
activeTimeUpdateCheck(TimeOfDay other) {
  return TimeOfDay.now().compareTo(other);
}

// This is the actual comparison of time values
// IMPORTANT: Compare extension DO NOT CALL THIS INSTEAD CALL activeTimeUpdateCheck()
extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}
