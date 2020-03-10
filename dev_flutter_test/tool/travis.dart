import 'package:process_run/shell.dart';

// import 'test_flutter.dart' as test_flutter;

Future<void> main() async {
  final shell = Shell();

  await shell.run('''

dartfmt -n --set-exit-if-changed .
flutter analyze
flutter test

''');

  // await test_flutter.main();
}
