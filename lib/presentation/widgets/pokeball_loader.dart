import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokemon/core/theme/app_theme.dart';
import 'dart:math' as math;

class PokeballLoader extends StatelessWidget {
  final double size;

  const PokeballLoader({super.key, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _PokeballPainter(),
        ),
      )
      .animate(onPlay: (controller) => controller.repeat())
      .rotate(duration: 1.seconds, curve: Curves.linear),
    );
  }
}

class _PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    // Top half (Red)
    paint.color = AppTheme.pokemonRed;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      true,
      paint,
    );

    // Bottom half (White)
    paint.color = Colors.white;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi,
      true,
      paint,
    );

    // Middle Line (Black)
    paint.color = AppTheme.pokemonBlack;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.08;
    
    // Draw outer circle border
    canvas.drawCircle(center, radius, paint);
    
    // Draw center line
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );

    // Center Circle (White with Black border)
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.3, paint);

    paint.style = PaintingStyle.stroke;
    paint.color = AppTheme.pokemonBlack;
    paint.strokeWidth = size.width * 0.08;
    canvas.drawCircle(center, radius * 0.3, paint);
    
    // Inner center circle (White again mostly or empty, let's make it solid white with thin border)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = AppTheme.pokemonBlack.withValues(alpha: 0.2);
    canvas.drawCircle(center, radius * 0.15, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
