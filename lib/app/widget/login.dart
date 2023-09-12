// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.loginCallback, required this.pb});

  final Function(RecordAuth recordAuth) loginCallback;
  final PocketBase pb;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late RecordAuth recordAuth;
  late Function loginCallback;
  late PocketBase pb;

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
            backgroundImage: AssetImage("assets/bianca.jpg"),
          ),
        ),
        Text(
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
          leading: Icon(Icons.mail_sharp),
          title: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Email",
            ),
            controller: _emailController,
          ),
        ),
        ListTile(
          // TODO Not empty and censor password with asterisk (*)
          leading: Icon(Icons.lock_sharp),
          title: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Password",
            ),
            controller: _passwordController,
          ),
        ),
        MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 2,
          color: Colors.lightBlueAccent,
          height: 70,
          onPressed: () => _submitLogin(),
          child: Text("LOGIN"),
        )
      ],
    );
  }

  Future<void> _submitLogin() async {
    recordAuth = await pb
        .collection("users")
        .authWithPassword(_emailController.text, _passwordController.text);
    var data = await pb.collection("kuru").getFullList();
  }
}
