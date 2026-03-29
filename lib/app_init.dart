import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:works_fm/src/composition/di/feature_modules.dart';
import 'package:works_fm/src/composition/router/app_router.dart';

class AppInit extends StatelessWidget {
  final GetIt it;
  const AppInit({super.key, required this.it});

  @override
  Widget build(BuildContext context) {
    final router = it<AppRouter>().router;
 final featureDelegates = featureModules
        .expand((m) => m.delegates)
        .toList();
    return ShadApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,

      // ── Tema claro ──────────────────────────────────────────
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),

      // ── Tema oscuro ─────────────────────────────────────────
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
      ),

      // Sigue el sistema operativo
      themeMode: ThemeMode.system,

      // ── Localización ──────────────────────────────────────
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: [
        ...featureDelegates,                            // features
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return supported.first;
        return supported.firstWhere(
          (s) => s.languageCode == locale.languageCode,
          orElse: () => supported.first,
        );
      },
    );
  }
}