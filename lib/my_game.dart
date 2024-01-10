import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_particles/components/player.dart';
import 'package:flame_particles/world/game_world.dart';

class MyGame extends FlameGame {
  MyGame({
    super.camera,
  });
  Player player = Player();

  Map<String, dynamic> skeletonJsonData = {};

  int activeIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    skeletonJsonData = await assets.readJson('images/sprites/skeleton.json');

    await _loadWorld();
    return super.onLoad();
  }

  Future<void> _loadWorld() async {
    world = GameWorld(
      player: player,
      worldName: 'particles.tmx',
    );
    camera = CameraComponent.withFixedResolution(
      world: world,
      width: 576,
      height: 832,
    );

    camera.viewfinder.anchor = Anchor.topLeft;
    addAll([camera]);
  }
}
