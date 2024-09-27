import 'dart:async';

import 'package:blog_hub_app/app.dart';
import 'package:blog_hub_app/core/modules/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
  runApp(
    ModularApp(module: AppModule(prefs), child: const AppWidget()),
  );
}
