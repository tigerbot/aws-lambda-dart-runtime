import 'package:test/test.dart';

import 'package:aws_lambda_runtime/src/runtime/environment.dart';

void main() {
  group('environment', () {
    test('fails when missing runtimeApi', () {
      const expected = MissingEnvException('AWS_LAMBDA_RUNTIME_API');
      expect(() => Environment(handler: 'foo'), throwsA(equals(expected)));
    });

    test('fails when missing handler', () {
      const expected = MissingEnvException('_HANDLER');
      expect(() => Environment(runtimeAPI: 'foo'), throwsA(equals(expected)));
    });
  });
}
