import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/app/router.dart';
import 'package:idle_rpg/app/theme.dart';

void main() {
  runApp(const ProviderScope(child: IdleRpgApp()));
}

class IdleRpgApp extends StatefulWidget {
  const IdleRpgApp({super.key});

  @override
  State<IdleRpgApp> createState() => _IdleRpgAppState();
}

class _IdleRpgAppState extends State<IdleRpgApp> {
  // Built once: rebuilding a GoRouter throws away the navigation stack.
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Idle RPG',
      debugShowCheckedModeBanner: false,
      theme: buildGameTheme(),
      routerConfig: _router,
      builder: (context, child) {
        final media = MediaQuery.of(context);

        // The layout is built around numbers that must not wrap or clip. At the
        // extremes of the system font-size setting a counter would push its
        // label off the row, so the scale is clamped rather than ignored: large
        // type still works, it just stops before it breaks the screen.
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.3,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
