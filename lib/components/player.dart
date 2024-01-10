import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame_particles/my_game.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent with HasGameRef<MyGame> {
  Player({
    super.position,
    super.sprite,
    super.priority = 3,
    super.anchor = Anchor.center,
  }) : super(
          size: Vector2.all(58),
        );

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;
  MoveToEffect? moveToEffect;
  bool isMoving = false;
  bool canCheckMoving = false;

  late Vector2 nextPosition;

  @override
  FutureOr<void> onLoad() {
    nextPosition = position;
    debugColor = Colors.greenAccent;
    // debugMode = true;

    loadSprite();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (canCheckMoving) {
        isMoving =
            (Vector2(position.x.roundToDouble(), position.y.roundToDouble()) !=
                nextPosition);
        if (!isMoving) {
          canCheckMoving = isMoving;
        }
      }
      loadParticles();
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void movePlayer(Vector2 newPosition) {
    canCheckMoving = true;
    nextPosition = newPosition;

    if (position == newPosition) {
      return;
    }

    MoveToEffect effect;
    if (moveToEffect != null) {
      if (!moveToEffect!.controller.completed) {
        remove(moveToEffect!);
        effect = getMoveEffect(newPosition);
        moveToEffect = effect;
        add(moveToEffect!);
        return;
      }
    }
    effect = getMoveEffect(newPosition);

    moveToEffect = effect;
    add(moveToEffect!);
  }

  void loadSprite() {
    final fireSprite = game.images.fromCache('sprites/black_fire.png');
    sprite = Sprite(
      fireSprite,
    );
  }

  final rnd = Random();
  Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd));

  void loadParticles() {
    final blackFireSprite = getSprite(
      fileName: 'sprites/black_fire_split_black.png',
    );
    final whiteFireSprite = getSprite(
      fileName: 'sprites/black_fire_split_white.png',
    );

    Vector2 speed = getConsistentSpeed();

    final particleComponent = getParticleSystem(
      speed: speed,
      fireSprite: whiteFireSprite,
    );

    final particleComponent2 = getParticleSystem(
      speed: speed,
      fireSprite: blackFireSprite,
    );

    gameRef.world.addAll(
      [
        particleComponent..priority = 2,
        particleComponent2..priority = 3,
      ],
    );
  }

  ParticleSystemComponent getParticleSystem(
      {required Vector2 speed, required Sprite fireSprite}) {
    return ParticleSystemComponent(
      position: position.clone(),
      anchor: Anchor.center,
      particle: Particle.generate(
        count: 1,
        lifespan: .5,
        generator: (i) => AcceleratedParticle(
          speed: speed,
          child: ScalingParticle(
            child: SpriteParticle(
              sprite: fireSprite,
              size: size,
            ),
          ),
        ),
      ),
    );
  }

  MoveToEffect getMoveEffect(Vector2 newPosition) {
    return MoveToEffect(
      newPosition,
      EffectController(
        speed: 700,
      ),
    );
  }

  Vector2 getConsistentSpeed() {
    double ySpeed = rnd.nextDouble() * 55 - 30;
    return Vector2(
      rnd.nextDouble() * 55 - 30,
      _getDirection(ySpeed),
    );
  }

  Sprite getSprite({required String fileName}) {
    final fireImage = game.images.fromCache(fileName);
    return Sprite(
      fireImage,
    );
  }

  double _getDirection(double speed) {
    return (isMoving) ? speed : -size.y - 50;
  }
}
