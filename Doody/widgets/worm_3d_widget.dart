// ============================================================
//  widgets/worm_3d_widget.dart
//
//  Interactive 3-D worm widget.
//
//  Architecture:
//    • Three AnimationControllers drive the worm painter:
//        phaseCtrl  — main wave / idle bob loop
//        bounceCtrl — vertical punch (happy)
//        droopCtrl  — downward sag (sad)
//    • A GestureDetector + LayoutBuilder split the canvas
//      into HEAD zone (left ~30 %) and BODY zone (right 70 %)
//      so taps route to the correct animation.
//    • State transitions are smoothed via a cross-fade controller.
//
//  Optional 3-D model (model_viewer_plus):
//    Uncomment the ModelViewer section below and provide a
//    .glb file at assets/models/worm.glb to use a real 3-D
//    mesh instead of the procedural painter.
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';

import '../models/worm_animation_state.dart';
import '../theme/app_theme.dart';
import 'worm_painter.dart';

// Uncomment to use real 3-D model:
// import 'package:model_viewer_plus/model_viewer_plus.dart';

class Worm3DWidget extends StatefulWidget {
  /// Called whenever the worm's state changes — parent can react.
  final ValueChanged<WormAnimationState>? onStateChanged;

  const Worm3DWidget({super.key, this.onStateChanged});

  @override
  State<Worm3DWidget> createState() => _Worm3DWidgetState();
}

