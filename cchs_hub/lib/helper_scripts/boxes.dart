// Hive Data Base
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Model types
import '../model/user.dart';
import '../model/class.dart';
import '../model/event.dart';

class Boxes {
  static Box<User> getUsers() => Hive.box<User>('users');
  static Box<Class> getClasses() => Hive.box<Class>('classes');
  static Box<Event> getEvents() => Hive.box<Event>('events');
}
