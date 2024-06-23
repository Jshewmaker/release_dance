// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/connectivity/connectivity.dart';
import 'package:release_dance/l10n/l10n.dart';

class _MockConnectivityBloc
    extends MockBloc<ConnectivityEvent, ConnectivityState>
    implements ConnectivityBloc {}

void main() {
  group('ConnectivityOverlayView', () {
    late ConnectivityBloc connectivityBloc;
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      connectivityBloc = _MockConnectivityBloc();
      when(() => connectivityBloc.state).thenReturn(ConnectivityState.online);
      navigatorKey = GlobalKey();
    });

    Widget buildSubject() {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorKey: navigatorKey,
        home: BlocProvider.value(
          value: connectivityBloc,
          child: Scaffold(
            body: ConnectivityOverlayView(
              navigatorKey: navigatorKey,
              child: const SizedBox(),
            ),
          ),
        ),
      );
    }

    group('renders', () {
      testWidgets('overlay and hides overlay when going from online to offline',
          (tester) async {
        final connectivityController = StreamController<ConnectivityState>();
        whenListen(
          connectivityBloc,
          connectivityController.stream,
          initialState: ConnectivityState.online,
        );
        await tester.pumpWidget(buildSubject());
        connectivityController.add(ConnectivityState.offline);
        await tester.pumpAndSettle();
        expect(find.byType(NoConnectivityBanner), findsOneWidget);

        connectivityController.add(ConnectivityState.online);
        await tester.pumpAndSettle();
        expect(find.byType(NoConnectivityBanner), findsNothing);
      });

      testWidgets('overlay and hides overlay when going from online to unknown',
          (tester) async {
        final connectivityController = StreamController<ConnectivityState>();
        whenListen(
          connectivityBloc,
          connectivityController.stream,
          initialState: ConnectivityState.online,
        );
        await tester.pumpWidget(buildSubject());
        connectivityController.add(ConnectivityState.offline);
        await tester.pumpAndSettle();
        expect(find.byType(NoConnectivityBanner), findsOneWidget);

        connectivityController.add(ConnectivityState.unknown);
        await tester.pumpAndSettle();
        expect(find.byType(NoConnectivityBanner), findsNothing);
      });

      testWidgets('overlay when switching to offline in app background',
          (tester) async {
        final connectivityController = StreamController<ConnectivityState>();
        whenListen(
          connectivityBloc,
          connectivityController.stream,
          initialState: ConnectivityState.online,
        );
        await tester.pumpWidget(buildSubject());
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        connectivityController.add(ConnectivityState.offline);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpAndSettle();
        expect(find.byType(NoConnectivityBanner), findsOneWidget);

        connectivityController.add(ConnectivityState.online);
        await tester.pumpAndSettle();
        expect(find.byType(NoConnectivityBanner), findsNothing);
      });
    });
  });
}
