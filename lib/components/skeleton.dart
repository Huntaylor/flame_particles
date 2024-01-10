import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_particles/my_game.dart';

class Skeleton extends SpriteAnimationComponent with HasGameRef<MyGame> {
  Skeleton({
    super.position,
    super.anchor = Anchor.center,
    super.animation,
  }) : super(
          size: Vector2(
            44,
            64,
          ),
        );

  @override
  FutureOr<void> onLoad() {
    _getAnimation();
    return super.onLoad();
  }

  void _getAnimation() async {
    final image = gameRef.images.fromCache('sprites/skeleton.png');
    final jsonData = gameRef.skeletonJsonData;
    animation = SpriteAnimation.fromAsepriteData(image, jsonData);
  }
}
