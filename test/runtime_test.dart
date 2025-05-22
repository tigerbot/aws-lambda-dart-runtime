import 'dart:async';
import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() {
  Future testHandler(context, event) async => true;

  group('runtime', () {
    test('instance is created without error', () {
      expect(() => Runtime(), returnsNormally);
    });

    test('instance is same across invocation', () async {
      final runtime = Runtime();

      expect(runtime, Runtime());
    });

    test('successfully add a handler to runtime', () async {
      const name = 'test.register';
      final runtime = Runtime();

      final addHandler = runtime.registerHandler(name, testHandler);

      expect(runtime.handlerExists(name), equals(true));
      expect(addHandler, equals(testHandler));
    });

    test('successfully deregister a handler to runtime', () async {
      const name = 'test.deregister';
      final runtime = Runtime();

      runtime.registerHandler(name, testHandler);
      final removedHandler = runtime.deregisterHandler(name);

      expect(runtime.handlerExists(name), equals(false));
      expect(removedHandler, equals(testHandler));
    });
  });
}
