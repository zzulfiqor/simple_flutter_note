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
      isInit = false;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note Preview
            const SizedBox(height: 32),
            Center(
              child: NoteCard(
                color: colorFromHex(widget.colorHex)!,
                title: widget.title,
                content: widget.content,
                context_: context,
              ),
            ),

            // Note Title Input
            const SizedBox(height: 32),

            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: "Note Title",
              ),
              onChanged: (val) {
                setState(() {
                  widget.title = val;
                });
              },
            ),

            // Note Content Input
            TextField(
              controller: widget.contentController,
              decoration: const InputDecoration(
                labelText: "Note Content",
              ),
              minLines: 1,
              maxLines: 4,
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
                  "Set Note Color : ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                // Color
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Pick a color"),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: colorFromHex(widget.colorHex) ??
                                    Colors.white,
                                onColorChanged: (color) =>
                                    _setColor(colorToHex(color)),
                              ),
                            ),
                          );
                        });
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

            // Add New Note
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              width: size.width,
              child: ElevatedButton(
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
                child: Text(widget.isEdit ? "Ubah" : "Create Note"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
