// ignore_for_file: implementation_imports
import 'dart:async';

import 'package:dev_build/src/menu/dev_menu.dart';
import 'package:dev_build/src/menu/menu.dart' show menuNewDeclarer;
import 'package:dev_build/src/menu/menu_manager.dart';
import 'package:dev_build/src/menu/menu_presenter.dart';
import 'package:dev_flutter_test/test_ui.dart' as ui;
import 'package:flutter_test/flutter_test.dart' as ft;

/// The item named [name] of [menu].
DevMenuItem menuItem(DevMenu menu, String name) =>
    menu.items.firstWhere((item) => item.name == name);

/// The menu of the sub menu named [name] of [menu].
DevMenu subMenu(DevMenu menu, String name) =>
    (menuItem(menu, name) as MenuMenuItem).menu;

void main() {
  late DevMenu root;
  late List<String> calls;

  ft.setUp(() {
    // No output, a new menu manager.
    NullMenuPresenter();
    root = menuNewDeclarer().devMenu;
    ui.initFlutterUiTest();
    calls = <String>[];
  });

  ft.test('setUp and tearDown of the parent groups', () async {
    ui.setUp(() => calls.add('root setUp'));
    ui.tearDown(() => calls.add('root tearDown'));
    ui.group('outer', () {
      ui.setUp(() => calls.add('outer setUp 1'));
      ui.setUp(() async => calls.add('outer setUp 2'));
      ui.tearDown(() => calls.add('outer tearDown 1'));
      ui.tearDown(() async => calls.add('outer tearDown 2'));
      ui.test('direct', () => calls.add('direct'));
      ui.group('inner', () {
        ui.setUp(() => calls.add('inner setUp'));
        ui.tearDown(() => calls.add('inner tearDown'));
        ui.test('nested', () async => calls.add('nested'));
      });
    });
    var outer = subMenu(root, 'outer');
    await menuManager.runItem(menuItem(subMenu(outer, 'inner'), 'nested'));
    // Same order as package:test.
    ft.expect(calls, [
      'root setUp',
      'outer setUp 1',
      'outer setUp 2',
      'inner setUp',
      'nested',
      'inner tearDown',
      'outer tearDown 2',
      'outer tearDown 1',
      'root tearDown',
    ]);
    calls.clear();
    await menuManager.runItem(menuItem(outer, 'direct'));
    ft.expect(calls, [
      'root setUp',
      'outer setUp 1',
      'outer setUp 2',
      'direct',
      'outer tearDown 2',
      'outer tearDown 1',
      'root tearDown',
    ]);
  }, timeout: const ft.Timeout(Duration(seconds: 30)));

  ft.test('tearDowns run after a failing test', () async {
    ui.tearDown(() => calls.add('root tearDown'));
    ui.group('group', () {
      ui.tearDown(() => calls.add('tearDown'));
      ui.test('test', () async {
        await Future<void>.value();
        throw StateError('test failed');
      });
    });
    await ft.expectLater(
      menuManager.runItem(menuItem(subMenu(root, 'group'), 'test')),
      ft.throwsStateError,
    );
    ft.expect(calls, ['tearDown', 'root tearDown']);
  }, timeout: const ft.Timeout(Duration(seconds: 30)));

  ft.test('expect in an app (no test invoker)', () async {
    ui.group('group', () {
      ui.test('passes', () {
        ui.expect(1, 1);
        calls.add('passed');
      });
      ui.test('fails', () {
        ui.expect(1, 2);
        calls.add('not reached');
      });
    });
    var group = subMenu(root, 'group');
    ft.expect(await runInApp(menuItem(group, 'passes')), ft.isNull);
    ft.expect(calls, ['passed']);
    var error = await runInApp(menuItem(group, 'fails'));
    ft.expect(error, ft.isA<ft.TestFailure>());
    ft.expect('$error', ft.contains('Expected: <2>'));
    ft.expect(calls, ['passed']);
  }, timeout: const ft.Timeout(Duration(seconds: 30)));
}

/// Runs [item] as in a `flutter run` app: in the root zone, without the
/// package:test invoker of this test. Returns the error thrown, if any (an
/// error cannot cross back into the test zone).
Future<Object?> runInApp(DevMenuItem item) {
  var completer = Completer<Object?>();
  Zone.root.run(() async {
    try {
      await menuManager.runItem(item);
      completer.complete(null);
    } catch (e) {
      completer.complete(e);
    }
  });
  return completer.future;
}
