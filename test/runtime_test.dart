import 'dart:async';
import 'package:aws_lambda_runtime/runtime/environment.dart';
import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() {
  Future testHandler(context, event) async => true;

  group('runtime', () {
    final env = Environment(
      runtimeAPI: 'localhost:8888',
      handler: 'hello.World',
    );

    test('successfully add a handler to runtime', () async {
      const name = 'test.register';
      final runtime = Runtime.fromEnv(env);

      final addHandler = runtime.registerHandler(name, testHandler);

      expect(runtime.handlerExists(name), equals(true));
      expect(addHandler, equals(testHandler));
    });

    test('successfully deregister a handler to runtime', () async {
      const name = 'test.deregister';
      final runtime = Runtime.fromEnv(env);

      runtime.registerHandler(name, testHandler);
      final removedHandler = runtime.deregisterHandler(name);

      expect(runtime.handlerExists(name), equals(false));
      expect(removedHandler, equals(testHandler));
    });
  });
}
