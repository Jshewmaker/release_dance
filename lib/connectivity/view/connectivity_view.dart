// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:release_dance/connectivity/connectivity.dart';
import 'package:release_dance/l10n/l10n.dart';

const _overlayHeight = 42;

class ConnectivityOverlay extends StatelessWidget {
  const ConnectivityOverlay({
    required this.child,
    required this.navigatorKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return ConnectivityBloc(
          connectivityRepository: context.read<ConnectivityRepository>(),
        )..add(const ConnectivityRequested());
      },
      child: ConnectivityOverlayView(
        navigatorKey: navigatorKey,
        child: child,
      ),
    );
  }
}

class ConnectivityOverlayView extends StatefulWidget {
  @visibleForTesting
  const ConnectivityOverlayView({
    required this.child,
    required this.navigatorKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<ConnectivityOverlayView> createState() =>
      _ConnectivityOverlayViewState();
}

class _ConnectivityOverlayViewState extends State<ConnectivityOverlayView>
    with WidgetsBindingObserver {
  OverlayState? get overlay => widget.navigatorKey.currentState?.overlay;
  OverlayEntry? overlayEntry;
  bool overlayOpen = false;

  void showOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(builder: (_) => const NoConnectivityBanner());
    overlay?.insert(overlayEntry!);
    setState(() {
      overlayOpen = true;
    });
  }

  void closeOverlay() {
    overlayEntry?.remove();
    setState(() {
      overlayOpen = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<ConnectivityBloc>().add(const ConnectivityRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        switch (state) {
          case ConnectivityState.offline:
            showOverlay(context);
          case ConnectivityState.online:
          case ConnectivityState.unknown:
            closeOverlay();
        }
      },
      child: MediaQuery(
        data: overlayOpen
            ? mediaQueryData.copyWith(
                padding: mediaQueryData.padding.copyWith(
                  bottom: mediaQueryData.padding.bottom + _overlayHeight,
                ),
                viewPadding: mediaQueryData.viewPadding.copyWith(
                  bottom: mediaQueryData.viewPadding.bottom + _overlayHeight,
                ),
              )
            : mediaQueryData,
        child: widget.child,
      ),
    );
  }
}

class NoConnectivityBanner extends StatelessWidget {
  @visibleForTesting
  const NoConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final mediaQueryPadding = MediaQuery.paddingOf(context);
    const minimum = AppSpacing.md;
    final padding = EdgeInsets.only(
      left: math.max(mediaQueryPadding.left, minimum),
      top: math.max(mediaQueryPadding.top, minimum),
      right: math.max(mediaQueryPadding.right, minimum),
      bottom: math.max(mediaQueryPadding.bottom - _overlayHeight, minimum),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: AppColors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: padding,
              child: Text(
                l10n.noNetworkConnectionText,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
