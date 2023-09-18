import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/member.dart';

class Guild {
  late PocketBase _pb;
  late RecordService _collection;
  late String name;
  Function? stateChange;
  List<Member> members = [];
  int totalMembers = 0;

  Guild(PocketBase pb, String collection, Function? stateChangeCallback) {
    _pb = pb;
    _collection = _pb.collection(collection);
    stateChange = stateChangeCallback;
    name = collection;
    getAll();
    debugPrint("New Instance of $collection");
  }

  Future<void> getAll({String filter = ""}) async {
    List<RecordModel>? data = await _collection.getFullList(filter: filter);
    for (var record in data) {
      members.add(Member(record));
    }
    totalMembers = members.length;
    pb.collection(name).subscribe("*", (e) => updateFromRealtime(e.action, e.record!));
    stateChange!();
  }

  Future<void> sendToDatabase() async {
    for (var member in members) {
      await member.existInDatabase(_pb)
          ? member.update(_pb)
          : member.createInDatabase(_pb);
    }
  }

  void updateFromRealtime(String action, RecordModel record) {
    switch (action) {
      case "update":
        members[members.indexWhere((element) => element.id == record.id)] =
            Member(record);
        break;
      case "create":
        members.add(Member(record));
        break;
      case "delete":
        members.removeWhere((element) => element.id == record.id);
        break;
    }
    stateChange!();
  }

  PocketBase get pb => _pb;

  List<Member> getMembers() => members;
  void addMember(Member member) => members.add(member);

  List<Member> filterByName(String name) => members
      .where((member) => member.name.toLowerCase().contains(name.toLowerCase()))
      .toList();

  List<Member> filterById(String id) =>
      members.where((member) => ("${member.pgrId}").contains(id)).toList();
}
