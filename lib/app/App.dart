import 'package:flutter/material.dart';
import 'widget/Sidebar.dart';
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            Sidebar(),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: const Expanded(
                child: Row(
                  children: [Text("Data")],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
