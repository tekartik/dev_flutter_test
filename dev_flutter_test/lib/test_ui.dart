/// dev_test declarations as an interactive Flutter menu app
/// ([mainFlutterUiTest], `flutter run`).
library;

// ignore: implementation_imports
import 'package:dev_test/src/description_test.dart' show WithDescriptionsTest;
// ignore: implementation_imports
import 'package:dev_test/src/dev_test.dart' show testImplementation;
// ignore: implementation_imports
import 'package:dev_test/src/dev_test_menu.dart' show DevTestMenu;
import 'package:tekartik_test_menu_flutter/test_menu_flutter.dart' as tmf;

export 'package:dev_test/test.dart'
    show expect, test, group, setUp, tearDown, setUpAll, tearDownAll;
export 'package:flutter_test/flutter_test.dart'
    hide expect, test, group, setUp, tearDown, setUpAll, tearDownAll;
export 'package:tekartik_test_menu_flutter/test_menu_flutter.dart'
    show mainMenuFlutter;

/// Declares the dev_test `group`/`test` calls as Flutter test menus and items
/// ([FlutterUiTest]).
void initFlutterUiTest() {
  testImplementation = WithDescriptionsTest(FlutterUiTest());
}

/// Runs the tests declared by [body] as an interactive Flutter menu app
/// (`flutter run`, not `flutter test`): each `group` is a menu, each `test`
/// an item.
void mainFlutterUiTest(void Function() body, {bool? showConsole}) {
  initFlutterUiTest();
  tmf.mainMenuFlutter(body, showConsole: showConsole);
}

/// The dev_test implementation of [mainFlutterUiTest], the one of dev_test's
/// console menu (`mainDevTestMenu`) in the Flutter test menu.
///
/// `setUp`/`tearDown` run around each test, those of the parent groups too,
/// in the package:test order (the setUps outer first, the tearDowns inner
/// first and in reverse, even after a failure); `setUpAll`/`tearDownAll`
/// when a group menu is entered and left. `expect` works without a
/// package:test invoker (in a `flutter run` app), the async matchers and
/// `expectLater` do not; `skip`, `testOn`, `timeout` and `onPlatform` are
/// ignored.
class FlutterUiTest extends DevTestMenu {}
