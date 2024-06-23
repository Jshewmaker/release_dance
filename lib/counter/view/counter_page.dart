// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_support_repository/app_support_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app_store_review/app_store_review.dart';
import 'package:release_dance/counter/counter.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_dance/settings/settings.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  factory CounterPage.pageBuilder(_, __) {
    return const CounterPage(
      key: Key('counter_page'),
    );
  }

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(
          create: (context) => AppStoreReviewBloc(
            context.read<AppSupportRepository>(),
          ),
        ),
      ],
      child: const CounterView(),
    );
  }
}

@visibleForTesting
class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return BlocListener<AppStoreReviewBloc, AppStoreReviewState>(
      listener: (context, state) {
        if (state.isUnavailable) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.inAppReviewUnavailable)),
            );
        }
      },
      child: Stack(
        children: [
          const _GradientBackground(),
          Scaffold(
            appBar: AppBar(
              iconTheme: theme.iconTheme.copyWith(color: AppColors.white),
              centerTitle: true,
              leading: const _LogoutButton(),
              actions: const <Widget>[
                _AppStoreReviewButton(),
                _SettingsButton(),
                _DeleteAccountButton(),
              ],
              title: Text(
                l10n.counterAppBarTitle,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            backgroundColor: AppColors.transparent,
            body: const Center(
              child: ScrollableColumn(
                children: [
                  Spacer(),
                  CounterText(),
                  Spacer(),
                  _CounterButtonRow(),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.watch<CounterBloc>().state;
    return Text(
      '$count',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: AppColors.white,
        fontSize: 150,
      ),
    );
  }
}

class _CounterButtonRow extends StatelessWidget {
  const _CounterButtonRow();

  @override
  Widget build(BuildContext context) {
    final decrementButton = _CounterButton(
      key: const Key('counterView_decrement_counterButton'),
      onPressed: () => context.read<CounterBloc>().add(CounterEvent.decrement),
      child: const Icon(Icons.remove, size: 42, color: AppColors.white),
    );
    final incrementButton = _CounterButton(
      key: const Key('counterView_increment_counterButton'),
      onPressed: () => context.read<CounterBloc>().add(CounterEvent.increment),
      child: const Icon(Icons.add, size: 42, color: AppColors.white),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [decrementButton, incrementButton],
    );
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            colors: [AppColors.skyBlue, AppColors.oceanBlue],
          ),
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.white, width: 5),
        ),
        padding: const EdgeInsets.all(AppSpacing.xlg),
      ),
      onPressed: onPressed,
      child: child,
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

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('counterPage_settings_iconButton'),
      icon: const Icon(Icons.settings),
      onPressed: () => context.goNamed(SettingsPage.routeName),
    );
  }
}