import 'package:flutter/material.dart';

import 'shows_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Broadway Shows', home: ShowsPage());
  }
}
