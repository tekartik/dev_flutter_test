//import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future testFlutterDir(String dir, {List<String> analyzerDir}) async {
  analyzerDir ??= ['lib'];
  await runCmd(flutterCmd(['packages', 'get'])..workingDirectory = dir);
  // '--fatal-warnings', '--fatal-infos'
  await runCmd(
      flutterCmd(['analyze']..addAll(analyzerDir))..workingDirectory = dir);
  await runCmd(flutterCmd(['test'])..workingDirectory = dir);
}

Future main() async {
  await runCmd(dartCmd(['--version']));
  try {
    await runCmd(flutterCmd(['--version']));
  } catch (e) {
    print(e);
  }
  try {
    await runCmd(ProcessCmd('flutter', ['--version']));
  } catch (e) {
    print(e);
  }
  try {
    await runCmd(ProcessCmd('flutter', ['--version'], runInShell: true));
  } catch (e) {
    print(e);
  }
  await testFlutterDir(null, analyzerDir: ['lib', 'test']);
}
