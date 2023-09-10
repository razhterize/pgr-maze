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
  List<double> columnWidth = [
    30,
    100,
    100,
    200,
    100,
    100,
    100,
    150,
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
            columns: columnWidth
                .map((e) => TableColumn(width: maxWidth / 9))
                .toList(),
            rowBuilder: (context, row, contentBuilder) {
              if (row == 0) {
                return InkWell(
                  child: contentBuilder(context, (context, column) {
                    return Text(
                      headers[column],
                      textAlign: TextAlign.center,
                    );
                  }),
                );
              }
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
        "$rowIndex",
        textAlign: TextAlign.center,
      );
    }
  }
}
