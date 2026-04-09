// ============================================================
//  models/worm_animation_state.dart
//  Defines all animation states the worm can be in.
// ============================================================

/// The three core animation states for the worm.
enum WormAnimationState {
  idle,   // gentle floating bob — default
  happy,  // energetic bounce + wiggle triggered by head tap
  sad,    // slow droop triggered by body tap
}

/// Metadata about each state used by the widget layer.
extension WormAnimationStateX on WormAnimationState {
  String get label {
    switch (this) {
      case WormAnimationState.idle:  return 'Idle';
      case WormAnimationState.happy: return 'Happy 🎉';
      case WormAnimationState.sad:   return 'Sad 😢';
    }
  }

  /// Duration of one full animation cycle.
  Duration get cycleDuration {
    switch (this) {
      case WormAnimationState.idle:  return const Duration(milliseconds: 2800);
      case WormAnimationState.happy: return const Duration(milliseconds: 1200);
      case WormAnimationState.sad:   return const Duration(milliseconds: 2200);
    }
  }

  /// How long before automatically returning to idle.
  Duration? get autoReturnAfter {
    switch (this) {
      case WormAnimationState.idle:  return null;          // never auto-return
      case WormAnimationState.happy: return const Duration(seconds: 4);
      case WormAnimationState.sad:   return const Duration(seconds: 5);
    }
  }
}
