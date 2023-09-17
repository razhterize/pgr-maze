import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _editMemberControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  late List<Guild> _guilds;

  bool selectAll = false;
  bool ascending = false;
  int lastSortIndex = 0;

  List<String> headers = [
    "Action",
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
              rowCount: _rowCountOnSort(),
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
                    onTap: () {
                      sortMembers(column);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Align(
                        alignment: Alignment.center,
                        child: (column == 0)
                            ? Checkbox(
                                value: selectAll,
                                onChanged: (value) {
                                  for (var member
                                      in _guilds[widget.activeIndex]
                                          .members) {
                                    member.selected = value!;
                                  }
                                  setState(() {
                                    selectAll = value!;
                                  });
                                },
                              )
                            : _headerContent(column),
                      ),
                    ),
                  ),
                ),
              ),
              rowBuilder: (context, row, contentBuilder) {
                return Container(
                  // color: row.isOdd ? Colors.white24 : Colors.white10,
                  decoration: const BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(color: Colors.white))),
                  child: InkWell(
                    child: contentBuilder(
                      context,
                      (context, column) {
                        if (widget.filter.startsWith("name;")) {
                          return Center(
                            child: _columnContent(
                                row,
                                column,
                                _guilds[widget.activeIndex].filterByName(
                                    widget.filter.replaceAll("name;", ""))[row]),
                          );
                        } else if (widget.filter.startsWith("id;")) {
                          return Center(
                            child: _columnContent(
                                row,
                                column,
                                _guilds[widget.activeIndex].filterById(
                                    widget.filter.replaceAll("id;", ""))[row]),
                          );
                        } else {
                          return Center(
                            child: _columnContent(row, column,
                                _guilds[widget.activeIndex].members[row]),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  int _rowCountOnSort() {
    debugPrint(widget.filter);
    if (widget.filter.startsWith("name;")) {
      return _guilds[widget.activeIndex]
          .filterByName(widget.filter.replaceAll("name;", ""))
          .length;
    } else {
      return _guilds[widget.activeIndex]
          .filterById(widget.filter.replaceAll("id;", ""))
          .length;
    }
  }

  Widget _headerContent(int column) {
    if (column == lastSortIndex && [2, 3, 8].contains(column)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ascending ? const Icon(Icons.arrow_downward) : const Icon(Icons.arrow_upward),
          Text(headers[column - 1])
        ],
      );
    }
    return Text(headers[column - 1]);
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
      );
    } else if (columnIndex == 3) {
      return Text(
        "${member.pgrId}",
      );
    } else if (columnIndex == 4) {
      return Text(
        member.discordUsername,
      );
    } else if (columnIndex == 5) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.white12,
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
          color: Colors.white24,
          child: MaterialButton(
            onPressed: () {
              widget.callbackFunction(member, "second");
            },
            child: Text(
              "${member.energyDamagePerMap("second")}",
            ),
          ),
        ),
      );
    } else if (columnIndex == 7) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.white30,
          child: MaterialButton(
            onPressed: () {
              widget.callbackFunction(member, "third");
            },
            child: Text(
              "${member.energyDamagePerMap("third")}",
            ),
          ),
        ),
      );
    } else if (columnIndex == 8) {
      return Text(
        "${member.energyDamagePerMap("first") + member.energyDamagePerMap("second") + member.energyDamagePerMap("third")}",
      );
    } else {
      return IconButton(
          onPressed: () => _openEditMember(context, member),
          icon: const Icon(Icons.edit_square));
    }
  }

  void _openEditMember(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: editMemberContent(context, member),
          actions: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return deleteMemberDialog(member, context);
                  },
                ).then((value) => Navigator.pop(context)).then((value) {
                  setState(() {});
                });
              },
              child: const Text("Delete Member"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  member.name = _editMemberControllers[0].text;
                  member.pgrId =
                      int.tryParse(_editMemberControllers[1].text) as int;
                  member.discordUsername = _editMemberControllers[2].text;
                  member.discordId = _editMemberControllers[3].text;
                  member.update(_guilds.first.pb);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saving...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  AlertDialog deleteMemberDialog(Member member, BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Member"),
      content: Text(
          "Are you sure to delete ${member.name} from ${member.collectionName.replaceAll('_', ' ')}"),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL")),
        ElevatedButton(
            onPressed: () {
              _guilds[widget.activeIndex].members.remove(member);
              member.delete(_guilds[widget.activeIndex].pb);
              Navigator.pop(context);
            },
            child: const Text("DELETE")),
      ],
    );
  }

  Widget editMemberContent(BuildContext context, Member member) {
    _editMemberControllers[0].text = member.name;
    _editMemberControllers[1].text = "${member.pgrId}";
    _editMemberControllers[2].text = member.discordUsername;
    _editMemberControllers[3].text = member.discordId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Name")),
                controller: _editMemberControllers[0],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("PGR ID")),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _editMemberControllers[1],
                validator: (value) {
                  if (value == null || value.isEmpty || value == "0") {
                    return 'PGR ID cannot be empty or 0';
                  }
                  if (value.length != 8) {
                    return "PGR ID must be 8 digits long";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Discord Username")),
                controller: _editMemberControllers[2],
              ),
              TextFormField(
                  decoration: const InputDecoration(label: Text("Discord ID")),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _editMemberControllers[3]),
            ],
          ),
        ),
      ),
    );
  }

  void sortMembers(int columnIndex) {
    if ((lastSortIndex != columnIndex && !ascending) ||
        (lastSortIndex == columnIndex && !ascending) ||
        (lastSortIndex != columnIndex)) {
      ascending = true;
      debugPrint(
          "Current Index: $columnIndex, Last Index: $lastSortIndex, Ascending: $ascending");
      switch (columnIndex) {
        case 2:
          _guilds[widget.activeIndex].members.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          break;
        case 3:
          _guilds[widget.activeIndex]
              .members
              .sort((a, b) => a.pgrId.compareTo(b.pgrId));
          break;
        case 8:
          _guilds[widget.activeIndex].members.sort(
                (a, b) => a.totalDamage.compareTo(b.totalDamage),
              );
          break;
      }
    } else if (lastSortIndex == columnIndex && ascending) {
      ascending = false;
      debugPrint(
          "Current Index: $columnIndex, Last Index: $lastSortIndex, Ascending: $ascending");
      switch (columnIndex) {
        case 2:
          _guilds[widget.activeIndex].members.sort(
              (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
          break;
        case 3:
          _guilds[widget.activeIndex]
              .members
              .sort((a, b) => b.pgrId.compareTo(a.pgrId));
          break;
        case 8:
          _guilds[widget.activeIndex]
              .members
              .sort((a, b) => b.totalDamage.compareTo(a.totalDamage));
          break;
      }
    }
    lastSortIndex = columnIndex;
    setState(() {});
  }
}
