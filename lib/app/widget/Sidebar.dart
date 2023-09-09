import 'dart:html';

import 'package:flutter/material.dart';
import 'package:scf_maze/app/widget/Hover.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: _open ? 100 : 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  _open = !_open;
                });
              },
              hoverColor: Colors.blue,
              child: _open
                  ? const Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.menu),
                      ),
                      Text("Guilds")
                    ])
                  : const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.menu),
                    ),
            ),
            sidebarItem(Icons.bed_outlined, "Main"),
            sidebarItem(Icons.alarm, "Kuru"),
            sidebarItem(Icons.food_bank, "Crepe"),
          ],
        ),
      ),
    );
  }

  Widget sidebarItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
          message: title,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.black)),
          // height: 50,
          // padding: const EdgeInsets.all(8.0),
          textStyle: const TextStyle(
            fontSize: 12,
          ),
          showDuration: const Duration(seconds: 3),
          waitDuration: const Duration(milliseconds: 100),
          child: MaterialButton(
              onPressed: () {
                setActiveTable(title);
              },
              child: Icon(
                icon,
                color: Colors.black,
              ))),
    );
  }

  Widget showTooltip(String title) {
    return Tooltip(
      message: title,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      // height: 50,
      // padding: const EdgeInsets.all(8.0),
      preferBelow: true,
      textStyle: const TextStyle(
        fontSize: 12,
      ),
      showDuration: const Duration(seconds: 3),
      waitDuration: const Duration(milliseconds: 100),
      child: const Text('Tap this text and hold down to show a tooltip.'),
    );
  }

  void setActiveTable(String title) {
    return;
  }
}
