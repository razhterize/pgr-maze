import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scf_maze/app/models/member.dart';

class Guild {
  PocketBase? _pb;
  RecordService? _collection;

  Guild(PocketBase pb, String collection) {
    _pb = pb;
    _collection = _pb?.collection(collection);
  }

  Future<List<RecordModel>?> getAll() async {
    List<RecordModel>? data = await _collection?.getFullList();
    List<Member>? members = [];
    data?.forEach((record) {
      members.add(Member(record));
    });
    return members;
  }
}
