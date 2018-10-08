//import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future testFlutterDir(String dir, {List<String> analyzerDir}) async {
  analyzerDir ??= ['lib'];
  await runCmd(flutterCmd(['packages', 'get'])
    ..runInShell = true
    ..workingDirectory = dir);
  // '--fatal-warnings', '--fatal-infos'
  await runCmd(flutterCmd(['analyze']..addAll(analyzerDir))
    ..runInShell = true
    ..workingDirectory = dir);
  await runCmd(flutterCmd(['test'])
    ..runInShell = true
    ..workingDirectory = dir);
}

Future main() async {
  await testFlutterDir(null, analyzerDir: ['lib', 'test']);
}
