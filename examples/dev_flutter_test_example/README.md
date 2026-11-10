# dev_flutter_test_example

The tests of `lib/main.dart` as an interactive menu app
(`mainFlutterUiTest` of `package:dev_flutter_test/test_ui.dart`): the
`example` group is a menu, each test an item to tap; the console shows the
output and the failures.

The platform folders are not committed: create the ones you need first.

```sh
flutter create --platforms=web,linux .
flutter run -d chrome   # or -d linux, a device...
```
