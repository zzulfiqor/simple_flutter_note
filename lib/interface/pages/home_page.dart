import 'package:dicoding_zuhair/core/model/note.dart';
import 'package:dicoding_zuhair/core/router/route_name.dart';
import 'package:dicoding_zuhair/core/utils/const.dart';
import 'package:dicoding_zuhair/interface/pages/widget/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZuNotes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteName.appInfo);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Note>(boxNote).listenable(),
          builder: (ctx, Box box, _) {
            bool isEmpty = box.isEmpty;

            return isEmpty
                ? const Center(
                    child: Text("Notes empty."),
                  )
                : MasonryGridView.count(
                    padding: const EdgeInsets.all(12),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: box.length,
                    itemBuilder: (ctx, index) {
                      var note = box.getAt(index) as Note;
                      return NoteCard(
                        color: colorFromHex(note.colorHex!)!,
                        title: note.title!,
                        content: note.content!,
                        context_: context,
                        index: index,
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Note",
        onPressed: () {
          Navigator.pushNamed(context, RouteName.createNote);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
