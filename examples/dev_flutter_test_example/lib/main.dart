import 'package:dev_flutter_test/test_ui.dart';

Future<void> main(List<String> args) async {
  mainFlutterUiTest(() {
    group('example', () {
      test('expect', () {
        expect(1, 1);
      });
      test('nothing', () {});
      test('fail', () {
        fail('too bad');
      });
    });
  }, showConsole: true);
}
