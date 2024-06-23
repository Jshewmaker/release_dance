// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_dance/theme_selector/theme_selector.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsAppBarTitle,
          style: theme.textTheme.displayMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxxlg,
          horizontal: AppSpacing.xlg,
        ),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_4_rounded),
              title: Text(l10n.settingsThemeListItemTitle),
              trailing: const ThemeSelector(),
            ),
          ],
        ),
      ),
    );
  }
}
