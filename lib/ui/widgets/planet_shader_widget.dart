import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class PlanetShaderWidget extends HookWidget {
  const PlanetShaderWidget({required this.assetKey, super.key});

  final String assetKey;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(hours: 1),
    );
    final mouse = useState(Offset.zero);

    useEffect(() {
      unawaited(controller.repeat());
      return null;
    }, const []);

    return ShaderBuilder(
      assetKey: assetKey,
      (_, shader, _) => GestureDetector(
        onPanUpdate: (details) => mouse.value = details.localPosition,
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, _) {
            final seconds = controller.lastElapsedDuration?.inMilliseconds ?? 0;
            return CustomPaint(
              painter: _PlanetPainter(
                shader: shader,
                time: seconds / 1000,
                mouse: mouse.value,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class _PlanetPainter extends CustomPainter {
  const _PlanetPainter({
    required this.shader,
    required this.time,
    required this.mouse,
  });

  final FragmentShader shader;
  final double time;
  final Offset mouse;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, mouse.dx)
      ..setFloat(4, mouse.dy);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_PlanetPainter old) =>
      old.time != time || old.mouse != mouse;
}
