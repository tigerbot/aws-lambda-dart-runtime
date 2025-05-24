import 'package:test/test.dart';

import 'package:aws_lambda_runtime/src/runtime/invocation.dart';

void main() {
  group('invocation', () {
    test('invocation error gets populated', () {
      final stateError = StateError('foo');
      final invocationError =
          InvocationError(stateError, StackTrace.fromString(''));

      expect(invocationError.error, stateError);
    });
  });
}
