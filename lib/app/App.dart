import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/widget/table.dart';
import 'widget/sidebar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final PocketBase pb = PocketBase("http://127.0.0.1:1111");
  bool sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            const Sidebar(),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: MemberTable(guild: "kuru", pb: pb))
          ],
        ),
      ),
    );
  }
}
