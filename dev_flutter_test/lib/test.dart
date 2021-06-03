// for flutter

// ignore: implementation_imports
import 'package:dev_test/src/description_test.dart' show WithDescriptionsTest;

// ignore: implementation_imports
import 'package:dev_test/src/dev_test.dart' show Test, testImplementation;
import 'package:dev_test/test.dart' show Timeout;
import 'package:flutter_test/flutter_test.dart' as _impl;

export 'package:dev_test/test.dart'
    show expect, test, group, setUp, tearDown, setUpAll, tearDownAll;
export 'package:flutter_test/flutter_test.dart'
    hide expect, test, group, setUp, tearDown, setUpAll, tearDownAll;

void initFlutterTest() {
  testImplementation = WithDescriptionsTest(FlutterTest());
}

class FlutterTest implements Test {
  @override
  void test(String description, dynamic Function() body,
      {String testOn,
      Timeout timeout,
      skip,
      @deprecated bool solo = false,
      Map<String, dynamic> onPlatform}) {
    _impl.test(
      description, body,
      testOn: testOn,
      timeout: timeout,
      skip: skip,
      onPlatform: onPlatform,
      // ignore: deprecated_member_use
      // solo: solo
    );
  }

  @override
  void group(String description, void Function() body,
      {String testOn,
      Timeout timeout,
      skip,
      @deprecated bool solo = false,
      Map<String, dynamic> onPlatform}) {
    _impl.group(
      description, body,
      // testOn: testOn,
      // timeout: timeout,
      // skip: skip,
      // onPlatform: onPlatform,
      // ignore: deprecated_member_use
      // solo: solo
    );
  }

  @override
  void setUp(dynamic Function() callback) {
    _impl.setUp(callback);
  }

  @override
  void tearDown(dynamic Function() callback) {
    _impl.tearDown(callback);
  }

  @override
  void setUpAll(dynamic Function() callback) {
    _impl.setUpAll(callback);
  }

  @override
  void tearDownAll(dynamic Function() callback) {
    _impl.tearDownAll(callback);
  }

  @override
  void expect(actual, matcher, {String reason, skip}) {
    _impl.expect(actual, matcher, reason: reason, skip: skip);
  }
}
