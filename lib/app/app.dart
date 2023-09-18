import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widgets/login.dart';
import 'package:scf_maze/app/widgets/table_view.dart';
import 'package:scf_maze/app/widgets/sidebar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _formKey = GlobalKey<FormState>();

  bool authenticated = false;
  final PocketBase pb = PocketBase(dotenv.env["PB_URL"]!);
  late RecordAuth recordAuth;
  List<Guild> guildList = [];
  List<TextEditingController> newMemberControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Builder(builder: (context) {
        return Scaffold(
            appBar: authenticated ? appBar(context) : null,
            drawer: Sidebar(
                managedGuilds: managedGuilds,
                callbackFunction: _sidebarCallback),
            body: authenticated
                ? SafeArea(child: mainTable(context))
                : SafeArea(
                    child: Login(loginCallback: _loginCallback, pb: pb)));
      }),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 36,
      title: Text(guildAbv[guildList[selectedGuildIndex].name]!),
      centerTitle: !Platform.isAndroid,
      actions: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: searchBar(),
        ),
        Padding(
            padding: const EdgeInsets.all(3.0),
            child: (!Platform.isAndroid)
                ? ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: mentionSelectedUsers()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Users mention text has been copied to clipboard")));
                    },
                    icon: const Icon(Icons.alternate_email_outlined),
                    label: const Text("Mention"),
                  )
                : IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: mentionSelectedUsers()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Users mention text has been copied to clipboard")));
                    },
                    icon: Icon(Icons.alternate_email))),
        Padding(
            padding: const EdgeInsets.all(3.0),
            child: (!Platform.isAndroid)
                ? ElevatedButton.icon(
                    label: const Text("Member"),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => newMemberDialog(context));
                    },
                  )
                : IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => newMemberDialog(context)),
                    icon: Icon(Icons.add))),
        Padding(
            padding: const EdgeInsets.all(3.0),
            child: (!Platform.isAndroid)
                ? ElevatedButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    label: const Text("Refresh"),
                    icon: const Icon(Icons.refresh))
                : IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.refresh)))
      ],
    );
  }

  Widget mainTable(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (authenticated && managedGuilds.isNotEmpty)
          Expanded(
            child: TableView(
              guilds: guildList,
              index: selectedGuildIndex,
              filter: filter,
              pb: pb,
            ),
          )
        else
          const Text("Something went wrong..."),
      ],
    );
  }

  Widget searchBar() {
    double maxWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: maxWidth * 0.2,
      height: 32,
      child: SearchBar(
        leading: searchModeDropdown(),
        // controller: controller,
        hintText: "Search $searchMode",
        onChanged: (value) {
          setState(() {
            filter = "$searchMode;$value";
          });
        },
      ),
    );
  }

  Widget searchModeDropdown() {
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
          DropdownMenuItem(value: "name", child: Text("Name")),
          DropdownMenuItem(value: "id", child: Text("ID"))
        ],
      ),
    );
  }

  Widget newMemberDialog(BuildContext context) {
    Member newMember = Member.defaultValue();
    for (var element in newMemberControllers) {
      element.clear();
    }

    return AlertDialog(
      title: const Text("Add Member"),
      content: newMemberContent(context, newMember),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                newMember.name = newMemberControllers[0].text;
                newMember.pgrId = int.tryParse(newMemberControllers[1].text)!;
                newMember.discordUsername = newMemberControllers[2].text;
                newMember.discordId = newMemberControllers[3].text;
                newMember.createInDatabase(pb);
                guildList[selectedGuildIndex].members.add(newMember);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Updating Members...')));
                Navigator.pop(context);
              } else {
                return;
              }
            },
            child: const Text("Create Member")),
      ],
    );
  }

  Widget newMemberContent(BuildContext context, Member newMember) {
    newMember.collectionName = "turu";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
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
                  controller: newMemberControllers[0],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "PGR ID"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: newMemberControllers[1],
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "0") {
                      return 'PGR ID cannot be empty or 0';
                    } else if (value.length != 8) {
                      return "PGR ID must be 8 digits long";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: "Discord Username"),
                  controller: newMemberControllers[2],
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Discord ID"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: newMemberControllers[3],
                ),
              ],
            ),
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
    guildList = managedGuilds
        .map((guild) => Guild(
              pb,
              guild,
              guildChangeCallback,
            ))
        .toList();
  }

  void guildChangeCallback() {
    debugPrint("Guild Change called");
    setState(() {});
  }
}
