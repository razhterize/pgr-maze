import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  final Map<String, dynamic> guildIcons = {
    "turu": SvgPicture.asset("assets/slavery.svg", height: 25),
    "kuru": Image.asset("assets/kuru.gif"),
    "crepe": SvgPicture.asset("assets/crepe.svg", height: 25),
    "tensura": SvgPicture.asset("assets/slime.svg", height: 25),
    "avarice_echo": SvgPicture.asset("assets/treasure-chest.svg", height: 25),
    "arcadian": SvgPicture.asset("assets/slavery.svg", height: 25),
    "ancient_weapon": SvgPicture.asset("assets/excalibur.svg", height: 25),
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

  Widget sidebarItem(dynamic icon, String title, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20)
        ),
        child: IconButton(
            onPressed: () {
              callbackFunction(index);
            },
            icon: icon),
      ),
    );
  }

  void setActiveTable(String title) {
    return;
  }
}
