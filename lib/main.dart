import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:scf_maze/app/app.dart';

Future<void> main(List<String> args) async {
  await dotenv.load();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (!Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();

    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitle('SCF Guild Maze Management');
    });
  }
  runApp(App(
    sharedPreferences: _prefs,
  ));
}
