// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

Storage createMockStorage() {
  final storage = MockStorage();
  when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  return storage;
}

void mockHydratedStorage({Storage? storage}) {
  HydratedBloc.storage = storage ?? createMockStorage();
}
