// Hive
import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 2)
class Event extends HiveObject {
  // Event Name
  @HiveField(0)
  late String name;

  // Room
  @HiveField(1)
  late String description;

  // Date
  @HiveField(2)
  late DateTime date;

  // Importance
  @HiveField(3)
  late bool marked;
}
