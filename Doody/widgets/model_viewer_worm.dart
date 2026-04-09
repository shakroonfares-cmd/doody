// ============================================================
//  widgets/model_viewer_worm.dart
//
//  OPTIONAL — Drop-in replacement for the CustomPainter worm.
//  Uses model_viewer_plus to render a real .glb 3-D model
//  with native GLTF animation playback.
//
//  Setup:
//   1. Add to pubspec.yaml:
//        model_viewer_plus: ^1.7.0
//   2. Place your worm.glb at:
//        assets/models/worm.glb
//      (or use the hosted URL option below)
//   3. Android: add to AndroidManifest.xml inside <application>:
//        <uses-permission android:name="android.permission.INTERNET"/>
//   4. iOS: no extra config needed.
//   5. Replace Worm3DWidget in home_screen.dart with
//      ModelViewerWorm.
//
//  Animation names must match those exported in the .glb:
//    "Idle", "Happy", "Sad"
// ============================================================

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../models/worm_animation_state.dart';
import '../theme/app_theme.dart';

class ModelViewerWorm extends StatefulWidget {
  final ValueChanged<WormAnimationState>? onStateChanged;

  const ModelViewerWorm({super.key, this.onStateChanged});

  @override
  State<ModelViewerWorm> createState() => _ModelViewerWormState();
}

class _ModelViewerWormState extends State<ModelViewerWorm> {
  WormAnimationState _state = WormAnimationState.idle;

  /// Maps our enum to the animation clip name in the .glb file.
  String get _animationName {
    switch (_state) {
      case WormAnimationState.idle:  return 'Idle';
      case WormAnimationState.happy: return 'Happy';
      case WormAnimationState.sad:   return 'Sad';
    }
  }

  void _changeState(WormAnimationState next) {
    setState(() => _state = next);
    widget.onStateChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 3-D Model ─────────────────────────────────────
        SizedBox(
          height: 280,
          child: Stack(
            children: [
              // Head tap zone (left 35 %)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.35,
                child: GestureDetector(
                  onTap: () => _changeState(WormAnimationState.happy),
                  child: Container(color: Colors.transparent),
                ),
              ),

              // Body tap zone (right 65 %)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.65,
                child: GestureDetector(
                  onTap: () => _changeState(WormAnimationState.sad),
                  child: Container(color: Colors.transparent),
                ),
              ),

              // The actual 3-D viewer — absorbs pointer so
              // gesture detectors above take priority.
              IgnorePointer(
                child: ModelViewer(
                  // ── Local asset (recommended) ──────────
                  src: 'assets/models/worm.glb',

                  // ── OR hosted CDN URL ──────────────────
                  // src: 'https://your-cdn.com/worm.glb',

                  alt: 'A 3-D worm model',
                  autoPlay: true,
                  animationName: _animationName,

                  // Viewer settings
                  autoRotate: false,
                  cameraControls: false,
                  shadowIntensity: 1,
                  shadowSoftness: 0.8,
                  exposure: 0.9,
                  environmentImage: 'neutral',

                  // Transparent background so our gradient shows through
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── State label ─────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _state.label,
            key: ValueKey(_state),
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Manual trigger chips ─────────────────────────
        Wrap(
          spacing: 10,
          children: [
            _chip('😊 Head', AppTheme.primary,
                () => _changeState(WormAnimationState.happy)),
            _chip('😢 Body', AppTheme.secondary,
                () => _changeState(WormAnimationState.sad)),
            _chip('😴 Idle', AppTheme.textSecondary,
                () => _changeState(WormAnimationState.idle)),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
