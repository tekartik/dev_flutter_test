import 'package:dev_test/package.dart';
import 'package:path/path.dart';

Future main() async {
  for (var dir in [
    'dev_flutter_test',
  ]) {
    await packageRunCi(join('..', dir));
  }
  await packageRunCi('.');
}
