import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar(
      {super.key, required this.managedGuilds, required this.callbackFunction});

  final List<dynamic> managedGuilds;
  final Function(int) callbackFunction;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // Turu: Whip
  // Kuru: Herta spinning
  // Crepe: wellp, crepe
  // Tensura: slime
  // Ancient Weapon: rusted sword
  // Arcad: TBA
  // Avarie Echo: TBA

  late List<dynamic> managedGuilds;
  late Function(int) callbackFunction;

  final Map<String, IconData> guildIcons = {
    "turu": Icons.bed,
    "kuru": Icons.spoke_outlined,
    "crepe": Icons.food_bank,
    "tensura": Icons.animation_outlined,
    "avarice_echo": Icons.money_sharp,
    "arcadian": Icons.abc,
    "ancient_weapon": Icons.abc
  };

  @override
  void initState() {
    managedGuilds = widget.managedGuilds;
    callbackFunction = widget.callbackFunction;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: 50,
          child: Column(
            children: _guildSwitcher(),
          ),
        ),
      ),
    );
  }

  List<Widget> _guildSwitcher() {
    List<Widget> items = [];
    for (int i = 0; i < managedGuilds.length; i++) {
      String guild = managedGuilds[i];
      items.add(sidebarItem(guildIcons[guild]!, guild, i));
    }
    return items;
  }

  Widget sidebarItem(IconData icon, String title, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
      child: MaterialButton(
          onPressed: () {
            callbackFunction(index);
          },
          child: Icon(
            icon,
            color: Colors.white,
          )),
    );
  }

  void setActiveTable(String title) {
    return;
  }
}
