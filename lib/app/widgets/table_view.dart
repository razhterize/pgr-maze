import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widgets/table.dart';

class TableView extends StatefulWidget {
  const TableView(
      {super.key,
      required this.guilds,
      required this.index,
      required this.filter,
      required this.pb});

  final List<Guild> guilds;
  final int index;
  final String filter;
  final PocketBase pb;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final key = GlobalKey<FormState>();
  late List<Guild> guilds;

  Member activeMember = Member.defaultValue();
  String activeMap = "first";

  final List<TextEditingController> _energyDamageControllers = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];

  @override
  void initState() {
    guilds = widget.guilds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: (Platform.isAndroid || Platform.isIOS)
          ? mobileLayout()
          : desktopLayout(),
    );
  }

  Row desktopLayout() {
    return Row(
      children: [
        GuildTable(
          guilds: guilds,
          activeIndex: widget.index,
          filter: widget.filter,
          callbackFunction: energyDamageButtonCallback,
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
              child: ListView(children: energyDamageDetail()),
            ),
          ),
        ),
      ],
    );
  }

  Column mobileLayout() {
    return Column(
      children: [
        GuildTable(
          guilds: guilds,
          activeIndex: widget.index,
          filter: widget.filter,
          callbackFunction: energyDamageButtonCallback,
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 6, 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView(children: energyDamageDetail()),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> energyDamageDetail() {
    List<Widget> widgets = [
      Center(
          child: Text(
        "Energy Damage Detail\n${activeMember.name}\n$activeMap map",
        textAlign: TextAlign.center,
      ))
    ];
    for (int i = 0; i < activeMember.mapEnergyDamage[activeMap].length; i++) {
      widgets.add(
          energyDamageWidget(i, activeMember.mapEnergyDamage[activeMap][i]));
    }
    return widgets;
  }

  Widget energyDamageWidget(int day, dynamic value) {
    return ListTile(
      leading: Text("Day ${day + 1}"),
      title: TextField(
        decoration: const InputDecoration(
          hintText: "Energy Damage",
        ),
        controller: _energyDamageControllers[day],
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value == "") value = "0";
          setState(() {
            activeMember.mapEnergyDamage[activeMap][day] = int.tryParse(value);
          });
          activeMember.update(widget.pb);
        },
      ),
    );
  }

  void energyDamageButtonCallback(Member selectedMember, String map) {
    setState(() {
      activeMember = selectedMember;
      activeMap = map;
    });
    for (int i = 0; i < 10; i++) {
      _energyDamageControllers[i].text =
          selectedMember.mapEnergyDamage[map][i].toString();
    }
  }
}
