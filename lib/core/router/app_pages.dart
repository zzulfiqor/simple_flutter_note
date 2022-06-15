import 'package:dicoding_zuhair/core/router/route_name.dart';
import 'package:flutter/material.dart';

import '../../interface/pages/app_info_page.dart';
import '../../interface/pages/create_note_page.dart';
import '../../interface/pages/home_page.dart';

class AppPages {
  static final routes = <String, WidgetBuilder>{
    RouteName.home: (BuildContext context) => const HomePage(),
    RouteName.appInfo: (BuildContext context) => const AppInfoPage(),
    RouteName.createNote: (BuildContext context) => CreateNotePage(),
    RouteName.editNote: (BuildContext context) => CreateNotePage(
          isEdit: true,
        ),
  };
}
