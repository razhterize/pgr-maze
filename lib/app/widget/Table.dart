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
  late List<Guild> _guilds;

  bool selectAll = false;

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
              rowCount: _guilds[widget.activeIndex]
                  .filterByName(widget.filter)
                  .length,
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
      return IconButton(
          onPressed: () => _openEditMember(context, member),
          icon: const Center(child: Icon(Icons.edit_square)));
    }
  }

  void _openEditMember(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: _editMemberContent(context, member),
          actions: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
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
                              _guilds[widget.activeIndex]
                                  .members
                                  .remove(member);
                              member.delete(_guilds[widget.activeIndex].pb);
                              Navigator.pop(context);
                            },
                            child: const Text("DELETE")),
                      ],
                    );
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
                  member.update(_guilds.first.pb);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saving...')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {
        _guilds[widget.activeIndex].getAll();
      });
      {}
      ;
    });
  }

  Widget _editMemberContent(BuildContext context, Member member) {
    TextEditingController name = TextEditingController(text: member.name);
    TextEditingController pgrId =
        TextEditingController(text: "${member.pgrId}");
    TextEditingController discordId =
        TextEditingController(text: member.discordId);
    TextEditingController discordUsername =
        TextEditingController(text: member.discordUsername);
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
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) => member.name = value,
                onTapOutside: (event) => member.name = name.text,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("PGR ID")),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: pgrId,
                validator: (value) {
                  if (value == null || value.isEmpty || value == "0") {
                    return 'PGR ID cannot be empty or 0';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value == "" || value.isEmpty) value = "0";
                  member.pgrId = int.tryParse(value) as int;
                },
                onTapOutside: (event) {
                  if (pgrId.text == "" || pgrId.text.isEmpty) pgrId.text = "0";
                  member.pgrId = int.tryParse(pgrId.text) as int;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Discord Username")),
                controller: discordUsername,
                onChanged: (value) => member.discordUsername = value,
                onTapOutside: (event) =>
                    member.discordUsername = discordUsername.text,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Discord ID")),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: discordId,
                onChanged: (value) => member.discordId = value,
                onTapOutside: (event) => member.discordId = discordId.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
