import 'package:dicoding_zuhair/core/model/note.dart';
import 'package:dicoding_zuhair/core/router/route_name.dart';
import 'package:dicoding_zuhair/core/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteCard extends StatelessWidget {
  final Color color;
  final String title;
  final String content;
  final int index;
  final BuildContext context_;
  final int? timeCreated;
  final bool isPinned;

  const NoteCard({
    Key? key,
    required this.color,
    required this.title,
    required this.content,
    required this.context_,
    this.timeCreated,
    this.isPinned = false,
    this.index = 1000,
  }) : super(key: key);

  String _formatDate(int? epoch) {
    if (epoch == null) {
      return "Unknown date";
    }
    final date = DateTime.fromMillisecondsSinceEpoch(epoch);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context_).size;

    // delete note
    void _deleteNote(int index) {
      Hive.box<Note>(boxNote).deleteAt(index);
    }

    void _togglePinned() {
      final note = Note(
        title: title,
        content: content,
        colorHex: colorToHex(color),
        timeCreated: timeCreated,
        isPinned: !isPinned,
      );
      Hive.box<Note>(boxNote).putAt(index, note);
    }

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        width: size.width * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatDate(timeCreated),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                if (isPinned) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.push_pin_rounded,
                    size: 14,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title.isEmpty ? "Untitled note" : title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              content.isEmpty ? "Write something..." : content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            if (index != 1000) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    tooltip: "Actions",
                    onSelected: (value) {
                      if (value == "edit") {
                        Navigator.pushNamed(
                          context,
                          RouteName.editNote,
                          arguments: {
                            "title": title,
                            "content": content,
                            "colorHex": colorToHex(color),
                            "index": index,
                            "isPinned": isPinned,
                            "timeCreated": timeCreated,
                          },
                        );
                      } else if (value == "pin") {
                        _togglePinned();
                      } else if (value == "delete") {
                        _deleteNote(index);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "pin",
                        child: Text(isPinned ? "Unpin" : "Pin"),
                      ),
                      const PopupMenuItem(
                        value: "edit",
                        child: Text("Edit"),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
