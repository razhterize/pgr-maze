import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scf_maze/app/widget/login.dart';
import 'package:scf_maze/app/widget/table.dart';
import 'widget/sidebar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // TODO Get Collections based on returned authentication credential
  bool authenticated = false;
  final PocketBase pb = PocketBase(dotenv.env["PB_LOCAL_URL"]!);
  late RecordAuth recordAuth;
  bool sidebarOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _openLogin(context);
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
          body: authenticated
              ? Row(
                  children: [
                    const Sidebar(),
                    GuildTable(guild: "kuru", pb: pb)
                  ],
                )
              : Login(
                  loginCallback: _loginCallback,
                  pb: pb,
                )),
    );
  }

  void _loginCallback(RecordAuth recordAuth) async {
    // debugPrint("Login Callback with\nEmail: $email, Password: $password");
    // Get authentication shenanigans
    // after auth success then you can access collection

    var data = await pb.collection("kuru").getFullList();
    {}
    ;
  }
}
