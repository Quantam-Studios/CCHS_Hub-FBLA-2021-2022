// Hive
import 'package:hive/hive.dart';
part 'class.g.dart';

@HiveType(typeId: 1)
class Class extends HiveObject {
  // Class Name
  @HiveField(0)
  late String name;

  // Rooom
  @HiveField(1)
  late String room;

  // Time
  @HiveField(2)
  late String time;
}
