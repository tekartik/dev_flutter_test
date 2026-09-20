---
name: dev-flutter-test-setup
description: >-
  Use when running dev_test based tests under flutter test, or when sharing one
  test suite between the Dart VM, the browser and Flutter, with
  dev_flutter_test: initFlutterTest, the package:dev_flutter_test/test.dart
  import that merges dev_test (test, group, setUp, tearDown, setUpAll,
  tearDownAll, expect) with flutter_test (testWidgets, WidgetTester, find,
  pumpWidget), and the interactive on-device menu runner of test_ui.dart
  (mainFlutterUiTest, initFlutterUiTest, mainMenuFlutter).
---

# dev_test on Flutter (dev_flutter_test)

`package:dev_test` declares tests through a swappable `testImplementation`;
its default one targets the `dart test` runner. `dev_flutter_test` installs a
`flutter_test` backed implementation, so shared test code written against
`package:dev_test/test.dart` also runs under `flutter test` — and, with
`test_ui.dart`, as an interactive menu app on a real device.

## Guidelines

* Dependency (git, not on pub.dev), in `dev_dependencies` for test files:
  ```yaml
  dev_dependencies:
    dev_flutter_test:
      git:
        url: https://github.com/tekartik/dev_flutter_test
        path: dev_flutter_test
  ```
  Put it in `dependencies` instead when an app entry point (`lib/main.dart` of
  a menu app) imports `test_ui.dart`.
* Two libraries only, no `lib/src`:
  * `package:dev_flutter_test/test.dart` — for `flutter test` runs;
  * `package:dev_flutter_test/test_ui.dart` — for an interactive menu app
    driven with `flutter run`.
  Both export `expect`, `test`, `group`, `setUp`, `tearDown`, `setUpAll`,
  `tearDownAll` from `dev_test` and everything else from
  `package:flutter_test/flutter_test.dart` (those seven names hidden), so a
  test file imports one of them and nothing else. Importing
  `package:flutter_test/flutter_test.dart` or `package:dev_test/test.dart`
  next to it makes `test`, `group` and `expect` ambiguous.
* Call `initFlutterTest()` as the first statement of `main()`, before any
  `group`/`test` declaration: it sets `dev_test`'s `testImplementation` to a
  `flutter_test` backed one wrapped in `WithDescriptionsTest`. Shared code
  that keeps importing `package:dev_test/test.dart` then declares its tests
  through `flutter_test`. That is the point of the package: one shared
  `defineTests()` for `dart test`, `dart test -p chrome` and `flutter test`.
* `testWidgets`, `WidgetTester`, `find`, `pumpWidget`, `findsOneWidget` and
  the whole `flutter_test` API stay available and are unaffected by
  `initFlutterTest()` — mix widget tests and shared `dev_test` tests in one
  file.
* Parameter caveats of the flutter implementation (read the code before
  relying on them): `test(...)` forwards `testOn`, `timeout`, `skip` and
  `onPlatform` to `flutter_test.test`, but `solo` is dropped; `group(...)`
  **ignores all of them**, including `skip:`. To skip a group under Flutter,
  skip the individual tests or guard the declaration with an `if`.
* `solo_test`, `skip_test`, `solo_group`, `skip_group` and `testDescriptions`
  are not re-exported. Keep them in shared files that import
  `package:dev_test/test.dart`; in a Flutter test file import them explicitly
  and hidden-free, e.g.
  `import 'package:dev_test/test.dart' show testDescriptions;`. Descriptions
  work because `initFlutterTest()` keeps the `WithDescriptionsTest` wrapper.
* Run the tests with `flutter test` (never `dart test`: `flutter_test` needs
  the Flutter binding). Widget tests still need
  `TestWidgetsFlutterBinding.ensureInitialized()` only when you touch
  bindings explicitly.
* Interactive mode (`test_ui.dart`): `mainFlutterUiTest(body, {showConsole})`
  calls `initFlutterUiTest()` and `mainMenuFlutter` from
  `tekartik_test_menu_flutter`, i.e. it `runApp`s a menu: each `group` becomes
  a menu page, each `test` an item you tap, `setUp`/`tearDown` run around each
  item and `setUpAll`/`tearDownAll` on menu enter/leave. `showConsole: true`
  shows the log pane. It is an app: launch it with `flutter run`, on a device
  or on the web, to run the same suite where the real platform plugins live.
  Failures (`fail`, `expect`) are reported in the menu instead of aborting.
* Do not call `initFlutterTest()` in an app that uses `mainFlutterUiTest` (it
  installs the UI implementation itself), and do not mix both libraries in one
  file.
* The repo also ships `examples/dev_flutter_test_example`, a minimal menu app
  (`lib/main.dart`) plus a `flutter test` file: copy it when starting a
  Flutter test harness for a plugin.

## Examples

### Flutter test file mixing shared tests and widget tests

```dart
import 'package:dev_flutter_test/test.dart';
import 'package:flutter/material.dart';

void main() {
  initFlutterTest();

  group('shared', () {
    setUp(() async {});
    test('expect', () {
      expect(1, 1);
    });
  });

  testWidgets('renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('hello')));
    expect(find.text('hello'), findsOneWidget);
  });
}
```

### One suite shared by dart test and flutter test

```dart
// In practice `defineSharedTests` lives in a file (or a package library)
// imported by both the `dart test` file and the `flutter test` file below;
// only the flutter file calls initFlutterTest().
import 'package:dev_flutter_test/test.dart';
import 'package:dev_test/test.dart' show testDescriptions;

void defineSharedTests() {
  group('shared', () {
    test('descriptions', () {
      expect(testDescriptions, ['shared', 'descriptions']);
    });
  });
}

void main() {
  initFlutterTest();
  defineSharedTests();
}
```

### Interactive menu app (flutter run)

```dart
import 'package:dev_flutter_test/test_ui.dart';

Future<void> main(List<String> args) async {
  mainFlutterUiTest(() {
    group('example', () {
      setUpAll(() async {});
      test('expect', () {
        expect(1, 1);
      });
      test('fail', () {
        fail('too bad');
      });
    });
  }, showConsole: true);
}
```

### Skipping under Flutter, where group parameters are ignored

```dart
import 'package:dev_flutter_test/test.dart';
import 'package:flutter/foundation.dart';

void main() {
  initFlutterTest();

  // `group('x', ..., skip: true)` would be silently ignored: guard instead.
  if (!kIsWeb) {
    group('io only', () {
      test('skipped on web', () {
        expect(defaultTargetPlatform, isNotNull);
      }, skip: false);
    });
  }
}
```

## Common mistakes

* Importing `package:flutter_test/flutter_test.dart` (or
  `package:dev_test/test.dart` unhidden) next to
  `package:dev_flutter_test/test.dart`: ambiguous `test`/`group`/`expect`.
* Forgetting `initFlutterTest()`, so shared `dev_test` declarations keep
  targeting the `dart test` implementation.
* Passing `skip:`, `timeout:` or `testOn:` to `group(...)` under Flutter and
  expecting them to apply.
* Running a `dev_flutter_test` file with `dart test`.
* Calling `mainFlutterUiTest` from a `flutter test` file: it is a `runApp`
  entry point, not a test.
