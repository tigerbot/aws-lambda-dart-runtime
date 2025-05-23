import 'package:test/test.dart';

import 'package:aws_lambda_runtime/runtime/context.dart';
import 'package:aws_lambda_runtime/runtime/environment.dart';
import 'package:aws_lambda_runtime/client/client.dart';

void main() {
  group('context', () {
    test('Context gets initialized from an Invocation', () async {
      final invocation = NextInvocation(
        requestId: 'req1234',
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

      final ctx = Context.fromNextInvocation(invocation, env);
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
