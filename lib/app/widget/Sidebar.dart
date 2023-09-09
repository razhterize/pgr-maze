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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: _open ? 100 : 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlueAccent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          sidebarItem(Icons.bed_outlined, "Main"),
          sidebarItem(Icons.alarm, "Kuru"),
          sidebarItem(Icons.food_bank, "Crepe"),
          Spacer(),
          sidebarItem(Icons.settings, "Settings")
        ],
      ),
    );
  }

  Widget sidebarItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
      child: MaterialButton(
          onPressed: () {
            setActiveTable(title);
          },
          child: Icon(
            icon,
            color: Colors.black,
          )),
    );
  }

  void setActiveTable(String title) {
    return;
  }
}
