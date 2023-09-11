import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';

Future<void> main(List<String> args) async {
  await dotenv.load();
  runApp(const App());
}
