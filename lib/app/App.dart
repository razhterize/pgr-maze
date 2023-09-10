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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Row(
          children: [
            const Sidebar(),
            GuildTable(guild: "kuru", pb: pb)
          ],
        ),
      ),
    );
  }
}
