import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';

/// Locales whose app strings exist in lib/l10n but which Flutter's own
/// Material/Cupertino/Widgets localizations do not cover. Framework strings
/// (tooltips, date pickers) fall back to English for these.
const _frameworkFallback = {'din'};

class _FallbackDelegate<T> extends LocalizationsDelegate<T> {
  const _FallbackDelegate(this.inner);
  final LocalizationsDelegate<T> inner;

  @override
  bool isSupported(Locale locale) =>
      inner.isSupported(locale) || _frameworkFallback.contains(locale.languageCode);

  @override
  Future<T> load(Locale locale) => inner.load(
        _frameworkFallback.contains(locale.languageCode) ? const Locale('en') : locale,
      );

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;

  @override
  Type get type => T;
}

const List<LocalizationsDelegate<dynamic>> rakubaLocalizationsDelegates = [
  AppLocalizations.delegate,
  _FallbackDelegate<MaterialLocalizations>(GlobalMaterialLocalizations.delegate),
  _FallbackDelegate<CupertinoLocalizations>(GlobalCupertinoLocalizations.delegate),
  _FallbackDelegate<WidgetsLocalizations>(GlobalWidgetsLocalizations.delegate),
];

@visibleForTesting
bool isRtl(Locale locale) => locale.languageCode == 'ar';
