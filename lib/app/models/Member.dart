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

  Member.newMember(String guild, String name, int pgrId, String discordUsername,
      String discordId) {
    name = name;
    pgrId = pgrId;
    discordUsername = discordUsername;
    discordId = discordId;
    collectionName = guild;
    totalEnergyDamage = 0;
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
  }

  RecordModel createRecordModel() {
    Map<String, dynamic> data = {
      "name": name,
      "discord_username": discordUsername,
      "discord_id": discordId,
      "pgr_id": pgrId,
      "first_map": firstMap,
      "second_map": secondMap,
      "third_map": thirdMap,
      "totalEnergyDamage": totalEnergyDamage
    };

    RecordModel record = RecordModel(
        id: id,
        created: created,
        updated: updated,
        collectionId: collectionId,
        collectionName: collectionName,
        data: data);
    return record;
  }

  int firstMapEnergyDamage() => firstMap.values.reduce((a, b) => a + b);
  int secondMapEnergyDamage() => secondMap.values.reduce((a, b) => a + b);
  int thirdMapEnergyDamage() => thirdMap.values.reduce((a, b) => a + b);

  Future<void> createInDatabase(PocketBase pb) async {
    RecordModel record = createRecordModel();
    await pb.collection(collectionName).create(body: record.toJson());
  }

  Future<bool> existInDatabase(PocketBase pb) async {
    RecordModel record = await pb.collection(collectionName).getOne(id);
    if (record.id != "") {
      return true;
    }
    return false;
  }
  @override
  String toString(){
    return "id: $id\nGuild: $collectionName\nName: $name\nPGR ID: $pgrId\nDiscord Username: $discordUsername\nDiscord ID: $discordId";
  }

  Member.defaultValue() {
    id = "";
    updated = "";
    created = "";
    collectionId = "";
    collectionName = "";
    name = "";
    pgrId = 0;
    discordId = "";
    discordUsername = "";
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
