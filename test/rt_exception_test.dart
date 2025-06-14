import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() {
  group('invocation', () {
    test('catch exception with cause', () {
      try {
        throw InvocationError(message: 'missing handler');
      } on InvocationError catch (e) {
        expect(e.message, 'missing handler');
        expect(e.stackTrace, isNotNull);
      }
    });

    test('toJson succeeds without stackTrace', () {
      const expected = {
        'errorType': 'RuntimeError',
        'errorMessage': 'foobar',
        'stackTrace': null,
      };
      final err = InvocationError(type: 'RuntimeError', message: 'foobar');

      expect(err.toJson(), equals(expected));
    });
  });
}
