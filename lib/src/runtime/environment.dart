import 'dart:io' show Platform;

import './exception.dart' show MissingEnvException;
export './exception.dart' show MissingEnvException;

/// RuntimeEnvironment contains the Lambda execution context information.
///
/// Note: this should not be used directly.
class Environment {
  /// These are the constants used to map [Platform.environment]
  /// which are specific to the Lambda execution environment.
  /// https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html#configuration-envvars-runtime
  static const _kRegion = 'AWS_REGION';
  static const _kDefaultRegion = 'AWS_DEFAULT_REGION';
  static const _kAccessKeyId = 'AWS_ACCESS_KEY_ID';
  static const _kAccessKey = 'AWS_ACCESS_KEY';
  static const _kSecretAccesKey = 'AWS_SECRET_ACCESS_KEY';
  static const _kSessionToken = 'AWS_SESSION_TOKEN';
  static const _kLambdaRuntimeAPI = 'AWS_LAMBDA_RUNTIME_API';
  static const _kLambdaHandler = '_HANDLER';
  static const _kLambdaFuncName = 'AWS_LAMBDA_FUNCTION_NAME';
  static const _kLambdaFuncVersion = 'AWS_LAMBDA_FUNCTION_VERSION';
  static const _kLambdaFuncMemSize = 'AWS_LAMBDA_FUNCTION_MEMORY_SIZE';
  static const _kLambdaLogGroupName = 'AWS_LAMBDA_LOG_GROUP_NAME';
  static const _kLambdaLogStreamName = 'AWS_LAMBDA_LOG_STREAM_NAME';

  /// The Runtime API endpoint
  final String runtimeAPI;

  /// Handler that is used for the invocation of the function
  final String handler;

  /// Region that this function exists in.
  final String? region;

  /// Name of the function that is invoked.
  final String? funcName;

  /// Version of the function that is invoked.
  final String? funcVersion;

  /// Amount of memory available to the function in MB.
  final String? funcMemSize;

  /// Names of the CloudWatch Logs group and stream for the function.
  /// Not available in Lambda SnapStart functions.
  final String? logGroupName, logStreamName;

  /// Access keys obtained from the function's execution role.
  final String? accessKeyId, accessKey, secretAccessKey, sessionToken;

  Environment({
    String? runtimeAPI,
    String? handler,
    String? region,
    String? accessKeyId,
    String? accessKey,
    String? secretAccessKey,
    String? sessionToken,
    String? funcName,
    String? funcMemSize,
    String? funcVersion,
    String? logGroupName,
    String? logStreamName,
  })  : runtimeAPI =
            runtimeAPI ?? _readEnv(_kLambdaRuntimeAPI, critical: true)!,
        handler = handler ?? _readEnv(_kLambdaHandler, critical: true)!,
        region = region ?? _readEnv(_kRegion, fallback: _kDefaultRegion),
        accessKeyId = accessKeyId ?? _readEnv(_kAccessKeyId),
        accessKey = accessKey ?? _readEnv(_kAccessKey),
        secretAccessKey = secretAccessKey ?? _readEnv(_kSecretAccesKey),
        sessionToken = sessionToken ?? _readEnv(_kSessionToken),
        funcName = funcName ?? _readEnv(_kLambdaFuncName),
        funcMemSize = funcMemSize ?? _readEnv(_kLambdaFuncMemSize),
        funcVersion = funcVersion ?? _readEnv(_kLambdaFuncVersion),
        logGroupName = logGroupName ?? _readEnv(_kLambdaLogGroupName),
        logStreamName = logStreamName ?? _readEnv(_kLambdaLogStreamName);
}

String? _readEnv(String key, {String? fallback, bool critical = false}) {
  var value = Platform.environment[key];
  if (value == null && fallback != null) {
    value = Platform.environment[fallback];
  }

  if (value == null && critical) {
    throw MissingEnvException(key);
  }
  return value;
}
