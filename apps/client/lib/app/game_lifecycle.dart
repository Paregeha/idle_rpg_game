import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// Starts the game loop and ties it to the app's lifecycle.
///
/// Wraps the whole app rather than living in a screen: the loop must keep
/// running while the player is on any tab, and must stop when the app is not
/// on screen at all.
class GameLifecycle extends ConsumerStatefulWidget {
  const GameLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<GameLifecycle> createState() => _GameLifecycleState();
}

class _GameLifecycleState extends ConsumerState<GameLifecycle>
    with WidgetsBindingObserver {
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
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final controller = ref.read(gameControllerProvider.notifier);

    switch (lifecycle) {
      case AppLifecycleState.resumed:
        controller.onResumed();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // A 30 Hz timer behind a locked screen burns battery for a screen
        // nobody is looking at, and earns the player nothing the offline
        // calculation would not give them on the way back.
        controller.onPaused();
    }
  }

  @override
  Widget build(BuildContext context) {
    // The loop cannot start until the balance config has loaded.
    ref.listen(balanceConfigProvider, (previous, next) {
      if (!next.hasValue) return;
      final controller = ref.read(gameControllerProvider.notifier);
      // Restore before ticking: starting a fresh game and then loading a save
      // over it would briefly show the wrong numbers.
      controller.restore().then((_) {
        controller
          ..startTicking()
          ..startAutosave();
      });
    });

    final config = ref.watch(balanceConfigProvider);

    return config.when(
      loading: () => const _Boot(message: 'Lighting the forge'),
      error: (error, _) => _Boot(message: 'Balance failed to load:\n$error'),
      data: (_) => widget.child,
    );
  }
}

class _Boot extends StatelessWidget {
  const _Boot({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
