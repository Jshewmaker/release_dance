import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_dance/home/home.dart';
import 'package:release_dance/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  factory HomePage.pageBuilder(_, __) {
    return const HomePage(
      key: Key('home_page'),
    );
  }

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

@visibleForTesting
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.releaseAppBarTitle,
        ),
        actions: [
          MaterialButton(
            height: 20,
            shape: const CircleBorder(),
            color: AppColors.greyPrimary,
            textColor: AppColors.black,
            onPressed: () {},
            child: const Text('3'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: ScrollableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _WelcomeHeader(),
            const SizedBox(height: AppSpacing.xxlg),
            _SectionHeader(text: l10n.upcomingClasses),
            const SizedBox(height: AppSpacing.sm),
            const _ClassCard(),
            const SizedBox(height: AppSpacing.xlg),
            _SectionHeader(text: l10n.specialEvents),
            const SizedBox(height: AppSpacing.sm),
            const _PrideCard(),
            const SizedBox(height: AppSpacing.sm),
            const _GiveAway(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.status == UserStatus.loading) {
          return const CircularProgressIndicator();
        }
        if (state.status == UserStatus.error) {
          return Text(
            'Welcome!',
            style: theme.textTheme.headlineSmall,
          );
        }
        if (state.status == UserStatus.loaded) {
          return Text(
            'Welcome ${state.user?.firstName}!',
            style: theme.textTheme.displayMedium,
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headlineSmall,
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(Assets.images.releaseStudio.path),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              AppColors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        height: 200,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hip Hop Beg/Int Class',
                    style: theme.textTheme.displayMedium,
                  ),
                  const Text(
                    'Monday 6:00 PM - Janet',
                    style: TextStyle(color: AppColors.white),
                  ),
                  const Text(
                    'Release - Ferndale',
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrideCard extends StatelessWidget {
  const _PrideCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.asset(
        Assets.images.pridePromo.path,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class _GiveAway extends StatelessWidget {
  const _GiveAway();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.asset(
        Assets.images.summerGiveaway.path,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
