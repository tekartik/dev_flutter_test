// for flutter
// ignore: implementation_imports
import 'package:dev_test/src/description_test.dart' show WithDescriptionsTest;
// ignore: implementation_imports
import 'package:dev_test/src/dev_test.dart'
    show Test, testImplementation, DevTestMixin;
import 'package:dev_test/test.dart' show Timeout;
import 'package:meta/meta.dart';
import 'package:tekartik_test_menu_flutter/test_menu_flutter.dart' as tmf;

export 'package:dev_test/test.dart'
    show expect, test, group, setUp, tearDown, setUpAll, tearDownAll;
export 'package:flutter_test/flutter_test.dart'
    hide expect, test, group, setUp, tearDown, setUpAll, tearDownAll;
export 'package:tekartik_test_menu_flutter/test_menu_flutter.dart'
    show mainMenuFlutter;

void initFlutterUiTest() {
  testImplementation = WithDescriptionsTest(FlutterUiTest());
}

void mainFlutterUiTest(void Function() body, {bool? showConsole}) {
  initFlutterUiTest();
  tmf.mainMenuFlutter(body, showConsole: showConsole);
}

class FlutterUiTest with DevTestMixin implements Test {
  @override
  void test(
    String description,
    dynamic Function() body, {
    String? testOn,
    Timeout? timeout,
    skip,
    @doNotSubmit bool solo = false,
    Map<String, dynamic>? onPlatform,
  }) {
    tmf.item(
      description,
      body,

      // ignore: deprecated_member_use
      solo: solo,
    );
  }

  @override
  void group(
    String description,
    void Function() body, {
    String? testOn,
    Timeout? timeout,
    skip,
    @Deprecated('Dev only') bool solo = false,
    Map<String, dynamic>? onPlatform,
  }) {
    tmf.menu(
      description,
      body,
      // ignore: deprecated_member_use
      solo: true,
      // testOn: testOn,
      // timeout: timeout,
      // skip: skip,
      // onPlatform: onPlatform,
      // ignore: deprecated_member_use
      // solo: solo
    );
  }

  @override
  void setUp(Object? Function() callback) {
    tmf.enterItem(callback);
  }

  @override
  void tearDown(Object? Function() callback) {
    tmf.leaveItem(callback);
  }

  @override
  void setUpAll(dynamic Function() callback) {
    tmf.enter(callback);
  }

  @override
  void tearDownAll(dynamic Function() callback) {
    tmf.leave(callback);
  }
}
