import 'dart:io' show Platform;

/// RuntimeEnvironment contains the Lambda execution context information.
/// Note: this should not be used directly.
class Environment {
  /// These are the constants used to map [Platform.environment]
  /// which are specific to the Lambda execution environment.
  static const _kAWSLambdaHandler = '_HANDLER';
  static const _kAWSLambdaFunctionName = 'AWS_LAMBDA_FUNCTION_NAME';
  static const _kAWSLambdaFunctionVersion = 'AWS_LAMBDA_FUNCTION_VERSION';
  static const _kAWSLambdaLogGroupName = 'AWS_LAMBDA_LOG_GROUP_NAME';
  static const _kAWSLambdaLogStreamName = 'AWS_LAMBDA_LOG_STREAM_NAME';
  static const _kAWSLambdaFunctionMemorySize =
      'AWS_LAMBDA_FUNCTION_MEMORY_SIZE';
  static const _kAWSLambdaRegion = 'AWS_REGION';
  static const _kAWSLambdaExecutionEnv = 'AWS_EXECUTION_ENV';
  static const _kAWSLambdaAccessKey = 'AWS_ACCESS_KEY_ID';
  static const _kAWSLambdaSecretAccesKey = 'AWS_SECRET_ACCESS_KEY';
  static const _kAWSLambdaSessionToken = 'AWS_SESSION_TOKEN';
  static const _kAWSLambdaRuntimeAPI = 'AWS_LAMBDA_RUNTIME_API';

  /// Handler that is used for the invocation of the function
  final String handler;

  /// Name of the function that is invoked.
  final String functionName;

  /// Version of the function that is invoked.
  final String functionVersion;

  /// Memory sized that is allocated to execution of the function.
  final String functionMemorySize;

  /// Cloudwatch LogGroup that is associated with the Lambda.
  final String logGroupName;

  /// Cloudwach LogStream that is associated with the Lambda.
  final String logStreamName;

  /// Region that this function exists in.
  final String region;

  /// The execution environment of the function.
  final String executionEnv;

  /// Access key that is acquired via STS.
  final String accessKey;

  /// Secret access key that is acquired via STS.
  final String secretAccessKey;

  /// The session token from STS.
  final String sessionToken;

  /// The Runtime API endpoint
  final String runtimeAPI;

  factory Environment({
    String? runtimeAPI,
    String? handler,
    String? functionName,
    String? functionMemorySize,
    String? functionVersion,
    String? logGroupName,
    String? logStreamName,
    String? region,
    String? executionEnv,
    String? accessKey,
    String? secretAccessKey,
    String? sessionToken,
  }) {
    handler ??= Platform.environment[_kAWSLambdaHandler]!;
    functionName ??= Platform.environment[_kAWSLambdaFunctionName]!;
    functionMemorySize ??= Platform.environment[_kAWSLambdaFunctionMemorySize]!;
    functionVersion ??= Platform.environment[_kAWSLambdaFunctionVersion]!;
    logGroupName ??= Platform.environment[_kAWSLambdaLogGroupName]!;
    logStreamName ??= Platform.environment[_kAWSLambdaLogStreamName]!;
    region ??= Platform.environment[_kAWSLambdaRegion]!;
    executionEnv ??= Platform.environment[_kAWSLambdaExecutionEnv]!;
    accessKey ??= Platform.environment[_kAWSLambdaAccessKey]!;
    secretAccessKey ??= Platform.environment[_kAWSLambdaSecretAccesKey]!;
    sessionToken ??= Platform.environment[_kAWSLambdaSessionToken]!;
    runtimeAPI ??= Platform.environment[_kAWSLambdaRuntimeAPI]!;

    return Environment.raw(
        handler: handler,
        functionVersion: functionVersion,
        functionName: functionName,
        functionMemorySize: functionMemorySize,
        logGroupName: logGroupName,
        logStreamName: logStreamName,
        region: region,
        executionEnv: executionEnv,
        accessKey: accessKey,
        secretAccessKey: secretAccessKey,
        sessionToken: sessionToken,
        runtimeAPI: runtimeAPI);
  }

  const Environment.raw({
    required this.handler,
    required this.functionName,
    required this.functionMemorySize,
    required this.functionVersion,
    required this.logGroupName,
    required this.logStreamName,
    required this.region,
    required this.executionEnv,
    required this.accessKey,
    required this.secretAccessKey,
    required this.runtimeAPI,
    required this.sessionToken,
  });
}
