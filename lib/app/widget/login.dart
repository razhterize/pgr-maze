// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.loginCallback});

  final Function(String, String) loginCallback;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late Function loginCallback;
  @override
  void initState() {
    loginCallback = widget.loginCallback;
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
          child: _login(),
        ),
      ),
    );
  }

  Widget _login() {
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

  void _submitLogin() {
    loginCallback(_emailController.text, _passwordController.text);
  }
}
