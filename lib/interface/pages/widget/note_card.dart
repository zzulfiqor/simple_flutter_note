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

  const NoteCard({
    Key? key,
    required this.color,
    required this.title,
    required this.content,
    required this.context_,
    this.index = 1000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context_).size;

    // delete note
    void _deleteNote(int index) {
      Hive.box<Note>(boxNote).deleteAt(index);
    }

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: size.width * .4,
        child: Column(
          children: [
            // Note Title
            Text(
              title.isEmpty ? "Title" : title,
              style: const TextStyle(fontSize: 24),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Note Content
            const SizedBox(height: 8),
            Text(
              content.isEmpty ? "..." : content,
              style: const TextStyle(fontSize: 16),
              maxLines: 99,
              overflow: TextOverflow.ellipsis,
            ),

            // Delete Button
            const SizedBox(height: 16),
            index == 1000
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: .35,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.pushNamed(
                              context, RouteName.editNote,
                              arguments: {
                                "title": title,
                                "content": content,
                                "colorHex": colorToHex(color),
                                "index" :index,
                              }),
                        ),
                      ),
                      Opacity(
                        opacity: .35,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNote(index),
                        ),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
