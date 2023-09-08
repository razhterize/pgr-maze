import 'package:flutter/material.dart';

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
            SizedBox(
              width: sidebarOpen ? 100 : 70,
              child: _sidebar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  sidebarOpen = !sidebarOpen;
                });
              },
              child: sidebarOpen
                  ? Column(
                      children: [Icon(Icons.menu), Text("Guilds")],
                    )
                  : Icon(Icons.menu),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sidebarItem(Icon(Icons.bed_outlined), "Main"),
                sidebarItem(Icon(Icons.alarm), "Kuru"),
                sidebarItem(Icon(Icons.food_bank), "Crepe"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sidebarItem(Icon icon, String title) {
    if (sidebarOpen) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon, Text(title)],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      );
    }
  }
}
