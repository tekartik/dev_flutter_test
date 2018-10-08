//import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future testFlutterDir(String dir, {List<String> analyzerDir}) async {
  analyzerDir ??= ['lib'];
  await runCmd(FlutterCmd(['packages', 'get'])..workingDirectory = dir);
  // '--fatal-warnings', '--fatal-infos'
  await runCmd(
      FlutterCmd(['analyze']..addAll(analyzerDir))..workingDirectory = dir);
  await runCmd(FlutterCmd(['test'])..workingDirectory = dir);
}

Future main() async {
  await testFlutterDir(null, analyzerDir: ['lib', 'test']);
}
