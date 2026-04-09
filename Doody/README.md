# 🐛 Worm World — Flutter App

Interactive 3-D worm companion with 5-page navigation.

---

## 📁 Project Structure

```
lib/
├── main.dart                        ← App entry, theme, orientation
├── theme/
│   └── app_theme.dart               ← Colour palette, text styles, ThemeData
├── models/
│   └── worm_animation_state.dart    ← WormAnimationState enum + extensions
├── navigation/
│   └── app_shell.dart               ← Root PageView + BottomNav shell
├── screens/
│   ├── home_screen.dart             ← Page 1: Worm + stat cards
│   ├── explore_screen.dart          ← Page 2: Biome grid
│   ├── garden_screen.dart           ← Page 3: Plant watering
│   ├── shop_screen.dart             ← Page 4: Cosmetics shop
│   └── profile_screen.dart          ← Page 5: XP + achievements
└── widgets/
    ├── worm_3d_widget.dart          ← Main interactive worm (CustomPainter)
    ├── worm_painter.dart            ← CustomPainter drawing logic
    ├── custom_bottom_nav.dart       ← Frosted-glass bottom nav bar
    └── model_viewer_worm.dart       ← Optional: real .glb model widget

assets/
├── models/
│   └── worm.glb                    ← (you supply this — see below)
├── sounds/
│   ├── happy.mp3                   ← Optional sound effects
│   └── sad.mp3
└── images/
```

---

## 🚀 Quick Start

### 1. Install Flutter
```bash
flutter --version   # must be ≥ 3.0
```

### 2. Clone / copy this project, then:
```bash
flutter pub get
flutter run
```

### 3. Required assets
Create the asset folders even if empty:
```bash
mkdir -p assets/models assets/sounds assets/images
```

The app ships with a **procedural CustomPainter worm** that requires no
external file.  To use a real 3-D model, see the section below.

---

## 🐛 Worm Animations

| State   | Trigger            | Behaviour                        |
|---------|--------------------|----------------------------------|
| **Idle**  | Default            | Gentle sinusoidal body wave + bob |
| **Happy** | Tap HEAD zone      | Fast bounce, amber colour, particles |
| **Sad**   | Tap BODY zone      | Slow droop, lavender colour       |

Both zone overlays are visible for dev convenience. Remove the
`_TapHint` widgets in `worm_3d_widget.dart` for production.

---

## 🌐 Navigation

| Method            | Behaviour                              |
|-------------------|----------------------------------------|
| **Swipe left**    | Next page                              |
| **Swipe right**   | Previous page                          |
| **Bottom nav tap**| Jump to any page                       |

Both methods share a single `PageController` — they are always in sync.

---

## 🎲 Using a Real .GLB Model (Optional)

1. Obtain a worm `.glb` with animations named **"Idle"**, **"Happy"**, **"Sad"**.
   - Free sources: Sketchfab (CC0), Quaternius, Google Poly Archive.

2. Place it at `assets/models/worm.glb`.

3. In `home_screen.dart`, replace:
   ```dart
   Worm3DWidget(onStateChanged: ...)
   ```
   with:
   ```dart
   ModelViewerWorm(onStateChanged: ...)
   ```

4. Android — add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

5. The `ModelViewerWorm` uses transparent background so the
   parent gradient shows through.

---

## 📦 Dependencies

| Package                  | Purpose                        |
|--------------------------|--------------------------------|
| `model_viewer_plus`      | Renders `.glb` GLTF models     |
| `smooth_page_indicator`  | Page indicator dots (optional) |
| `audioplayers`           | Sound effects on state change  |
| `lottie`                 | 2-D animation overlays         |
| `shared_preferences`     | Persist user state             |

---

## 🎨 Adding Sound Effects

```dart
// In worm_3d_widget.dart _transitionTo():
import 'package:audioplayers/audioplayers.dart';

final _player = AudioPlayer();

case WormAnimationState.happy:
  await _player.play(AssetSource('sounds/happy.mp3'));
  break;
case WormAnimationState.sad:
  await _player.play(AssetSource('sounds/sad.mp3'));
  break;
```

---

## 🛠️ Troubleshooting

| Issue | Fix |
|-------|-----|
| Worm not visible | Check `SafeArea` isn't clipping canvas |
| Particles not showing | Ensure `_particles.isNotEmpty` check passes |
| GLB model blank | Verify `INTERNET` permission (Android) + correct src path |
| Nav bar not syncing | Confirm single `PageController` instance in `AppShell` |

---

## 📜 License
MIT — free to use in personal and commercial projects.
