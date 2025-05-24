import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './invocation.dart';

/// Client is the Lambda Runtime API client.
/// See https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html
///
/// Note: This should not be used directly.
class Client {
  static const runtimeApiVersion = '2018-06-01';
  final String runtimeApi;
  final String _uriBase;
  final _client = http.Client();

  Client({required this.runtimeApi})
      : _uriBase = 'http://$runtimeApi/$runtimeApiVersion/runtime';

  /// Get the next invocation from the AWS Lambda Runtime API.
  Future<Invocation> getNextInvocation() {
    return _client
        .get(Uri.parse('$_uriBase/invocation/next'))
        .then(Invocation.fromResponse);
  }

  /// Post the invocation response to the AWS Lambda Runtime Interface.
  Future<void> postInvocationResponse(String requestId, dynamic payload) =>
      _sendResult('invocation/$requestId/response', payload);

  /// Post an invocation error to the AWS Lambda Runtime Interface.
  /// It takes in an [InvocationError] and the [requestId]. The [requestId]
  /// is used to map the error to the execution.
  Future<void> postInvocationError(String requestId, InvocationError err) =>
      _sendResult('invocation/$requestId/error', err);

  Future<void> _sendResult(String path, dynamic payload) async {
    final response = await _client.post(
      Uri.parse('$_uriBase/$path'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(payload),
    );

    // "Container error. Non-recoverable state. Runtime should exit promptly."
    if (response.statusCode == 500) {
      exit(1);
    }
  }
}
