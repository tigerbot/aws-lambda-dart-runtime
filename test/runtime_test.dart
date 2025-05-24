import 'dart:async';
import 'package:aws_lambda_runtime/runtime/environment.dart';
import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() {
  group('runtime', () {
    final env = Environment(
      runtimeAPI: 'localhost:8888',
      handler: 'hello.World',
    );
    final runtime = Runtime.fromEnv(env);

    test('successfully (de)registers handlers', () {
      const name = 'test.register';
      Future testHandler(Context ctx, AwsAlexaEvent ev) async => true;

      runtime.registerHandler(name, testHandler);
      expect(runtime.handlerExists(name), equals(true));

      runtime.deregisterHandler(name);
      expect(runtime.handlerExists(name), equals(false));
    });
  });
}
