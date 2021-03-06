import 'package:path/path.dart';
import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();

  await shell.run('flutter doctor');

  for (var dir in [
    'dev_flutter_test',
  ]) {
    shell = shell.pushd(join('..', dir));
    await shell.run('''
    
    flutter packages get
    dart tool/travis.dart
    
        ''');
    shell = shell.popd();
  }
}
