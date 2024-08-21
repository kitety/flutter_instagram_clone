import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

import 'app/app.dart';

typedef AppBuilder = FutureOr<Widget> Function(PowerSyncRepository);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logD('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logD('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  AppBuilder builder, {
  required AppFlavor appFlavor,
  required FirebaseOptions options,
}) async {
  FlutterError.onError = (details) {
    logD(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupDi(appFlavor: appFlavor);

    await Firebase.initializeApp(options: options);

    final powersyncRepository = PowerSyncRepository(env: appFlavor.getEnv);
    await powersyncRepository.initialize();

    SystemUiOverlayTheme.setPortraitOrientation();

    runApp(await builder(powersyncRepository));
  }, (error, stack) {
    logE(error.toString(), stackTrace: stack);
  });
}
