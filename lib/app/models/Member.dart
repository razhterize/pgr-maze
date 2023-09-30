import 'package:pocketbase/pocketbase.dart';

class Member extends RecordModel {
  // Member fields
  late String name;
  late String discordUsername;
  late String discordId;
  late int pgrId;
  late Map<String, dynamic> mapData;
  late int totalEnergyDamage = 0;
  bool selected = false;

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
    mapData = data["map_data"];
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
    mapData = {
      "first": {
        "energy_spent": 0,
        "points": 0,
        "overcap": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "wrong_node": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      },
      "second": {
        "energy_spent": 0,
        "points": 0,
        "overcap": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "wrong_node": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      },
      "third": {
        "energy_spent": 0,
        "points": 0,
        "overcap": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "wrong_node": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }
    };
  }

  RecordModel createRecordModel() {
    Map<String, dynamic> data = {
      "name": name,
      "discord_username": discordUsername,
      "discord_id": discordId,
      "pgr_id": pgrId,
      "map_data": mapData,
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

  int energyDamagePerMap(String map) {
    int damage = 0;
    num overcap = mapData[map]["overcap"].fold(0, (previous, after) => previous + after);
    num wrongNode = mapData[map]["wrong_node"].fold(0, (previous, after) => previous + after);
    damage = overcap + wrongNode as int;
    return damage;
  }

  int get totalDamage =>
      energyDamagePerMap("first") +
      energyDamagePerMap("second") +
      energyDamagePerMap("third");

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

  Future<void> update(PocketBase pb) async {
    RecordModel record = createRecordModel();
    await pb.collection(collectionName).update(id, body: record.toJson());
  }

  Future<void> delete(PocketBase pb) async {
    await pb.collection(collectionName).delete(id);
  }

  @override
  String toString() {
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
    mapData = {
      "first": {
        "energy_spent": 0,
        "points": 0,
        "overcap": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "wrong_node": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      },
      "second": {
        "energy_spent": 0,
        "points": 0,
        "overcap": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "wrong_node": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      },
      "third": {
        "energy_spent": 0,
        "points": 0,
        "overcap": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        "wrong_node": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }
    };
    totalEnergyDamage = 0;
  }
}