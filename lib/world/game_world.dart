import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_particles/components/skeleton.dart';
import 'package:flame_particles/components/tablet.dart';
import 'package:flame_particles/components/player.dart';
import 'package:flame_particles/my_game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class GameWorld extends World with HasGameRef<MyGame> {
  late TiledComponent level;
  final Player player;
  final String worldName;

  GameWorld({
    required this.player,
    required this.worldName,
    super.children,
    super.priority = -1,
  });

  List<Vector2> polygonPoints = [];
  List<Tablet> tabletList = [];
  int startingIndex = 0;
  int spawnOffset = 32;
  int tabletOffset = 4;

  @override
  FutureOr<void> onLoad() async {
    await loadWorld();
    _spawningObjects();
    return super.onLoad();
  }

  Future<void> loadWorld() async {
    level = await TiledComponent.load(
      worldName,
      Vector2.all(64),
    );
    add(level);
  }

  void _spawningObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Tablet':
            final tablet = Tablet(
              index: startingIndex,
              position: Vector2(
                spawnPoint.x + spawnOffset,
                spawnPoint.y + spawnOffset,
              ),
            );
            if (spawnPoint.properties.getValue('playerSpawn') as bool) {
              // print('spawn player');
              // Vector2(newPosition.x - (size.x / 2), newPosition.y - (size.y / 2))
              player.position = Vector2(
                spawnPoint.x + spawnOffset,
                spawnPoint.y + spawnOffset - tabletOffset,
              );
              game.activeIndex = tablet.index;
              add(player);
            }
            startingIndex = ++startingIndex;
            tabletList.add(tablet);
            add(tablet);
          case 'EnemySpawn':
            final newPolygon = spawnPoint.polygon;

            for (final point in newPolygon) {
              Vector2 fromPoint =
                  Vector2(point.x /* + 64 */, point.y /* + 128 */);

              polygonPoints.add(fromPoint);
            }
            final reversed = polygonPoints.reversed.toList();
            print(reversed);
            final polygonComponent = PolygonComponent(reversed,
                shrinkToBounds: true,
                paint: Paint()..color = Colors.transparent,
                anchor: Anchor.topLeft)
              ..debugMode = true
              ..debugColor = Colors.amber;

            // Top points: 128, 128 - 448, 128
            // Bottom Points

            for (var i = 0; i < reversed.length; i++) {
              final rng = Random();
              final rng2 = Random();
              print(rng.nextDouble());
              final size = Vector2(
                  polygonComponent.position.x, polygonComponent.position.y);

              final positionX = rng
                      .nextInt(
                        polygonComponent.position.x.floor(),
                      )
                      .floorToDouble() +
                  size.x;
              final positionY = rng2
                      .nextInt(
                        polygonComponent.position.y.floor(),
                      )
                      .floorToDouble() +
                  size.y;

              final skeleton = Skeleton(
                position: Vector2(
                  positionX + (size.x * rng.nextDouble()),
                  positionY + (size.y * rng2.nextDouble()),
                ),
              );
              add(skeleton);
            }

            addAll([/* skeleton ,*/ polygonComponent]);
        }
      }
    }
  }
}
