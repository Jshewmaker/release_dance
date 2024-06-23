// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_dance/onboarding/onboarding.dart';

enum OnboardingState { initial, welcomeComplete, featuresComplete }

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  factory OnboardingPage.pageBuilder(_, __) {
    return const OnboardingPage(
      key: Key('onBoarding_page'),
    );
  }

  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return const FlowBuilder<OnboardingState>(
      state: OnboardingState.initial,
      onGeneratePages: onGenerateOnboardingPages,
    );
  }
}

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  static Page<void> page() {
    return const MaterialPage<void>(child: OnboardingWelcome());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: ScrollableColumn(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Assets.images.onboardingWelcome.image(),
              ),
            ],
          ),
          const Spacer(flex: 5),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.onboardingWelcomeTitle,
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: AppSpacing.xlg),
                Text(l10n.onboardingWelcomeSubtitle),
              ],
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _PageIndicator(state: OnboardingState.initial),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.xxlg,
                  ),
                ),
                onPressed: () => context
                    .flow<OnboardingState>()
                    .update((_) => OnboardingState.welcomeComplete),
                child: Text(l10n.onboardingNextButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingFeatures extends StatelessWidget {
  const OnboardingFeatures({super.key});

  static Page<void> page() {
    return const MaterialPage<void>(child: OnboardingFeatures());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ScrollableColumn(
          children: [
            Assets.images.onboardingFeatures.image(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xlg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.onboardingFeaturesTitle,
                    style: theme.textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _PageIndicator(state: OnboardingState.welcomeComplete),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.xxlg,
                  ),
                ),
                onPressed: () => context
                    .flow<OnboardingState>()
                    .update((_) => OnboardingState.featuresComplete),
                child: Text(l10n.onboardingNextButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSummary extends StatelessWidget {
  const OnboardingSummary({super.key});

  static Page<void> page() {
    return const MaterialPage<void>(child: OnboardingSummary());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: ScrollableColumn(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Assets.images.onboardingSummary.image(),
              ),
            ],
          ),
          const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.onboardingSummaryTitle,
                  style: theme.textTheme.displayMedium,
                ),
              ],
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _PageIndicator(state: OnboardingState.featuresComplete),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.xxlg,
                  ),
                ),
                onPressed: () {
                  context.read<AppBloc>().add(const AppOnboardingCompleted());
                },
                child: Text(l10n.onboardingNextButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final value in OnboardingState.values) ...[
          _PageIndicatorDot(filled: value != state),
          const SizedBox(width: AppSpacing.md),
        ],
      ],
    );
  }
}

class _PageIndicatorDot extends StatelessWidget {
  const _PageIndicatorDot({this.filled = false});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.black,
      ),
      child: filled
          ? null
          : Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                ),
                child: const Material(
                  color: Colors.transparent,
                  type: MaterialType.circle,
                ),
              ),
            ),
    );
  }
}
