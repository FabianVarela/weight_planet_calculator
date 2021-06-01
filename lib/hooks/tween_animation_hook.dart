import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _HookTweenAnimation extends Hook<Tween<double>> {
  const _HookTweenAnimation(this.animationController, this.begin, this.end);

  final AnimationController animationController;
  final double? begin;
  final double? end;

  @override
  _HookTweenAnimationState createState() => _HookTweenAnimationState();
}

class _HookTweenAnimationState
    extends HookState<Tween<double>, _HookTweenAnimation> {
  late Tween<double> _tweenAnimation;

  @override
  void initHook() {
    super.initHook();

    hook.animationController.addListener(_changeState);
    _tweenAnimation = Tween<double>(begin: hook.begin, end: hook.end);
    hook.animationController.forward();
  }

  @override
  void didUpdateHook(_HookTweenAnimation oldHook) {
    if (oldHook != hook) {
      _tweenAnimation = Tween<double>(
        begin: _tweenAnimation.evaluate(hook.animationController),
        end: hook.end,
      );
      hook.animationController.forward(from: 0.0);
    }
    super.didUpdateHook(oldHook);
  }

  @override
  Tween<double> build(BuildContext context) => _tweenAnimation;

  void _changeState() => setState(() {});
}

Tween<double> useTweenAnimation(AnimationController controller,
    {double? begin, double? end}) {
  return use(_HookTweenAnimation(controller, begin, end));
}
