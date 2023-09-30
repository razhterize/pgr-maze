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

  final List<TextEditingController> _overcapEnergyControllers = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];

  final List<TextEditingController> _wrongNodeEnergyControllers = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];
  final List<TextEditingController> _energyPointsRatioControllers = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];

  final TextEditingController totalEnergyController = TextEditingController();
  final TextEditingController totalPointsController = TextEditingController();
  final TextEditingController ratioController = TextEditingController();

  @override
  void initState() {
    guilds = widget.guilds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: (MediaQuery.of(context).orientation == Orientation.portrait)
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
          flex: 2,
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
    totalEnergyController.text =
        "${activeMember.mapData[activeMap]['energy_spent']}";
    totalPointsController.text = "${activeMember.mapData[activeMap]['points']}";
    ratioController.text = (activeMember.mapData[activeMap]['points'] != 0 ||
            activeMember.mapData[activeMap]['energy_spent'] != 0)
        ? "${activeMember.mapData[activeMap]['points'] / activeMember.mapData[activeMap]['energy_spent']}"
        : "0";
    List<Widget> widgets = [
      Center(
          child: Text(
        "Energy Damage Detail\n${activeMember.name}\n$activeMap Week",
        textAlign: TextAlign.center,
      )),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: TextField(
                decoration: InputDecoration(
                  label: Text("Total Energy Spent"),
                ),
                controller: totalEnergyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (value) {
                  if (value == "") value = "0";
                  setState(() {
                    activeMember.mapData[activeMap]['energy_spent'] =
                        int.tryParse(value);
                  });
                  activeMember.update(widget.pb);
                  ratioController
                      .text = (activeMember.mapData[activeMap]['points'] != 0 ||
                          activeMember.mapData[activeMap]['energy_spent'] != 0)
                      ? "${activeMember.mapData[activeMap]['points'] / activeMember.mapData[activeMap]['energy_spent']}"
                      : "0";
                },
                onTapOutside: (event) {
                  if (totalEnergyController.text == "")
                    totalEnergyController.text = "0";
                  setState(() {
                    activeMember.mapData[activeMap]["energy_spent"] =
                        int.tryParse(totalEnergyController.text);
                  });
                  activeMember.update(widget.pb);
                  ratioController
                      .text = (activeMember.mapData[activeMap]['points'] != 0 ||
                          activeMember.mapData[activeMap]['energy_spent'] != 0)
                      ? "${activeMember.mapData[activeMap]['points'] / activeMember.mapData[activeMap]['energy_spent']}"
                      : "0";
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: TextField(
                decoration: InputDecoration(
                  label: Text("Points"),
                ),
                controller: totalPointsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (value) {
                  if (value == "") value = "0";
                  setState(() {
                    activeMember.mapData[activeMap]['points'] =
                        int.tryParse(value);
                  });
                  ratioController
                      .text = (activeMember.mapData[activeMap]['points'] != 0 ||
                          activeMember.mapData[activeMap]['energy_spent'] != 0)
                      ? "${activeMember.mapData[activeMap]['points'] / activeMember.mapData[activeMap]['energy_spent']}"
                      : "0";
                  activeMember.update(widget.pb);
                },
                onTapOutside: (event) {
                  if (totalPointsController.text == "")
                    totalPointsController.text = "0";
                  setState(() {
                    activeMember.mapData[activeMap]['points'] =
                        int.tryParse(totalPointsController.text);
                    ratioController.text = (activeMember.mapData[activeMap]
                                    ['points'] !=
                                0 ||
                            activeMember.mapData[activeMap]['energy_spent'] !=
                                0)
                        ? "${activeMember.mapData[activeMap]['points'] / activeMember.mapData[activeMap]['energy_spent']}"
                        : "0";
                  });
                  activeMember.update(widget.pb);
                },
              ),
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(label: Text("Energy Ratio")),
              enabled: false,
              controller: ratioController,
            ),
          )
        ],
      ),
    ];
    for (int i = 0;
        i < activeMember.mapData[activeMap]["overcap"].length;
        i++) {
      _overcapEnergyControllers[i].text =
          "${activeMember.mapData[activeMap]['overcap'][i]}";
      _wrongNodeEnergyControllers[i].text =
          "${activeMember.mapData[activeMap]['wrong_node'][i]}";
      widgets.add(energyDamageWidget(i));
    }
    return widgets;
  }

  Widget energyDamageWidget(int day) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text("Day ${day + 1}"),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              child: TextField(
                decoration: const InputDecoration(
                  label: Text("Energy Overcap"),
                ),
                controller: _overcapEnergyControllers[day],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (value) {
                  if (value == "") value = "0";
                  setState(() {
                    activeMember.mapData[activeMap]["overcap"][day] =
                        int.tryParse(value);
                  });
                  activeMember.update(widget.pb);
                },
                onTapOutside: (event) {
                  if (_overcapEnergyControllers[day].text == "")
                    _overcapEnergyControllers[day].text = "0";
                  setState(() {
                    activeMember.mapData[activeMap]["overcap"][day] =
                        int.tryParse(_overcapEnergyControllers[day].text);
                  });
                  activeMember.update(widget.pb);
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              child: TextField(
                decoration: const InputDecoration(
                  label: Text("Wrong Node"),
                ),
                controller: _wrongNodeEnergyControllers[day],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (value) {
                  if (value == "") value = "0";
                  setState(() {
                    activeMember.mapData[activeMap]["wrong_node"][day] =
                        int.tryParse(value);
                  });
                  activeMember.update(widget.pb);
                },
                onTapOutside: (event) {
                  if (_wrongNodeEnergyControllers[day].text == "")
                    _wrongNodeEnergyControllers[day].text = "0";
                  setState(() {
                    activeMember.mapData[activeMap]["wrong_node"][day] =
                        int.tryParse(_wrongNodeEnergyControllers[day].text);
                  });
                  activeMember.update(widget.pb);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void energyDamageButtonCallback(Member selectedMember, String map) {
    setState(() {
      activeMember = selectedMember;
      activeMap = map;
    });
    for (int i = 0; i < 10; i++) {
      _overcapEnergyControllers[i].text =
          selectedMember.mapData[map][i].toString();
    }
  }
}
