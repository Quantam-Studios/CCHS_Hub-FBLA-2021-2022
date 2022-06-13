// Hive Data Base
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Model types
import 'model/user.dart';

class Boxes {
  static Box<User> getUsers() => Hive.box<User>('users');
}
