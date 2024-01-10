import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame_particles/my_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();

  await Flame.device.setPortrait();

  MyGame game = MyGame();
  runApp(
    GameWidget(game: kDebugMode ? MyGame() : game),
  );
}
