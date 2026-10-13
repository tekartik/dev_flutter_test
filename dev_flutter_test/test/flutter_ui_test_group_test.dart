// ignore_for_file: implementation_imports
import 'package:dev_build/menu/menu.dart' as menu_api;
import 'package:dev_build/src/menu/dev_menu.dart' show MenuMenuItem;
import 'package:dev_build/src/menu/menu_manager.dart' show menuManager;
import 'package:dev_flutter_test/test_ui.dart' as ui;
import 'package:flutter_test/flutter_test.dart' as ft;

void main() {
  ft.test('a ui group is not solo', () async {
    ui.initFlutterUiTest();
    menu_api.menu('main', () {
      ui.test('top level test', () {});
      ui.group('g1', () {
        ui.test('in g1', () {});
      });
      menu_api.item('plain item', () {});
    });
    await menu_api.menuRun();
    // Only the root menu is pushed, a solo group would push main and g1.
    ft.expect(menuManager.stackMenus.length, 1);
    final main = menuManager.activeMenu!.items.single as MenuMenuItem;
    ft.expect(main.menu.items.map((item) => item.name), [
      'top level test',
      'g1',
      'plain item',
    ]);
  });
}
