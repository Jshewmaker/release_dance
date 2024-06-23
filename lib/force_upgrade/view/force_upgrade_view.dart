// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpgradeView extends StatelessWidget {
  const ForceUpgradeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Center(child: ForceUpgradeCard()),
        ),
      ),
    );
  }
}

class ForceUpgradeCard extends StatelessWidget {
  @visibleForTesting
  const ForceUpgradeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.forceUpgradeTitle, style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.forceUpgradeSubtitle),
            const SizedBox(height: AppSpacing.lg),
            const AppStoreButton(),
          ],
        ),
      ),
    );
  }
}

class AppStoreButton extends StatelessWidget {
  @visibleForTesting
  const AppStoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final upgradeUrl = context.select(
      (AppBloc bloc) => bloc.state.forceUpgrade.upgradeUrl,
    );
    if (upgradeUrl == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => launchUrl(Uri.parse(upgradeUrl)),
        child: Text(l10n.forceUpgradeButtonText),
      ),
    );
  }
}
