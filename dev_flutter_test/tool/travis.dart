import 'package:process_run/shell.dart';

// import 'test_flutter.dart' as test_flutter;

Future<void> main() async {
  final Shell shell = Shell();

  await shell.run('''

flutter analyze
flutter test

''');

  // await test_flutter.main();
}
