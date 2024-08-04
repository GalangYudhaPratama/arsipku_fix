import 'package:flutter/material.dart';
import 'package:arsipku/screens/book-input.dart';
import 'package:provider/provider.dart';

import 'package:arsipku/screens/home-page.dart';
import 'package:arsipku/providers/booklist_provider.dart';
import 'package:arsipku/providers/setting_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookListProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
      ],
      child: MaterialApp(
        title: 'Perpus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        routes: {
          BookInputScreen.routeName: (ctx) => BookInputScreen(),
        },
      ),
    );
  }
}
