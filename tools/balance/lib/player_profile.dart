import 'package:meta/meta.dart';

/// How a modelled player behaves.
///
/// These are the assumptions the whole simulation rests on, so they are stated
/// here rather than buried in the runner. They are guesses about human
/// behaviour, not measurements — once analytics land (`T-064`) they should be
/// replaced with the real distribution.
@immutable
class PlayerProfile {
  const PlayerProfile({
    required this.name,
    required this.sessionsPerDay,
    required this.sessionLength,
    required this.offlineCapMultiplier,
  });

  final String name;

  /// How many times a day they open the game.
  final int sessionsPerDay;

  /// How long they stay each time.
  final Duration sessionLength;

  /// VIP extension of the offline cap. 1.0 means no purchase.
  final double offlineCapMultiplier;

  /// Time spent away between two sessions, assuming they are spread evenly
  /// across a waking day rather than a full 24 hours.
  Duration get gapBetweenSessions {
    const wakingHours = 16;
    final totalPlay = sessionLength * sessionsPerDay;
    final away = const Duration(hours: wakingHours) - totalPlay;
    final gaps = sessionsPerDay;
    return Duration(microseconds: away.inMicroseconds ~/ gaps);
  }

  /// The overnight gap, which is what usually hits the offline cap.
  Duration get overnightGap => const Duration(hours: 8);

  static const casual = PlayerProfile(
    name: 'casual',
    sessionsPerDay: 2,
    sessionLength: Duration(minutes: 5),
    offlineCapMultiplier: 1,
  );

  static const active = PlayerProfile(
    name: 'active',
    sessionsPerDay: 6,
    sessionLength: Duration(minutes: 15),
    offlineCapMultiplier: 1,
  );

  static const whale = PlayerProfile(
    name: 'whale',
    sessionsPerDay: 10,
    sessionLength: Duration(minutes: 20),
    offlineCapMultiplier: 3,
  );

  static const List<PlayerProfile> all = [casual, active, whale];

  static PlayerProfile? byName(String name) {
    for (final profile in all) {
      if (profile.name == name) return profile;
    }
    return null;
  }
}
