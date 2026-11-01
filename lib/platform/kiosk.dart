import 'dart:io';

import 'package:flutter/services.dart';

/// Locks a booth tablet to the voting screen (Android lock task mode).
/// With the app as device owner the lock is complete; otherwise Android's
/// screen pinning is used. Does nothing on laptops.
abstract final class Kiosk {
  static const _channel = MethodChannel('org.rakubavote/kiosk');

  static bool get supported => Platform.isAndroid;

  /// True when the app is device owner, so the lock cannot be escaped.
  static Future<bool> fullLockAvailable() async {
    if (!supported) return false;
    try {
      return await _channel.invokeMethod<bool>('isDeviceOwner') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> enter() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (!supported) return;
    try {
      await _channel.invokeMethod<bool>('enter');
    } on PlatformException {
      // Screen pinning refused by the user: the booth still works, unlocked.
    } on MissingPluginException {
      // Not available (tests).
    }
  }

  static Future<void> exit() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (!supported) return;
    try {
      await _channel.invokeMethod<bool>('exit');
    } on PlatformException {
      // Already unlocked.
    } on MissingPluginException {
      // Not available (tests).
    }
  }
}
