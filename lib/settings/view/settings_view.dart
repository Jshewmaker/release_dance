// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app_store_review/app_store_review.dart';
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
            const _DeleteAccountButton(),
            const _LogoutButton(),
            const _AppStoreReviewButton(),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('counterPage_deleteAccount_iconButton'),
      icon: const Icon(Icons.delete),
      onPressed: () => context.read<AppBloc>().add(
            const AppUserAccountDeleted(),
          ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('counterPage_logout_iconButton'),
      icon: const Icon(Icons.logout),
      onPressed: () => context.read<AppBloc>().add(const AppLogoutRequested()),
    );
  }
}

class _AppStoreReviewButton extends StatelessWidget {
  const _AppStoreReviewButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('counterPage_inAppReview_iconButton'),
      icon: const Icon(Icons.star),
      onPressed: () {
        context.read<AppStoreReviewBloc>().add(const AppStoreReviewRequested());
      },
    );
  }
}
