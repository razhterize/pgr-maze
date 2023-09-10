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
  bool firstMapDetailShown = false;
  bool secondMapDetailShown = false;
  bool thirdMapDetailShown = false;
  bool selectAll = false;
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
      child: Column(
        children: [
          Row(
            children: [
              Text(member.discordUsername),
              const Spacer(),
              Text(member.discordId),
              const Spacer(),
              Text(member.name),
              const Spacer(),
              Text("${member.pgrId}"),
              const Spacer(),
              _energyDamageButton(member.firstMap, firstMapDetailShown),
              const Spacer(),
              _energyDamageButton(member.secondMap, secondMapDetailShown),
              const Spacer(),
              _energyDamageButton(member.thirdMap, thirdMapDetailShown),
            ],
          ),
        ],
      ),
    );
  }

  Widget _energyDamageButton(
      Map<String, dynamic> energyDetail, bool detailShown) {
    num total = 0;
    energyDetail.values.forEach((energyDamage) => total += energyDamage);
    return MaterialButton(
      onPressed: () {
        detailShown = !detailShown;
      },
      child: Text("$total"),
    );
  }

  Widget _energyDamageHeader() {
    return Row(
      children: [
        Checkbox(
          value: selectAll,
          onChanged: (value) {
            setState(() {
              selectAll = value!;
            });
          },
        )
      ],
    );
  }

  Widget _energyDamageDetail(Map<String, dynamic> energyDetail) {
    return Row(
      children: [
        Text(""),
      ],
    );
  }
}
