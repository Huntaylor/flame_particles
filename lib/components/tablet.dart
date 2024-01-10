import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_particles/my_game.dart';
import 'package:flutter/material.dart';

enum SpriteState { active, inactive }

class Tablet extends SpriteGroupComponent
    with HasGameRef<MyGame>, TapCallbacks {
  final int index;

  Tablet({
    required this.index,
    super.position,
    super.current,
  }) : super(
          anchor: Anchor.center,
          priority: 2,
          size: Vector2.all(64),
        );

  late final Sprite activeSprite;
  late final Sprite inactiveSprite;
  int tabletOffset = 4;

  @override
  FutureOr<void> onLoad() {
    debugColor = Colors.amberAccent;
    // debugMode = true;
    loadSprites();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateSpriteState();
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final newPosition = Vector2(position.x, position.y - tabletOffset);
    game.activeIndex = index;

    gameRef.player.movePlayer(newPosition);
    super.onTapDown(event);
  }

  void loadSprites() {
    final activeImage = game.images.fromCache('sprites/active_tablet.png');
    activeSprite = Sprite(activeImage);
    final inactiveImage = game.images.fromCache('sprites/inactive_tablet.png');
    inactiveSprite = Sprite(inactiveImage);

    sprites = {
      SpriteState.active: activeSprite,
      SpriteState.inactive: inactiveSprite,
    };
    current = SpriteState.inactive;
  }

  void _updateSpriteState() {
    SpriteState spriteState = SpriteState.inactive;
    if (game.activeIndex == index) {
      spriteState = SpriteState.active;
    } else {
      spriteState = SpriteState.inactive;
    }
    current = spriteState;
  }
}
