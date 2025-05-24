import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Invocation data wraps the data from the invocation/next
/// endpoint of the Lambda Runtime API.
/// https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html#runtimes-api-next
class Invocation {
  static const _kRequestId = 'lambda-runtime-aws-request-id';
  static const _kDeadlineMs = 'lambda-runtime-aws-deadline-ms';
  static const _kInvokedFuncArn = 'lambda-runtime-invoked-functions-arn';
  static const _kTraceId = 'lambda-runtime-trace-id';
  static const _kClientContext = 'lambda-runtime-client-context';
  static const _kCognitoIdentity = 'lambda-runtime-cognito-identity';

  /// Raw response of invocation data that we received.
  final Map<String, dynamic> response;

  /// Request Id is the identifier of the request.
  final String requestId;

  /// Date that the function times out in Unix time milliseconds
  final String? deadlineMs;

  /// ARN of the Lambda function, version, or alias that's
  /// specified in the invocation.
  final String? invokedFunctionArn;

  /// Tracing id is the identifier for tracing like X-Ray.
  final String? traceId;

  /// For invocations from the AWS Mobile SDK, data about
  /// the client application and device.
  final String? clientContext;

  /// For invocations from the AWS Mobile SDK, data about
  /// the Amazon Cognito identity provider.
  final String? cognitoIdentity;

  /// Digesting a [HttpClientResponse] into a [Invocation].
  factory Invocation.fromResponse(http.Response response) => Invocation(
        response: json.decode(response.body) as Map<String, dynamic>,
        requestId: response.headers[_kRequestId]!,
        deadlineMs: response.headers[_kDeadlineMs],
        invokedFunctionArn: response.headers[_kInvokedFuncArn],
        traceId: response.headers[_kTraceId],
        clientContext: response.headers[_kClientContext],
        cognitoIdentity: response.headers[_kCognitoIdentity],
      );

  const Invocation({
    required this.requestId,
    this.deadlineMs,
    this.traceId,
    this.clientContext,
    this.cognitoIdentity,
    this.invokedFunctionArn,
    required this.response,
  });
}

/// Invocation error occurs when there has been an
/// error in the invocation of a handlers. It wraps the
/// inner [error] and formats it for the Lambda Runtime API.
class InvocationError {
  /// The error that catched during the invocation and
  /// which is posted to the Lambda Runtime Interface.
  final dynamic error;

  /// StackTrace ...
  final StackTrace stackTrace;

  /// Extracts the [InvocationError] data into a JSON
  /// representation for the Runtime Interface.
  Map<String, dynamic> toJson() => {
        'errorMessage': error.toString(),
        'errorType': 'InvocationError',
      };

  const InvocationError(this.error, this.stackTrace);
}
