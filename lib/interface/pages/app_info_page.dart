import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: const Text('App Information'),
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            // Icon
            SizedBox(
              height: 24,
            ),
            Icon(
              Icons.note_alt,
              size: 50,
              color: Colors.blueGrey,
            ),

            // title
            SizedBox(height: 24),
            Text(
              'ZuNotes',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // version
            SizedBox(height: 24),

            Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            // description
            SizedBox(height: 24),
            Text(
              'ZuNotes is a simple note app that is built with Flutter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            // author
            SizedBox(height: 24),

            Text("Author: Ahmad Zuhair Dzulfiqor"),
          ],
        ),
      ),
    );
  }
}
