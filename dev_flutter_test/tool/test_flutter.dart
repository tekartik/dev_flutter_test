//import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:process_run/process_run.dart';

Future testFlutterDir(String? dir, {List<String>? analyzerDir}) async {
  analyzerDir ??= ['lib'];
  var shell = Shell(workingDirectory: dir);
  await shell.run('flutter pub get');
  // '--fatal-warnings', '--fatal-infos'
  await shell.run('flutter analyze');
  await shell.run('flutter test');
}

Future main() async {
  await testFlutterDir(null, analyzerDir: ['lib', 'test']);
}
