import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';

class GuildTable extends StatefulWidget {
  const GuildTable({super.key, required this.pb, required this.guild});

  final PocketBase pb;
  final String guild;

  @override
  State<GuildTable> createState() => _GuildTableState();
}

class _GuildTableState extends State<GuildTable> {
  late Guild _guild;

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
    _guild = Guild(widget.pb, widget.guild);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 15, 8),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlueAccent),
              borderRadius: BorderRadius.circular(10)),
          child: TableView.builder(
            rowCount: 80,
            rowHeight: 32,
            columns: [
              for (int i = 0; i < 8; i++) TableColumn(width: maxWidth / 9)
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
                      child: Text(headers[column]),
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
                    return _columnContent(row, column, Member.defaultValue());
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _columnContent(int rowIndex, int columnIndex, Member member) {
    if (columnIndex == 1) {
      return Text(
        member.name,
        textAlign: TextAlign.center,
      );
    } else if (columnIndex == 2) {
      return Text(
        "${member.pgrId}",
        textAlign: TextAlign.center,
      );
    } else if (columnIndex == 3) {
      return Text(
        member.discordUsername,
        textAlign: TextAlign.center,
      );
    } else if (columnIndex == 4) {
      return MaterialButton(
        onPressed: () {},
        child: Text(
          "${member.firstMapEnergyDamage()}",
          textAlign: TextAlign.center,
        ),
      );
    } else if (columnIndex == 5) {
      return MaterialButton(
        onPressed: () {},
        child: Text(
          "${member.secondMapEnergyDamage()}",
          textAlign: TextAlign.center,
        ),
      );
    } else if (columnIndex == 6) {
      return MaterialButton(
        onPressed: () {},
        child: Text(
          "${member.thirdMapEnergyDamage()}",
          textAlign: TextAlign.center,
        ),
      );
    } else if (columnIndex == 7) {
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
