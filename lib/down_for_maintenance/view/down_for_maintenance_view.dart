// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:release_dance/l10n/l10n.dart';

class DownForMaintenanceView extends StatelessWidget {
  const DownForMaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Center(child: DownForMaintenanceCard()),
        ),
      ),
    );
  }
}

class DownForMaintenanceCard extends StatelessWidget {
  @visibleForTesting
  const DownForMaintenanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.downForMaintenanceTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.downForMaintenanceSubtitle),
          ],
        ),
      ),
    );
  }
}
