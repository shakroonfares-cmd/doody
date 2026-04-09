// ============================================================
//  widgets/worm_painter.dart
//
//  Draws a procedural 3-D-looking worm using CustomPainter.
//  Each body segment is a sphere-like ellipse shaded with
//  radial gradients that simulate ambient + specular lighting.
//
//  The painter is driven by three AnimationController values:
//    • phaseValue  — drives the sinusoidal body wave
//    • bounceValue — vertical bounce offset (happy / idle bob)
//    • droop       — downward sag (sad state)
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/worm_animation_state.dart';
import '../theme/app_theme.dart';

class WormPainter extends CustomPainter {
  final double phase;        // 0..1 animation phase
  final double bounce;       // 0..1 vertical bounce
  final double droop;        // 0..1 sad droop factor
  final WormAnimationState state;
  final double transitionT;  // 0..1 cross-fade between states

  const WormPainter({
    required this.phase,
    required this.bounce,
    required this.droop,
    required this.state,
    required this.transitionT,
  });

  // ── Colour per state ─────────────────────────────────────
  Color get _bodyColor {
    switch (state) {
      case WormAnimationState.idle:
        return const Color(0xFF4ADE80);  // green
      case WormAnimationState.happy:
        return const Color(0xFFFBBF24);  // amber
      case WormAnimationState.sad:
        return const Color(0xFF818CF8);  // lavender
    }
  }

  Color get _shadowColor => _bodyColor.withOpacity(0.25);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Number of body segments + head
    const int segments = 8;
    const double segR = 22.0;           // segment radius
    const double spacing = segR * 1.55; // centre-to-centre distance

    // Total length of the worm body
    final double totalLen = spacing * segments;

    // ── Compute segment centres ───────────────────────────
    final List<Offset> centres = [];
    for (int i = 0; i <= segments; i++) {
      // Horizontal position along worm spine
      final double t = i / segments;
      final double x = cx - totalLen / 2 + t * totalLen;

      // Sinusoidal body wave
      final double waveAmp = state == WormAnimationState.sad ? 6 : 18;
      final double waveFreq = state == WormAnimationState.happy ? 2.5 : 1.5;
      double y = cy + math.sin((t * math.pi * waveFreq) + phase * math.pi * 2)
                      * waveAmp;

      // Vertical bob (idle & happy)
      final double bobAmp = state == WormAnimationState.sad ? 3 : 12;
      y += math.sin(phase * math.pi * 2) * bounce * bobAmp;

      // Sad droop — tail droops more than head
      y += droop * t * 40;

      centres.add(Offset(x, y));
    }

    // ── Draw shadow ───────────────────────────────────────
    _drawShadow(canvas, centres, size, segR);

    // ── Draw tail-to-head so head is on top ───────────────
    for (int i = segments; i >= 1; i--) {
      _drawSegment(canvas, centres[i], segR, i / segments);
    }

    // ── Draw head (index 0) ───────────────────────────────
    _drawHead(canvas, centres[0], segR * 1.35);
  }

  /// Elliptical drop shadow beneath the worm.
  void _drawShadow(
      Canvas canvas, List<Offset> centres, Size size, double r) {
    if (centres.isEmpty) return;
    final double shadowY = centres
            .map((c) => c.dy)
            .reduce(math.max) +
        r + 14;

    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          _shadowColor.withOpacity(0.55),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCenter(
          center: Offset(size.width / 2, shadowY),
          width: size.width * 0.75,
          height: 28,
        ),
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, shadowY),
        width: size.width * 0.7,
        height: 22,
      ),
      shadowPaint,
    );
  }

  /// Draws one body segment as a shaded 3-D sphere.
  void _drawSegment(Canvas canvas, Offset centre, double r, double taper) {
    // Segments get slightly smaller toward the tail
    final double sr = r * (0.72 + 0.28 * (1 - taper));

    final Rect rect = Rect.fromCircle(center: centre, radius: sr);

    // Base body fill with radial gradient (simulates sphere shading)
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.45),
        radius: 0.9,
        colors: [
          Color.lerp(Colors.white, _bodyColor, 0.35)!,
          _bodyColor,
          Color.lerp(_bodyColor, Colors.black, 0.4)!,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(rect);

    canvas.drawCircle(centre, sr, bodyPaint);

    // Specular highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.5),
        radius: 0.45,
        colors: [
          Colors.white.withOpacity(0.55),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawCircle(centre, sr * 0.7, highlightPaint);

    // Thin rim outline for depth separation
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.2;
    canvas.drawCircle(centre, sr, rimPaint);
  }

  /// Draws the worm's head with eyes + expression.
  void _drawHead(Canvas canvas, Offset centre, double r) {
    _drawSegment(canvas, centre, r, 0); // reuse segment shading

    // ── Eyes ─────────────────────────────────────────────
    final double eyeR  = r * 0.22;
    final double eyeOffX = r * 0.32;
    final double eyeOffY = -r * 0.2;

    // Eye whites
    final eyeWhitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
        centre + Offset(-eyeOffX, eyeOffY), eyeR, eyeWhitePaint);
    canvas.drawCircle(
        centre + Offset(eyeOffX, eyeOffY), eyeR, eyeWhitePaint);

    // Pupils — shift direction based on state
    final double pupilShiftX = state == WormAnimationState.happy ? -0.2 : 0;
    final double pupilShiftY = state == WormAnimationState.sad ? 0.3 : -0.1;
    final pupilPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(
        centre + Offset(-eyeOffX + pupilShiftX * eyeR,
            eyeOffY + pupilShiftY * eyeR),
        eyeR * 0.55,
        pupilPaint);
    canvas.drawCircle(
        centre + Offset(eyeOffX + pupilShiftX * eyeR,
            eyeOffY + pupilShiftY * eyeR),
        eyeR * 0.55,
        pupilPaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(
        centre + Offset(-eyeOffX - eyeR * 0.15, eyeOffY - eyeR * 0.15),
        eyeR * 0.2,
        shinePaint);
    canvas.drawCircle(
        centre + Offset(eyeOffX - eyeR * 0.15, eyeOffY - eyeR * 0.15),
        eyeR * 0.2,
        shinePaint);

    // ── Mouth ─────────────────────────────────────────────
    _drawMouth(canvas, centre, r);
  }

  void _drawMouth(Canvas canvas, Offset centre, double r) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final double mY = centre.dy + r * 0.38;
    final double mW = r * 0.42;

    // Mouth shape varies by state
    final Path mouthPath = Path();
    switch (state) {
      case WormAnimationState.happy:
        // Big smile
        mouthPath.moveTo(centre.dx - mW, mY);
        mouthPath.quadraticBezierTo(
            centre.dx, mY + r * 0.32, centre.dx + mW, mY);
        break;
      case WormAnimationState.sad:
        // Frown
        mouthPath.moveTo(centre.dx - mW, mY);
        mouthPath.quadraticBezierTo(
            centre.dx, mY - r * 0.28, centre.dx + mW, mY);
        break;
      case WormAnimationState.idle:
        // Neutral slight smile
        mouthPath.moveTo(centre.dx - mW * 0.7, mY);
        mouthPath.quadraticBezierTo(
            centre.dx, mY + r * 0.12, centre.dx + mW * 0.7, mY);
        break;
    }
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(WormPainter old) =>
      old.phase != phase ||
      old.bounce != bounce ||
      old.droop != droop ||
      old.state != state ||
      old.transitionT != transitionT;
}
