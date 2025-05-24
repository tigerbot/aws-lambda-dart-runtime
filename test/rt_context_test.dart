import 'package:test/test.dart';

import 'package:aws_lambda_runtime/src/runtime/context.dart';
import 'package:aws_lambda_runtime/src/runtime/environment.dart';
import 'package:aws_lambda_runtime/src/runtime/invocation.dart';

void main() {
  group('context', () {
    test('Context gets initialized from an Invocation', () async {
      final invocation = Invocation(
        requestId: 'req1234',
        deadlineMs: '9876543210',
        invokedFunctionArn: 'not-a-real-arn',
        traceId: 'x-rays are cool',
        clientContext: 'foobar',
        cognitoIdentity: 'me, myself, and I',
        response: {},
      );

      final env = Environment(
        region: 'eu-west-1',
        accessKeyId: 'secret_id',
        accessKey: 'secret',
        secretAccessKey: 'key',
        sessionToken: '1234567890',
        runtimeAPI: 'baz',
        handler: 'foo',
        funcName: 'bar',
        funcVersion: '1',
        funcMemSize: '128',
        logGroupName: 'foo-group',
        logStreamName: 'foo-stream',
      );

      final ctx = Context.fromInvocation(invocation, env);

      expect(ctx.requestId, invocation.requestId);
      expect(ctx.deadlineMs, invocation.deadlineMs);
      expect(ctx.invokedFunctionArn, invocation.invokedFunctionArn);
      expect(ctx.traceId, invocation.traceId);
      expect(ctx.clientContext, invocation.clientContext);
      expect(ctx.cognitoIdentity, invocation.cognitoIdentity);

      expect(ctx.handler, env.handler);
      expect(ctx.functionName, env.funcName);
      expect(ctx.functionVersion, env.funcVersion);
      expect(ctx.functionMemorySize, env.funcMemSize);
      expect(ctx.logGroupName, env.logGroupName);
      expect(ctx.logStreamName, env.logStreamName);
      expect(ctx.region, env.region);
      expect(ctx.accessKeyId, env.accessKeyId);
      expect(ctx.accessKey, env.accessKey);
      expect(ctx.secretAccessKey, env.secretAccessKey);
      expect(ctx.sessionToken, env.sessionToken);
    });
  });
}
