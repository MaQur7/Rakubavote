import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// The long beep after a vote is saved. Uses the bundled tone where audio
/// playback is available and falls back to the system alert sound.
abstract class Beep {
  Future<void> play();
}

class AssetBeep implements Beep {
  final _player = AudioPlayer();

  @override
  Future<void> play() async {
    try {
      if (Platform.isAndroid || Platform.isWindows || Platform.isLinux) {
        await _player.play(AssetSource('sounds/end_beep.wav'));
        return;
      }
    } catch (_) {
      // Fall through to the system sound.
    }
    await SystemSound.play(SystemSoundType.alert);
  }
}

/// Silent beep for tests.
class SilentBeep implements Beep {
  int plays = 0;
  @override
  Future<void> play() async => plays++;
}
