import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/member.dart';

class Guild {
  PocketBase? _pb;
  RecordService? _collection;
  late String name;
  List<Member> members = [];
  int totalMembers = 0;

  Guild(PocketBase pb, String collection) {
    _pb = pb;
    _collection = _pb?.collection(collection);
    name = collection;
    getAll();
    debugPrint("New Instance of $collection");
  }

  Future<void> getAll({String filter = ""}) async {

    List<RecordModel>? data = await _collection?.getFullList(filter: filter);
    data?.forEach((record) {
      members.add(Member(record));
    });
    totalMembers = members.length;
  }

  Future<void> syncWithDatabase() async{
    // TODO upload all records to database
  }

  List<Member> getMembers() => members;
  void addMember(Member member) => members.add(member);
}
