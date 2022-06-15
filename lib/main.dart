import 'package:dicoding_zuhair/core/model/note.dart';
import 'package:dicoding_zuhair/core/router/app_pages.dart';
import 'package:dicoding_zuhair/core/utils/const.dart';
import 'package:dicoding_zuhair/interface/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // hive initialiation
  await Hive.initFlutter();

  // init adapter
  Hive.registerAdapter<Note>(NoteAdapter());

  // set hive box
  await Hive.openBox<Note>(boxNote);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: AppPages.routes,
      home: const HomePage(),
    );
  }
}
