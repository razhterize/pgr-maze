import 'package:flutter/material.dart';
import 'package:scf_maze/app/models/member.dart';

class MemberRow extends StatefulWidget {
  const MemberRow({super.key, required this.member});

  final Member member;

  @override
  State<MemberRow> createState() => _MemberRowState();
}

class _MemberRowState extends State<MemberRow> {
  late Member member;
  @override
  void initState() {
    member = widget.member;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Text(member.discordUsername),
          Spacer(),
          Text(member.discordId),
          Spacer(),
          Text(member.name),
          Spacer(),
          Text("${member.pgrId}"),
        ],
      ),
    );
  }
}
