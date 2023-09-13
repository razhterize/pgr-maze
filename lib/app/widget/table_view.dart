import 'package:flutter/material.dart';
import 'package:scf_maze/app/models/guild.dart';
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
      child: Column(
        children: [
          GuildTable(
            guilds: guilds,
            activeIndex: widget.index,
            filter: widget.filter,
          ),
        ],
      ),
    );
  }
}
