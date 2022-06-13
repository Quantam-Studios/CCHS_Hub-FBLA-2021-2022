// Hive
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  // Name
  @HiveField(0)
  late String name;
}
