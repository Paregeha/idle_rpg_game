import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

void main() {
  test('state version starts at 1', () {
    expect(gameCoreStateVersion, 1);
  });
}