class _Worm3DWidgetState extends State<Worm3DWidget>
    with TickerProviderStateMixin {
  // ── Animation Controllers ────────────────────────────────

  /// Drives the sinusoidal body wave — always running.
  late final AnimationController _phaseCtrl;

  /// Drives the vertical bounce — intensifies in happy state.
  late final AnimationController _bounceCtrl;

  /// Drives the downward droop — activates in sad state.
  late final AnimationController _droopCtrl;

  /// Cross-fades the colour/expression when state changes.
  late final AnimationController _transitionCtrl;

  // Derived animation values
  late final Animation<double> _phase;
  late final Animation<double> _bounce;
  late final Animation<double> _droop;
  late final Animation<double> _transition;

  // ── State ────────────────────────────────────────────────
  WormAnimationState _currentState = WormAnimationState.idle;
  Timer? _autoReturnTimer;

  // Particle effects for happy burst
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Phase: always looping, speed adjusts per state
    _phaseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    // Bounce: repeat, amplitude controlled in painter
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Droop: driven 0→1 on sad, reversed on exit
    _droopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Transition: 0→1 on state change for smooth colour lerp
    _transitionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _phase      = _phaseCtrl.drive(CurveTween(curve: Curves.linear));
    _bounce     = _bounceCtrl.drive(CurveTween(curve: Curves.easeInOut));
    _droop      = _droopCtrl.drive(CurveTween(curve: Curves.easeOut));
    _transition = _transitionCtrl.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _phaseCtrl.dispose();
    _bounceCtrl.dispose();
    _droopCtrl.dispose();
    _transitionCtrl.dispose();
    _autoReturnTimer?.cancel();
    super.dispose();
  }

  // ── State machine ─────────────────────────────────────────

  /// Transition to a new animation state smoothly.
  void _transitionTo(WormAnimationState next) {
    if (_currentState == next) return;
    _autoReturnTimer?.cancel();

    setState(() => _currentState = next);
    widget.onStateChanged?.call(next);

    // Animate cross-fade
    _transitionCtrl.forward(from: 0);

    switch (next) {
      case WormAnimationState.idle:
        _phaseCtrl.duration = const Duration(milliseconds: 2800);
        _droopCtrl.reverse();
        _bounceCtrl.duration = const Duration(milliseconds: 900);
        break;

      case WormAnimationState.happy:
        _phaseCtrl.duration = const Duration(milliseconds: 1100);
        _droopCtrl.reverse();
        _bounceCtrl.duration = const Duration(milliseconds: 450);
        _spawnParticles();
        break;

      case WormAnimationState.sad:
        _phaseCtrl.duration = const Duration(milliseconds: 2400);
        _droopCtrl.forward();
        _bounceCtrl.duration = const Duration(milliseconds: 1800);
        break;
    }

    // Schedule auto-return to idle
    final returnAfter = next.autoReturnAfter;
    if (returnAfter != null) {
      _autoReturnTimer = Timer(returnAfter, () {
        if (mounted) _transitionTo(WormAnimationState.idle);
      });
    }
  }

  // ── Particles ─────────────────────────────────────────────

  void _spawnParticles() {
    setState(() {
      _particles.clear();
      for (int i = 0; i < 14; i++) {
        _particles.add(_Particle());
      }
    });
    // Remove after animation completes
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _particles.clear());
    });
  }

  // ── Gesture handling ──────────────────────────────────────

  /// Determines which zone was tapped.
  /// The worm is horizontally centred; head occupies left ~30 % of the worm.
  void _onTap(TapUpDetails details, Size canvasSize) {
    // The worm spans roughly 85 % of the canvas width, centred.
    final double wormLeft  = canvasSize.width * 0.075;
    final double wormWidth = canvasSize.width * 0.85;
    final double tapX      = details.localPosition.dx;

    // Head zone: first 30 % of the worm width
    final double headZoneEnd = wormLeft + wormWidth * 0.30;

    if (tapX <= headZoneEnd) {
      _transitionTo(WormAnimationState.happy);
    } else {
      _transitionTo(WormAnimationState.sad);
    }
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── State label ──────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _currentState.label,
            key: ValueKey(_currentState),
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Worm canvas ──────────────────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            final double canvasW = constraints.maxWidth;
            const double canvasH = 200.0;

            return GestureDetector(
              // Tap to trigger animation zones
              onTapUp: (d) => _onTap(d, Size(canvasW, canvasH)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow halo behind worm
                  _GlowHalo(state: _currentState),

                  // Main worm drawn via CustomPainter
                  SizedBox(
                    width: canvasW,
                    height: canvasH,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _phaseCtrl,
                        _bounceCtrl,
                        _droopCtrl,
                        _transitionCtrl,
                      ]),
                      builder: (_, __) => CustomPaint(
                        painter: WormPainter(
                          phase: _phase.value,
                          bounce: _bounce.value,
                          droop: _droop.value,
                          state: _currentState,
                          transitionT: _transition.value,
                        ),
                      ),
                    ),
                  ),

                  // Particle burst overlay (happy state)
                  if (_particles.isNotEmpty)
                    Positioned.fill(
                      child: _ParticleBurst(
                        particles: _particles,
                        color: AppTheme.accent,
                      ),
                    ),

                  // ── Tap zone hints (debug-style translucent overlays) ──
                  // Comment these out in production
                  Positioned(
                    left: canvasW * 0.075,
                    top: 0,
                    width: canvasW * 0.85 * 0.30,
                    height: canvasH,
                    child: _TapHint(label: 'HEAD', color: AppTheme.primary),
                  ),
                  Positioned(
                    left: canvasW * 0.075 + canvasW * 0.85 * 0.30,
                    top: 0,
                    width: canvasW * 0.85 * 0.70,
                    height: canvasH,
                    child: _TapHint(label: 'BODY', color: AppTheme.secondary),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // ── Quick action chips ────────────────────────────
        Wrap(
          spacing: 10,
          children: [
            _StateChip(
              label: '😊 Tap Head',
              color: AppTheme.primary,
              onTap: () => _transitionTo(WormAnimationState.happy),
            ),
            _StateChip(
              label: '😢 Tap Body',
              color: AppTheme.secondary,
              onTap: () => _transitionTo(WormAnimationState.sad),
            ),
            _StateChip(
              label: '😴 Idle',
              color: AppTheme.textSecondary,
              onTap: () => _transitionTo(WormAnimationState.idle),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Supporting Widgets ──────────────────────────────────────

/// Animated glow halo — colour follows worm state.
class _GlowHalo extends StatelessWidget {
  final WormAnimationState state;
  const _GlowHalo({required this.state});

  Color get _color {
    switch (state) {
      case WormAnimationState.idle:  return AppTheme.primary;
      case WormAnimationState.happy: return AppTheme.accent;
      case WormAnimationState.sad:   return AppTheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 260,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(120),
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.22),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

/// Small translucent overlay showing tap zones (remove in prod).
class _TapHint extends StatelessWidget {
  final String label;
  final Color color;
  const _TapHint({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        border: Border.all(color: color.withOpacity(0.10), width: 1),
      ),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.4),
          fontSize: 9,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Chip shortcut to trigger an animation state.
class _StateChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _StateChip(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ── Particle System ─────────────────────────────────────────

import 'dart:math' as math;

/// A single confetti particle.
class _Particle {
  static final _rng = math.Random();

  final double dx = (_rng.nextDouble() - 0.5) * 140;
  final double dy = -(_rng.nextDouble() * 80 + 40);
  final double size = _rng.nextDouble() * 7 + 4;
  final Color color = [
    AppTheme.primary,
    AppTheme.accent,
    AppTheme.secondary,
    Colors.white,
  ][_rng.nextInt(4)];
  final double rotSpeed = (_rng.nextDouble() - 0.5) * 2;
}

class _ParticleBurst extends StatefulWidget {
  final List<_Particle> particles;
  final Color color;
  const _ParticleBurst(
      {required this.particles, required this.color});

  @override
  State<_ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<_ParticleBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: widget.particles,
            progress: _anim.value,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  const _ParticlePainter(
      {required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint();

    for (final p in particles) {
      final opacity = (1 - progress).clamp(0.0, 1.0);
      paint.color = p.color.withOpacity(opacity);

      final x = cx + p.dx * progress;
      final y = cy + p.dy * progress + 60 * progress * progress; // gravity
      final rot = progress * p.rotSpeed * math.pi * 4;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.5,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
