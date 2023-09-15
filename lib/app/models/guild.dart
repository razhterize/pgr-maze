import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/member.dart';

class Guild {
  late PocketBase _pb;
  late RecordService _collection;
  late String name;
  List<Member> members = [];
  int totalMembers = 0;

  Guild(PocketBase pb, String collection) {
    _pb = pb;
    _collection = _pb.collection(collection);
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
  }

  Future<void> sendToDatabase() async {
    for (var member in members) {
      await member.existInDatabase(_pb)
          ? member.update(_pb)
          : member.createInDatabase(_pb);
    }
  }

  List<Member> getMembers() => members;
  void addMember(Member member) => members.add(member);

  List<Member> filterByName(String name) => members
      .where((member) => member.name.toLowerCase().contains(name.toLowerCase()))
      .toList();

  List<Member> filterById(int id) => members
      .where((member) => (member.pgrId as String).contains(id as String))
      .toList();
}
