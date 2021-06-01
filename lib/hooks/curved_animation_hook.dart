import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _HookCurvedAnimation extends Hook<Animation<double>> {
  const _HookCurvedAnimation(this.animationController);

  final AnimationController animationController;

  @override
  _HookCurvedAnimationState createState() => _HookCurvedAnimationState();
}

class _HookCurvedAnimationState
    extends HookState<Animation<double>, _HookCurvedAnimation> {
  late Animation<double> _animation;

  @override
  void initHook() {
    super.initHook();

    _animation = CurvedAnimation(
      parent: hook.animationController,
      curve: Curves.bounceInOut,
    );
  }

  @override
  Animation<double> build(BuildContext context) => _animation;
}

Animation<double> useCurvedAnimation(AnimationController controller) {
  return use(_HookCurvedAnimation(controller));
}
