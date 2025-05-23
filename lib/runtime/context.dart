import './environment.dart';
import '../client/client.dart';

/// Context contains the Lambda execution context information.
class Context {
  /// Id of the request.
  /// You can use this to track the request for the invocation.
  final String requestId;

  /// The ARN to identify the function.
  final String? invokedFunctionArn;

  /// Handler that is used for the invocation of the function
  final String handler;

  /// Region that this function exists in.
  final String? region;

  /// Name of the function that is invoked.
  final String? functionName;

  /// Version of the function that is invoked.
  final String? functionVersion;

  /// Amount of memory available to the function in MB.
  final String? functionMemorySize;

  /// Names of the CloudWatch Logs group and stream for the function.
  /// Not available in Lambda SnapStart functions.
  final String? logGroupName, logStreamName;

  /// Access keys obtained from the function's execution role.
  final String? accessKeyId, accessKey, secretAccessKey, sessionToken;

  const Context._internal({
    required this.requestId,
    required this.invokedFunctionArn,
    required this.handler,
    required this.functionName,
    required this.functionVersion,
    required this.functionMemorySize,
    required this.logGroupName,
    required this.logStreamName,
    required this.region,
    required this.accessKeyId,
    required this.accessKey,
    required this.secretAccessKey,
    required this.sessionToken,
  });

  /// Creates a new [Context] for the next [Handler<T>] invocation from a
  /// [NextInvocation] from the Lambda Runtime API and the [Environment]
  /// for the current runtime.
  ///
  /// Note: This should not be created directly.
  factory Context.fromNextInvocation(
      NextInvocation invocation, Environment env) {
    return Context._internal(
      requestId: invocation.requestId,
      invokedFunctionArn: invocation.invokedFunctionArn,
      handler: env.handler,
      functionName: env.funcName,
      functionVersion: env.funcVersion,
      functionMemorySize: env.funcMemSize,
      logGroupName: env.logGroupName,
      logStreamName: env.logStreamName,
      region: env.region,
      accessKeyId: env.accessKeyId,
      accessKey: env.accessKey,
      secretAccessKey: env.secretAccessKey,
      sessionToken: env.sessionToken,
    );
  }
}
