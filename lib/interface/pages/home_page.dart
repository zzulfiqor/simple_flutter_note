import 'package:dicoding_zuhair/core/model/note.dart';
import 'package:dicoding_zuhair/core/router/route_name.dart';
import 'package:dicoding_zuhair/core/utils/const.dart';
import 'package:dicoding_zuhair/interface/pages/widget/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortNewest = true;
  bool _useGrid = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filteredNotes(Box<Note> box) {
    final query = _searchController.text.toLowerCase();
    final notes = List<Map<String, dynamic>>.generate(
      box.length,
      (index) {
        final note = box.getAt(index) as Note;
        return {
          "note": note,
          "index": index,
        };
      },
    );

    final filtered = query.isEmpty
        ? notes
        : notes.where((item) {
            final note = item["note"] as Note;
            final title = note.title?.toLowerCase() ?? "";
            final content = note.content?.toLowerCase() ?? "";
            return title.contains(query) || content.contains(query);
          }).toList();

    filtered.sort((a, b) {
      final noteA = a["note"] as Note;
      final noteB = b["note"] as Note;
      final timeA = noteA.timeCreated ?? 0;
      final timeB = noteB.timeCreated ?? 0;
      return _sortNewest ? timeB.compareTo(timeA) : timeA.compareTo(timeB);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZuNotes'),
        actions: [
          IconButton(
            tooltip: _useGrid ? "Switch to list" : "Switch to grid",
            onPressed: () {
              setState(() {
                _useGrid = !_useGrid;
              });
            },
            icon: Icon(_useGrid ? Icons.view_agenda_outlined : Icons.grid_view),
          ),
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
          builder: (ctx, Box<Note> box, _) {
            final notes = _filteredNotes(box);
            final isEmpty = notes.isEmpty;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search notes",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: "Clear",
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("Newest"),
                        selected: _sortNewest,
                        onSelected: (val) {
                          setState(() {
                            _sortNewest = true;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text("Oldest"),
                        selected: !_sortNewest,
                        onSelected: (val) {
                          setState(() {
                            _sortNewest = false;
                          });
                        },
                      ),
                      const Spacer(),
                      Text(
                        "${notes.length} notes",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.sticky_note_2_outlined,
                                  size: 64,
                                  color: Colors.black45,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "No notes yet",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text("Tap + to create your first note."),
                              ],
                            ),
                          )
                        : _useGrid
                            ? MasonryGridView.count(
                                padding: EdgeInsets.zero,
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                itemCount: notes.length,
                                itemBuilder: (ctx, index) {
                                  final note =
                                      notes[index]["note"] as Note;
                                  final noteIndex =
                                      notes[index]["index"] as int;
                                  return NoteCard(
                                    color: colorFromHex(note.colorHex!)!,
                                    title: note.title ?? "",
                                    content: note.content ?? "",
                                    timeCreated: note.timeCreated,
                                    context_: context,
                                    index: noteIndex,
                                  );
                                },
                              )
                            : ListView.separated(
                                itemCount: notes.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (ctx, index) {
                                  final note =
                                      notes[index]["note"] as Note;
                                  final noteIndex =
                                      notes[index]["index"] as int;
                                  return NoteCard(
                                    color: colorFromHex(note.colorHex!)!,
                                    title: note.title ?? "",
                                    content: note.content ?? "",
                                    timeCreated: note.timeCreated,
                                    context_: context,
                                    index: noteIndex,
                                  );
                                },
                              ),
                  ),
                ],
              ),
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
