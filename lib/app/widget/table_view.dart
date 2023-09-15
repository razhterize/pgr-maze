import 'package:flutter/material.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widget/table.dart';

class TableView extends StatefulWidget {
  const TableView(
      {super.key,
      required this.guilds,
      required this.index,
      required this.filter});

  final List<Guild> guilds;
  final int index;
  final String filter;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  Member activeMember = Member.defaultValue();
  String activeMap = "first";
  late List<Guild> guilds;

  @override
  void initState() {
    guilds = widget.guilds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("${MediaQuery.of(context).size.height}x${MediaQuery.of(context).size.width}");
    return SizedBox(
      width: MediaQuery.of(context).size.width - 68,
      child: Row(
        children: [
          GuildTable(
            guilds: guilds,
            activeIndex: widget.index,
            filter: widget.filter,
            callbackFunction: _energyDamageButtonCallback,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 6, 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(children: _energyDamageDetail()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _energyDamageDetail() {
    List<Widget> widgets = [
      Center(
          child: Text(
        "${activeMember.name}\n$activeMap map",
        textAlign: TextAlign.center,
      ))
    ];
    for (int i = 0; i < activeMember.mapEnergyDamage[activeMap].length; i++) {
      widgets.add(
          _energyDamageWidget(i, activeMember.mapEnergyDamage[activeMap][i]));
    }
    return widgets;
  }

  Widget _energyDamageWidget(int day, dynamic value) {
    return ListTile(
      leading: Text("Day ${day + 1}"),
      title: TextFormField(
        decoration: const InputDecoration(
          hintText: "Energy Damage",
        ),
        initialValue: "$value",
        onChanged: (value) {
          if (value == "") value = "0";
          setState(() {
            activeMember.mapEnergyDamage[activeMap][day] = int.tryParse(value);
          });
        },
      ),
    );
  }

  void _energyDamageButtonCallback(Member selectedMember, String map) {
    activeMember = selectedMember;
    activeMap = map;
    setState(() {});
  }
}
