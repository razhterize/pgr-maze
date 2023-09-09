import 'package:flutter/material.dart';

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
      duration: Duration(milliseconds: 350),
      width: _open ? 100 : 70,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          MenuItemButton(
            onPressed: () {
              setState(() {
                _open = !_open;
              });
            },
            child: _open
                ? Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.menu),
                    ),
                    Text("Guilds")
                  ])
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.menu),
                ),
          ),
          sidebarItem(const Icon(Icons.bed_outlined), "Main"),
          sidebarItem(const Icon(Icons.alarm), "Kuru"),
          sidebarItem(const Icon(Icons.food_bank), "Crepe"),
        ],
      ),
    );
  }

  Widget sidebarItem(Icon icon, String title) {
    if (_open) {
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
