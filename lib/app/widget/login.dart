import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.loginCallback, required this.pb});

  final Function(RecordAuth recordAuth) loginCallback;
  final PocketBase pb;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController(text: "razh");
  final TextEditingController _passwordController = TextEditingController(text: "AbsoluteJudgement");

  late RecordAuth recordAuth;
  late Function loginCallback;
  late PocketBase pb;

  bool failedAuthenticate = false;

  @override
  void initState() {
    loginCallback = widget.loginCallback;
    pb = widget.pb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _loginWidget(),
        ),
      ),
    );
  }

  Widget _loginWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.height / 6,
            backgroundImage: const AssetImage("assets/bianca.jpg"),
          ),
        ),
        const Text(
          "Premium Slavery Management App",
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              fontStyle: FontStyle.italic),
        ),
        ListTile(
          // TODO Not empty and match email regex
          leading: const Icon(Icons.alternate_email_outlined),
          title: Form(
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "Username or Email",
              ),
              controller: _emailController,
            ),
          ),
        ),
        ListTile(
          // TODO Not empty and censor password with asterisk (*)
          leading: const Icon(Icons.lock_sharp),
          title: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Password",
            ),
            controller: _passwordController,
          ),
        ),
        ElevatedButton(
          onPressed: _submitLogin,
          child: const Text("Login"),
        ),
        failedAuthenticate
            ? const Text(
                "Authentication Failed, wrong password or email idk, forgot? ask razh LMAO",
                style: TextStyle(color: Colors.red),
              )
            : Container()
      ],
    );
  }

  Future<void> _submitLogin() async {
    try {
      recordAuth = await pb
          .collection("users")
          .authWithPassword(_emailController.text, _passwordController.text);
      if (pb.authStore.isValid) {
        setState(() {
          failedAuthenticate = false;
        });
        loginCallback(recordAuth);
      }
    } on ClientException catch (e) {
      if (e.response["message"] == "Failed to authenticate." &&
          e.statusCode == 400) {
        debugPrint("Failed to authenticate");
        setState(() {
          failedAuthenticate = true;
        });
      }
    }
  }
}
