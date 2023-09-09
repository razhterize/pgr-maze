import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/guild.dart';

class MemberTable extends StatefulWidget {
  const MemberTable({super.key, required this.pb, required this.guild});

  final String guild;
  final PocketBase pb;

  @override
  State<MemberTable> createState() => MemberTableState();
}

class MemberTableState extends State<MemberTable> {
  Guild? _guild;

  @override
  void initState() {
    _guild = Guild(widget.pb, widget.guild);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          onPressed: () {
            _guild!.getAll();
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
