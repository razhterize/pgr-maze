import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scf_maze/app/models/guild.dart';
import 'package:scf_maze/app/models/member.dart';
import 'package:scf_maze/app/widgets/login.dart';
import 'package:scf_maze/app/widgets/table_view.dart';
import 'package:scf_maze/app/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _formKey = GlobalKey<FormState>();

  late final PocketBase pb;
  bool darkTheme = true;
  bool authenticated = false;
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
    var asyncAuthStore = AsyncAuthStore(
            save: (data) => widget.sharedPreferences.setString("pb_auth", data),
            initial: widget.sharedPreferences.getString("pb_auth"));
    pb = PocketBase(dotenv.env["PB_URL"]!,
        authStore: asyncAuthStore);
    if (pb.authStore.isValid) {
      _loginCallback(RecordAuth(token: pb.authStore.token));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: darkTheme ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      home: Builder(builder: (context) {
        return Scaffold(
            appBar: authenticated ? appBar(context) : null,
            drawer: Sidebar(
              managedGuilds: managedGuilds,
              callbackFunction: _sidebarCallback,
              themeChanger: themeChange,
            ),
            body: authenticated
                ? SafeArea(bottom: false, child: mainTable(context))
                : SafeArea(
                    child: Login(loginCallback: _loginCallback, pb: pb)));
      }),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 36,
      title: Text(guildAbv[guildList[selectedGuildIndex].name]!),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: searchBar(),
        ),
        Padding(
            padding: const EdgeInsets.all(3.0),
            child: (MediaQuery.of(context).orientation == Orientation.landscape)
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
            child: (MediaQuery.of(context).orientation == Orientation.landscape)
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
            child: (MediaQuery.of(context).orientation == Orientation.landscape)
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
      width: maxWidth * 0.4,
      // height: 32,
      child: SearchBar(
        constraints: const BoxConstraints.expand(),
        // shadowColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(234, 5, 5, 1)),
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => Color(Colors.lightBlue.value)),
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

  void _loginCallback(dynamic recordAuth) {
    RecordModel? _record;
    if (recordAuth.token != "") {
      pb.collection("users").authRefresh();
      _record = pb.authStore.model;
      setState(() {
        authenticated = true;
      });
    }
    if (recordAuth.record != null) {
      _record = recordAuth.record;
      setState(() {
        authenticated = true;
      });
    }
    managedGuilds = _record!.data["managed_guilds"];
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

  void themeChange() {
    setState(() {
      darkTheme = !darkTheme;
    });
  }
}
