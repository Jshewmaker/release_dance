// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';

class ForceUpgradePage extends StatelessWidget {
  const ForceUpgradePage({super.key});

  factory ForceUpgradePage.pageBuilder(_, __) {
    return const ForceUpgradePage(
      key: Key('forceUpgrade_page'),
    );
  }

  static const routeName = '/force-upgrade';

  @override
  Widget build(BuildContext context) {
    return const ForceUpgradeView();
  }
}
