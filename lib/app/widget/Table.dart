import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widget/member_row.dart';

class MemberTable extends StatefulWidget {
  const MemberTable({super.key, required this.pb, required this.guild});

  final String guild;
  final PocketBase pb;

  @override
  State<MemberTable> createState() => MemberTableState();
}

class MemberTableState extends State<MemberTable> {
  late Guild _guild;

  @override
  void initState() {
    _guild = Guild(widget.pb, widget.guild);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 15, 4),
                  child: _headers(),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 15, 4),
                child: MemberRow(member: Member.defaultValue()),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _headers() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Column(
        children: [ 
          Row(
            children: [
              Text("Discord Username"),
              Spacer(),
              Text("Discord ID"),
              Spacer(),
              Text("Name"),
              Spacer(),
              Text("PGR ID"),
              Spacer(),
              Column(
                children: [
                  Text("Map"),
                  Row(
                    children: [
                      Text("First Map"),
                      Text("Second Map"),
                      Text("Third Map"),
                    ],
                  )
                ],
              ),
              Text("Total Energy Damage")
            ],
          ),
        ],
      ),
    );
  }
}
