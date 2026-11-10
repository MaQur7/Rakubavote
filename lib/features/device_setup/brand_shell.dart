import 'package:flutter/material.dart';

import '../../core/brand/brand.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

/// The front door of the app (first run and PIN unlock): an Ink brand panel
/// with the logo, the tagline and the mat weave, beside the form. On narrow
/// screens the panel becomes a header.
class BrandShell extends StatelessWidget {
  const BrandShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tagline = Text(
      t.tagline,
      style: rakubaText(
        context,
        RakubaType.name,
        bold: true,
        colour: RakubaColors.paper,
      ),
    );
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, box) {
          final wide = box.maxWidth >= 960;
          final form = SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: child,
              ),
            ),
          );
          if (!wide) {
            return Column(
              children: [
                ColoredBox(
                  color: RakubaColors.ink,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(RakubaSpace.m),
                      child: Row(
                        children: [
                          const RakubaLogo(
                            onDark: true,
                            markSize: RakubaSpace.xl,
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              t.tagline,
                              textAlign: TextAlign.end,
                              style: rakubaText(
                                context,
                                RakubaType.body,
                                colour: RakubaColors.lightThatch,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: form),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Panel width: 2 of 5, columns one bay wide.
              Expanded(
                flex: 2,
                child: ColoredBox(
                  color: RakubaColors.ink,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(RakubaSpace.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const RakubaLogo(
                                onDark: true,
                                markSize: RakubaSpace.xxl,
                              ),
                              const SizedBox(height: RakubaSpace.xl),
                              const RoofLine(colour: RakubaColors.lightThatch),
                              const SizedBox(height: RakubaSpace.m),
                              tagline,
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Lower third: the mat weave, with nothing set over it.
                        const Expanded(
                          flex: 2,
                          child: MatWeave(colour: RakubaColors.lightThatch),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 3, child: form),
            ],
          );
        },
      ),
    );
  }
}
