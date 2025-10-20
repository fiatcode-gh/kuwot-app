import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kuwot/core/app_updater.dart';
import 'package:kuwot/features/in_app_update/presentation/bloc/in_app_update_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAppUpdater extends Mock implements AppUpdater {}

void main() {
  late MockAppUpdater mockAppUpdater;
  late InAppUpdateBloc bloc;

  setUp(() {
    mockAppUpdater = MockAppUpdater();
    bloc = InAppUpdateBloc(appUpdater: mockAppUpdater);
  });

  test('initial state should be InAppUpdateInitialState', () {
    // assert
    expect(bloc.state, const InAppUpdateInitialState());
  });

  group('InAppUpdateCheck', () {
    test(
      'should emit [Check, UpdateAvailable] when update is available',
      () async {
        // arrange
        final tAppUpdateInfo = AppUpdateInfo(
          updateAvailability: UpdateAvailability.updateAvailable,
          immediateUpdateAllowed: true,
          immediateAllowedPreconditions: [],
          flexibleUpdateAllowed: true,
          flexibleAllowedPreconditions: [],
          availableVersionCode: 1,
          installStatus: InstallStatus.pending,
          packageName: 'com.example.app',
          clientVersionStalenessDays: 1,
          updatePriority: 1,
        );
        when(
          () => mockAppUpdater.checkForUpdate(),
        ).thenAnswer((_) async => tAppUpdateInfo);

        // expect later
        final expected = [
          const InAppUpdateCheckingState(),
          const InAppUpdateAvailableState(),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const InAppUpdateCheckEvent());
      },
    );

    test(
      'should emit [Check, UpdateUnavailable] when update is not available',
      () async {
        // arrange
        final tAppUpdateInfo = AppUpdateInfo(
          updateAvailability: UpdateAvailability.updateNotAvailable,
          immediateUpdateAllowed: true,
          immediateAllowedPreconditions: [],
          flexibleUpdateAllowed: true,
          flexibleAllowedPreconditions: [],
          availableVersionCode: 1,
          installStatus: InstallStatus.pending,
          packageName: 'com.example.app',
          clientVersionStalenessDays: 1,
          updatePriority: 1,
        );
        when(
          () => mockAppUpdater.checkForUpdate(),
        ).thenAnswer((_) async => tAppUpdateInfo);

        // expect later
        final expected = [
          const InAppUpdateCheckingState(),
          const InAppUpdateUnavailableState(),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const InAppUpdateCheckEvent());
      },
    );
  });

  group('InAppUpdateStart', () {});
}
