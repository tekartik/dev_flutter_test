# dev_flutter_test

Flutter implementation of dev_test to share common test for VM, browser and flutter

## Setup

```yaml
dev_dependencies
  dev_flutter_test:
    git:
      url: https://github.com/tekartik/dev_flutter_test
      ref: dart2_3
```


## Usage

```dart
import 'package:dev_flutter_test/test.dart';

void main() {
  initFlutterTest();
  group('simple', () {
    test('expect', () {
      expect(1, 1);
    });
  });
}
```