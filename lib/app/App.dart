import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widget/login.dart';
import 'package:scf_maze/app/widget/table_view.dart';
import 'widget/sidebar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool authenticated = false;
  final PocketBase pb = PocketBase(dotenv.env["PB_LOCAL_URL"]!);
  late RecordAuth recordAuth;
  List<Guild> guildList = [];

  int selectedGuildIndex = 0;
  Map<String, String> guildAbv = {
    "turu": "Imperium of Turu",
    "kuru": "Cult of Kuru",
    "tensura": "Tensura【懸】",
    "crepe": "Crepe of Turu",
    "ancient_weapon": "AncientWeapon",
    "avarice_echo": "Avarice Echo",
    "arcadian": "Arcadian"
  };
  List<dynamic> managedGuilds = [];

  String searchMode = "name";
  String filter = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _openLogin(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
          body: authenticated
              ? Builder(builder: (context) {
                  return _mainTable(context);
                })
              : Login(
                  loginCallback: _loginCallback,
                  pb: pb,
                )),
    );
  }

  Widget _mainTable(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Sidebar(
          managedGuilds: managedGuilds,
          callbackFunction: _sidebarCallback,
        ),
        if (authenticated && managedGuilds.isNotEmpty)
          Column(
            children: [
              menuBar(context),
              Expanded(
                child: TableView(
                  guilds: guildList,
                  index: selectedGuildIndex,
                  filter: filter,
                  pb: pb,
                ),
              ),
            ],
          )
        else
          const Text("Something went wrong..."),
      ],
    );
  }

  SizedBox menuBar(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 80,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
        child: Row(
          children: [
            _searchBar(),
            ElevatedButton(
                onPressed: () => Clipboard.setData(
                            ClipboardData(text: mentionSelectedUsers()))
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Discord Mentions copied to Clipboard"),
                        ),
                      );
                    }),
                child: const Text("Mention Members")),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    Member newMember = Member.defaultValue();
                    return AlertDialog(
                      title: const Text("Add Member"),
                      // scrollable: true,
                      content: _newMemberWidget(context, newMember),
                      actions: [
                        ElevatedButton(
                          onPressed: () => newMember.createInDatabase(pb),
                          child: const Text("Create Member"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("New Member"),
            )
          ],
        ),
      ),
    );
  }

  SearchAnchor _searchBar() {
    return SearchAnchor(
      builder: (context, controller) {
        return SizedBox(
          width: 300,
          height: 32,
          child: SearchBar(
            leading: _searchModeDropdown(),
            controller: controller,
            hintText: "Search $searchMode",
            onChanged: (value) {
              setState(() {
                filter = value;
              });
            },
          ),
        );
      },
      suggestionsBuilder: (context, controller) {
        return List<Text>.generate(guildList[selectedGuildIndex].totalMembers,
            (index) => Text(guildList[selectedGuildIndex].members[index].name));
      },
    );
  }

  Widget _searchModeDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        borderRadius: BorderRadius.circular(10),
        value: searchMode,
        onChanged: (value) {
          setState(() {
            searchMode = value!;
          });
        },
        items: const [
          DropdownMenuItem(
            value: "name",
            child: Text("Name"),
          ),
          DropdownMenuItem(
            value: "id",
            child: Text("ID"),
          )
        ],
      ),
    );
  }

  Widget _newMemberWidget(BuildContext context, Member newMember) {
    TextEditingController name = TextEditingController();
    TextEditingController pgrId = TextEditingController();
    TextEditingController discordId = TextEditingController();
    TextEditingController discordUsername = TextEditingController();
    newMember.collectionName = "turu";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height,
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField(
                value: managedGuilds.first.toString(),
                items: managedGuilds
                    .map((guild) => DropdownMenuItem(
                          value: guild.toString(),
                          child: Text(guildAbv[guild]!),
                        ))
                    .toList(),
                onChanged: (value) => newMember.collectionName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Name"),
                controller: name,
                onChanged: (value) => newMember.name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "PGR ID"),
                keyboardType: TextInputType.number,
                controller: pgrId,
                onChanged: (value) => newMember.pgrId = int.tryParse(value)!,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Discord Username"),
                controller: discordUsername,
                onChanged: (value) => newMember.discordUsername = value,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Discord ID"),
                keyboardType: TextInputType.number,
                controller: discordId,
                onChanged: (value) => newMember.discordId = value,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  newMember.discordId = discordId.text;
                  newMember.name = name.text;
                  newMember.discordUsername = discordUsername.text;
                  newMember.pgrId = int.tryParse(pgrId.text)!;
                },
                child: const Text("Verify"),
              )
            ],
          ),
        ),
      ),
    );
  }

  String mentionSelectedUsers() {
    String mentions = "";
    guildList[selectedGuildIndex].members.forEach((member) {
      if (member.selected) {
        if (member.discordId != "" && member.discordId != "-") {
          mentions += "<@${member.discordId}>\n";
        } else if (member.discordUsername != "") {
          mentions += "@${member.discordUsername}\n";
        }
      }
    });
    return mentions;
  }

  void _sidebarCallback(int index) {
    setState(() {
      selectedGuildIndex = index;
    });
  }

  void _loginCallback(RecordAuth recordAuth) {
    if (pb.authStore.isValid) {
      setState(() {
        authenticated = true;
      });
    }
    managedGuilds = recordAuth.record?.data["managed_guilds"];
    guildList = managedGuilds.map((guild) => Guild(pb, guild)).toList();
  }
}
