// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:release_dance/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  factory SettingsPage.pageBuilder(_, __) {
    return const SettingsPage();
  }

  static String get routeName => '/settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}
