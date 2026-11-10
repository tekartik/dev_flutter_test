# dev_flutter_test

One test suite for the Dart VM, the browser and Flutter: the `flutter_test`
implementation of [dev_test](https://pub.dev/packages/dev_test). Tests
declared with dev_test (`test`, `group`, `setUp`, `expect`...) run

* under `flutter test`, next to `testWidgets` (`package:dev_flutter_test/test.dart`);
* as an interactive menu app on a device, `flutter run`
  (`package:dev_flutter_test/test_ui.dart`): each group is a menu, each test
  an item you tap, where the real plugins live.

Flutter on Android, iOS, Linux, macOS, Windows and the web.

## Getting started

Not on pub.dev, a git dependency (`dev_dependencies` for test files,
`dependencies` for a menu app entry point in `lib/`):

```yaml
dev_dependencies:
  dev_flutter_test:
    git:
      url: https://github.com/tekartik/dev_flutter_test
      path: dev_flutter_test
```

A test file, run with `flutter test`:

```dart
// test/shared_test.dart
import 'package:dev_flutter_test/test.dart';
import 'package:flutter/widgets.dart';

void main() {
  initFlutterTest();
  group('shared', () {
    test('add', () {
      expect(1 + 1, 2);
    });
  });
  testWidgets('hello', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Text('hello'),
      ),
    );
    expect(find.text('hello'), findsOneWidget);
  });
}
```

`package:dev_flutter_test/test.dart` exports `test`, `group`, `setUp`,
`tearDown`, `setUpAll`, `tearDownAll` and `expect` from dev_test, and the rest
of `flutter_test` (`testWidgets`, `find`, `fail`, the matchers...). Import it
alone: next to `package:flutter_test/flutter_test.dart` or
`package:dev_test/test.dart`, `test`, `group` and `expect` are ambiguous.

`initFlutterTest()` makes dev_test declare through `flutter_test`, so a shared
suite written against `package:dev_test/test.dart` (used by `dart test` and
`dart test -p chrome` elsewhere) runs the same way under `flutter test`.

## The same tests as a menu app

```dart
// lib/main.dart: flutter run (dev_flutter_test in dependencies)
import 'package:dev_flutter_test/test_ui.dart';

void main() {
  mainFlutterUiTest(() {
    group('example', () {
      late List<int> list;
      setUp(() {
        list = [1, 2];
      });
      test('expect', () {
        expect(list, [1, 2]);
      });
      test('fail', () {
        fail('too bad');
      });
    });
  }, showConsole: true);
}
```

`mainFlutterUiTest` runs the app (`runApp` of `tekartik_test_menu_flutter`):
each `group` is a menu, each `test` an item; `setUp`/`tearDown` run around each
test, those of the parent groups too, in the package:test order;
`setUpAll`/`tearDownAll` when a group menu is entered and left. A failing
`expect` or `fail` is shown in the console and the menu goes on.

## Good to know

* Under `flutter test`, a `group` only takes `skip`: `flutter_test` has no
  `testOn`, `timeout` nor `onPlatform` for a group, they are dropped (put them
  on each test).
* In the menu app, `skip`, `testOn`, `timeout` and `onPlatform` are ignored, and
  the async matchers do not work: `expectLater`, `completion`, `throwsA` and
  the other `throws...` matchers (use a `try`/`catch`). Run unchanged
  `package:test` files with full test_api semantics in an app with
  `mainDevTestMenuFlutter` of
  [tekartik_test_menu_flutter](https://github.com/tekartik/test_menu_flutter).
* `mainFlutterUiTest` is an app entry point (`flutter run`), not a test; do not
  call `initFlutterTest()` in it.
* Run the test files with `flutter test`, never `dart test`.

A menu app example: [examples/dev_flutter_test_example](../examples/dev_flutter_test_example).
