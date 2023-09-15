import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';

class GuildTable extends StatefulWidget {
  const GuildTable(
      {super.key,
      required this.guilds,
      required this.activeIndex,
      required this.filter,
      required this.callbackFunction});

  final List<Guild> guilds;
  final int activeIndex;
  final String filter;
  final Function(Member, String) callbackFunction;

  @override
  State<GuildTable> createState() => _GuildTableState();
}

class _GuildTableState extends State<GuildTable> {
  late List<Guild> _guilds;

  bool selectAll = false;

  List<String> headers = [
    "No",
    "Name",
    "PGR ID",
    "Discord Username",
    "First Map",
    "Second Map",
    "Third Map",
    "Total Damage",
  ];
  @override
  void initState() {
    _guilds = widget.guilds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Filter: ${widget.filter}");
    debugPrint("Current Table: ${_guilds[widget.activeIndex].name}");
    double maxWidth = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlueAccent),
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: maxWidth,
            child: TableView.builder(
              rowCount: _guilds[widget.activeIndex].filterByName(widget.filter).length,
              rowHeight: 32,
              columns: [
                TableColumn(width: maxWidth / 20),
                TableColumn(width: maxWidth / 20),
                TableColumn(width: maxWidth / 10),
                TableColumn(width: maxWidth / 10),
                TableColumn(width: maxWidth / 8),
                TableColumn(width: maxWidth / 13),
                TableColumn(width: maxWidth / 13),
                TableColumn(width: maxWidth / 13),
                TableColumn(width: maxWidth / 10),
              ],
              headerBuilder: (context, contentBuilder) => contentBuilder(
                context,
                (context, column) => Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Align(
                        alignment: Alignment.center,
                        child: (column == 0)
                            ? Checkbox(
                                value: selectAll,
                                onChanged: (value) {
                                  for (var member
                                      in _guilds[widget.activeIndex].members) {
                                    member.selected = value!;
                                  }
                                  setState(() {
                                    selectAll = value!;
                                  });
                                },
                              )
                            : Text(headers[column - 1]),
                      ),
                    ),
                  ),
                ),
              ),
              rowBuilder: (context, row, contentBuilder) {
                return InkWell(
                  child: contentBuilder(
                    context,
                    (context, column) {
                      if (widget.filter == "") {
                        return _columnContent(
                          row,
                          column,
                          _guilds[widget.activeIndex].members[row],
                        );
                      } else {
                        return _columnContent(
                            row,
                            column,
                            _guilds[widget.activeIndex]
                                .filterByName(widget.filter)[row]);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _columnContent(int rowIndex, int columnIndex, Member member) {
    if (columnIndex == 0) {
      return Checkbox(
        value: member.selected,
        onChanged: (value) {
          setState(() {
            member.selected = value!;
          });
        },
      );
    } else if (columnIndex == 2) {
      return Text(
        member.name,
        textAlign: TextAlign.center,
      );
    } else if (columnIndex == 3) {
      return Text(
        "${member.pgrId}",
        textAlign: TextAlign.center,
      );
    } else if (columnIndex == 4) {
      return Text(
        member.discordUsername,
        textAlign: TextAlign.center,
      );
    } else if (columnIndex == 5) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.lightBlue,
          child: MaterialButton(
            onPressed: () {
              widget.callbackFunction(member, "first");
            },
            child: Text(
              "${member.energyDamagePerMap("first")}",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else if (columnIndex == 6) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.lightBlue,
          child: MaterialButton(
            onPressed: () {
              widget.callbackFunction(member, "second");
            },
            child: Text(
              "${member.energyDamagePerMap("second")}",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else if (columnIndex == 7) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.lightBlue,
          child: MaterialButton(
            onPressed: () {
              widget.callbackFunction(member, "third");
            },
            child: Text(
              "${member.energyDamagePerMap("third")}",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else if (columnIndex == 8) {
      return Text(
        "${member.totalEnergyDamage}",
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        "${rowIndex + 1}",
        textAlign: TextAlign.center,
      );
    }
  }
}
