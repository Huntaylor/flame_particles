import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_particles/components/skeleton.dart';
import 'package:flame_particles/my_game.dart';

class PolygonEnemySpawn extends PolygonComponent with HasGameRef<MyGame> {
  PolygonEnemySpawn(
    super.vertices, {
    super.shrinkToBounds,
  });

  List<Skeleton> skeletons = [];

  @override
  FutureOr<void> onLoad() {
    spawnNextBatch();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (skeletons.isEmpty) {
      spawnNextBatch();
    }
    super.update(dt);
  }

  void spawnNextBatch() {}
}
