import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'core/core.dart';
import 'core/dependencies/injections.dart';

Future<void> bootstrap(Environment environment) async {
  final enableLogging = environment.enableLogging;

  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Inicializa las dependencias
      DependencyInjection.init();

      const app = QikCart();
      runApp(app);

      FlutterError.onError = (details) {
        if (enableLogging) {
          log(details.exceptionAsString(), stackTrace: details.stack);
        }
      };
    },
    (error, stack) {
      if (enableLogging) {
        log(error.toString(), stackTrace: stack);
      }
    },
  );
}
