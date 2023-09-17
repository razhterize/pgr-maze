import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widgets/login.dart';
import 'package:scf_maze/app/widgets/table_view.dart';
import 'package:scf_maze/app/widgets/sidebar.dart';

class WindowsApp extends StatefulWidget {
  const WindowsApp({super.key});

  @override
  State<WindowsApp> createState() => _WindowsAppState();
}

class _WindowsAppState extends State<WindowsApp> {
  final _formKey = GlobalKey<FormState>();

  bool authenticated = false;
  final PocketBase pb = PocketBase(dotenv.env["PB_URL"]!);
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
              ? SafeArea(
                child: Builder(builder: (context) {
                    return _mainTable(context);
                  }),
              )
              : SafeArea(
                child: Login(
                    loginCallback: _loginCallback,
                    pb: pb,
                  ),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              newMember.createInDatabase(pb);
                              guildList[selectedGuildIndex].members.add(newMember);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Updating Members...')),
                              );
                            }
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Text("Create Member"),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
              child: const Text("New Member"),
            ),
            IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh)),
            const Spacer()
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
                filter = "$searchMode;$value";
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
          key: _formKey,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) => newMember.name = value,
                onTapOutside: (event) => newMember.name = name.text,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "PGR ID"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: pgrId,
                validator: (value) {
                  if (value == null || value.isEmpty || value == "0") {
                    return 'PGR ID cannot be empty or 0';
                  } else if (value.length != 8){
                    return "PGR ID must be 8 digits long";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value == "" || value.isEmpty) value = "0";
                  newMember.pgrId = int.tryParse(value) as int;
                },
                onTapOutside: (event) {
                  if (pgrId.text == "" || pgrId.text.isEmpty) pgrId.text = "0";
                  newMember.pgrId = int.tryParse(pgrId.text) as int;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Discord Username"),
                controller: discordUsername,
                onChanged: (value) => newMember.discordUsername = value,
                onTapOutside: (event) =>
                    newMember.discordUsername = discordUsername.text,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Discord ID"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: discordId,
                onChanged: (value) => newMember.discordId = value,
                onTapOutside: (event) => newMember.discordId = discordId.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String mentionSelectedUsers() {
    String mentions = "";
    for (var member in guildList[selectedGuildIndex].members) {
      if (member.selected) {
        if (member.discordId != "" && member.discordId != "-") {
          mentions += "<@${member.discordId}>\n";
        } else if (member.discordUsername != "") {
          mentions += "@${member.discordUsername}\n";
        }
      }
    }
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
