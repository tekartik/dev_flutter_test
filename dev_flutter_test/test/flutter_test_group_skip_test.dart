import 'package:dev_flutter_test/test.dart';

void main() {
  initFlutterTest();
  group('skipped group', () {
    test('never run', () {
      fail('a test of a skipped group ran');
    });
  }, skip: true);
  group('skipped group with a reason', () {
    test('never run', () {
      fail('a test of a skipped group ran');
    });
  }, skip: 'reason');
  group('group', () {
    test('run', () {
      expect(1, 1);
    });
  });
}
