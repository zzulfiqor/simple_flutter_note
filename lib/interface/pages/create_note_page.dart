import 'package:dicoding_zuhair/core/model/note.dart';
import 'package:dicoding_zuhair/core/utils/const.dart';
import 'package:dicoding_zuhair/interface/pages/widget/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class CreateNotePage extends StatefulWidget {
  final bool isEdit;
  CreateNotePage({Key? key, this.isEdit = false}) : super(key: key);

  // Note
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String title = "";
  String content = "";
  int index = 1000;
  String colorHex = defaultNoteBackground;
  bool isPinned = false;
  int? timeCreated;

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  var isInit = false;

  @override
  void initState() {
    isInit = true;
    super.initState();
  }

  // pick color
  void _setColor(String hex) {
    setState(() {
      widget.colorHex = hex;
      Navigator.pop(context);
    });
  }

  void addNote(Note note) {
    Hive.box<Note>(boxNote).add(note);
    Navigator.pop(context);
  }

  void editNote(Note note) {
    Hive.box<Note>(boxNote).putAt(widget.index, note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;

    if (widget.isEdit == true && isInit == true) {
      widget.title = arguments['title'] ?? '';
      widget.titleController.text = widget.title;
      widget.content = arguments['content'] ?? '';
      widget.contentController.text = widget.content;
      widget.colorHex = arguments['colorHex'] ?? '';
      widget.index = arguments['index'] ?? 0;
      widget.isPinned = arguments['isPinned'] ?? false;
      widget.timeCreated = arguments['timeCreated'];
      isInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Note" : "Create Note"),
        actions: [
          IconButton(
            tooltip: "Save",
            onPressed: () {
              widget.isEdit
                  ? editNote(
                      Note(
                        title: widget.titleController.text,
                        content: widget.contentController.text,
                        colorHex: widget.colorHex,
                        timeCreated: DateTime.now().millisecondsSinceEpoch,
                      ),
                    )
                  : addNote(
                      Note(
                        title: widget.titleController.text,
                        content: widget.contentController.text,
                        colorHex: widget.colorHex,
                        timeCreated: DateTime.now().millisecondsSinceEpoch,
                      ),
                    );
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: NoteCard(
                color: colorFromHex(widget.colorHex)!,
                title: widget.title,
                content: widget.content,
                context_: context,
                timeCreated: DateTime.now().millisecondsSinceEpoch,
              ),
            ),

            // Note Title Input
            const SizedBox(height: 24),

            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Add a title",
                filled: true,
              ),
              onChanged: (val) {
                setState(() {
                  widget.title = val;
                });
              },
            ),

            // Note Content Input
            const SizedBox(height: 16),
            TextField(
              controller: widget.contentController,
              decoration: const InputDecoration(
                labelText: "Content",
                hintText: "Write your note",
                filled: true,
              ),
              minLines: 1,
              maxLines: 6,
              onChanged: (val) {
                setState(() {
                  widget.content = val;
                });
              },
            ),

            // Color Picker
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  "Note Color",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),

                // Color
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pick a color",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              BlockPicker(
                                pickerColor: colorFromHex(widget.colorHex) ??
                                    Colors.white,
                                onColorChanged: (color) =>
                                    _setColor(colorToHex(color)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorFromHex(widget.colorHex),
                      border: Border.all(
                        color: Colors.black.withOpacity(.4),
                        width: 1,
                      ),
                    ),
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text("Pin this note"),
              subtitle: const Text("Pinned notes stay at the top"),
              value: widget.isPinned,
              onChanged: (value) {
                setState(() {
                  widget.isPinned = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              width: size.width,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.isEdit
                      ? editNote(
                          Note(
                            title: widget.titleController.text,
                            content: widget.contentController.text,
                            colorHex: widget.colorHex,
                            timeCreated: widget.timeCreated ??
                                DateTime.now().millisecondsSinceEpoch,
                            isPinned: widget.isPinned,
                          ),
                        )
                      : addNote(
                          Note(
                            title: widget.titleController.text,
                            content: widget.contentController.text,
                            colorHex: widget.colorHex,
                            timeCreated: DateTime.now().millisecondsSinceEpoch,
                            isPinned: widget.isPinned,
                          ),
                        );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: Text(widget.isEdit ? "Save Changes" : "Create Note"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
