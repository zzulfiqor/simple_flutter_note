import 'package:hive_flutter/hive_flutter.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? content;

  @HiveField(3)
  int? timeCreated;

  @HiveField(4)
  String? colorHex;

  @HiveField(5)
  bool? isPinned;

  Note({
    this.id,
    this.title,
    this.content,
    this.timeCreated,
    this.colorHex,
    this.isPinned,
  });
}
