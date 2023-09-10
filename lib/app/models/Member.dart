import 'package:pocketbase/pocketbase.dart';

class Member extends RecordModel {
  // Member fields
  late String name;
  late String discordUsername;
  late String discordId;
  late int pgrId;
  late Map<String, dynamic> firstMap;
  late Map<String, dynamic> secondMap;
  late Map<String, dynamic> thirdMap;
  late int totalEnergyDamage = 0;

  Member(RecordModel record) {
    Map<String, dynamic> data = record.data;
    id = record.id;
    updated = record.updated;
    created = record.created;
    collectionId = record.collectionId;
    collectionName = record.collectionName;
    name = data["name"];
    discordUsername = data["discord_username"];
    discordId = data["discord_id"];
    pgrId = data["pgr_id"];
    firstMap = data["first_map"];
    secondMap = data["second_map"];
    thirdMap = data["third_map"];
    totalEnergyDamage = data["total_energy_damage"];
  }

  RecordModel createRecordModel(){
    Map<String, dynamic> data = {
      "name": name,
      "discord_username": discordUsername,
      "discord_id": discordId,
      "pgr_id": pgrId,
      "first_map": firstMap,
      "second_map": secondMap,
      "third_mapo": thirdMap,
      "totalEnergyDamage": totalEnergyDamage
    };
    RecordModel _record = RecordModel(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      data: data
    );
    return _record;
  }

  Future<void> sendToDatabase(PocketBase pb) async {
    RecordModel _record = createRecordModel();
    RecordModel _response = await pb.collection(collectionId).create(body: _record.toJson());
    return;
  }

  Future<bool> existInDatabase(PocketBase pb) async {
    RecordModel _record = await pb.collection(collectionId).getOne(id);
    if (_record.id != ""){
      return true;
    }
    return false;
  }

  Member.defaultValue() {
    id = "oaipwjdoij";
    updated = "2023-09-09 16:14:24.369Z";
    created = "2023-09-09 16:14:24.369Z";
    collectionId = "zqic8wq6r51e3cb";
    collectionName = "kuru";
    name = "razh";
    discordId = "09234502938420934823098";
    discordUsername = "alviona";
    firstMap = {
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0
    };
    secondMap = {
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0
    };
    thirdMap = {
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0
    };
    totalEnergyDamage = 0;
  }
}
