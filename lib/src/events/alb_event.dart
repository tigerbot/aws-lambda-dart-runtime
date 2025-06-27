import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'alb_event.g.dart';

// derived from https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status
const _statusNames = {
  100: 'Continue',
  101: 'Switching Protocols',
  102: 'Processing',
  103: 'Early Hints',
  200: 'OK',
  201: 'Created',
  202: 'Accepted',
  203: 'Non-Authoritative Information',
  204: 'No Content',
  205: 'Reset Content',
  206: 'Partial Content',
  207: 'Multi-Status',
  208: 'Already Reported',
  226: 'IM Used',
  300: 'Multiple Choices',
  301: 'Moved Permanently',
  302: 'Found',
  303: 'See Other',
  304: 'Not Modified',
  307: 'Temporary Redirect',
  308: 'Permanent Redirect',
  400: 'Bad Request',
  401: 'Unauthorized',
  402: 'Payment Required',
  403: 'Forbidden',
  404: 'Not Found',
  405: 'Method Not Allowed',
  406: 'Not Acceptable',
  407: 'Proxy Authentication Required',
  408: 'Request Timeout',
  409: 'Conflict',
  410: 'Gone',
  411: 'Length Required',
  412: 'Precondition Failed',
  413: 'Content Too Large',
  414: 'URI Too Long',
  415: 'Unsupported Media Type',
  416: 'Range Not Satisfiable',
  417: 'Expectation Failed',
  418: "I'm a teapot",
  421: 'Misdirected Request',
  422: 'Unprocessable Content',
  423: 'Locked',
  424: 'Failed Dependency',
  425: 'Too Early',
  426: 'Upgrade Required',
  428: 'Precondition Required',
  429: 'Too Many Requests',
  431: 'Request Header Fields Too Large',
  451: 'Unavailable For Legal Reasons',
  500: 'Internal Server Error',
  501: 'Not Implemented',
  502: 'Bad Gateway',
  503: 'Service Unavailable',
  504: 'Gateway Timeout',
  505: 'HTTP Version Not Supported',
  506: 'Variant Also Negotiates',
  507: 'Insufficient Storage',
  508: 'Loop Detected',
  510: 'Not Extended',
  511: 'Network Authentication Required',
};

String _getDescription(int code) => '$code ${_statusNames[code] ?? "Unknown"}';

/// Event send by an Application Load Balancer to the
/// invocation to the Lambda.
@JsonSerializable()
class AwsALBEvent extends Event {
  /// Request context in which this request is executed.
  /// For the ELB this is the ARN of the target group.
  final AwsALBEventContext? context;

  /// HTTP method that is used to trigger the invocation of the Lambda.
  final String? httpMethod;

  /// The URI that is accessed to trigger the invocation of the Lambda.
  final String? path;

  /// HTTP headers that are send with the request to the load balancer.
  final Map<String, dynamic>? headers;

  /// The query parameters for the request to the load balancer.
  final Map<String, dynamic>? queryStringParameters;

  /// Body of the request. This can be data that is send with the POST
  /// to the request.
  final String? body;

  /// Singals that the request is Base64 encoded.
  final bool? isBase64Encoded;

  factory AwsALBEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsALBEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsALBEventToJson(this);

  const AwsALBEvent({
    this.context,
    this.httpMethod,
    this.path,
    this.headers,
    this.queryStringParameters,
    this.body,
    this.isBase64Encoded,
  });
}

///[AwsALBResponse] contains the data for a load balancer to respond to
/// an HTTP request. It contains the [body] of the HTTP response.
/// It also contains a HTTP Status Code which by default is `200`.
/// Furthermore it indicates if the [body] is Base64 encoded or not.
class AwsALBResponse {
  /// HTTP Status Code of the response of the API Gateway to the client.
  final int statusCode;

  /// A text description of the HTTP Status Code.
  final String statusDescription;

  /// The HTTP headers that should be send with the response to the client.
  final Map<String, String>? headers;

  /// The body of the HTTP Response send from the API Gateway to the client.
  final String? body;

  /// Indicates if the [body] is Base64 encoded or not.
  final bool isBase64Encoded;

  /// Returns the JSON representation of the response. This is called by
  /// the JSON encoder to produce the response.
  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'statusDescription': statusDescription,
        if (headers != null) 'headers': headers,
        if (body != null) 'body': body,
        if (body != null) 'isBase64Encoded': isBase64Encoded,
      };

  /// Creates a new [AwsALBResponse] with an HTML body.
  /// It optionally a HTTP Status Code and additional headers for the response.
  AwsALBResponse.fromString(
    this.body, {
    this.statusCode = HttpStatus.ok,
    String? statusDescription,
    Map<String, String>? headers,
  })  : statusDescription = statusDescription ?? _getDescription(statusCode),
        headers = Map.from(headers ?? const {})
          ..addAll({'Content-Type': 'text/html; charset=utf-8'}),
        isBase64Encoded = false;

  /// Creates a new [AwsALBResponse] with a JSON object body.
  /// It optionally a HTTP Status Code and additional headers for the response.
  AwsALBResponse.fromJson(
    Map<String, dynamic> body, {
    this.statusCode = HttpStatus.ok,
    String? statusDescription,
    Map<String, String>? headers,
  })  : statusDescription = statusDescription ?? _getDescription(statusCode),
        headers = Map.from(headers ?? const {})
          ..addAll({'Content-Type': 'application/json; charset=utf-8'}),
        body = json.encode(body),
        isBase64Encoded = false;

  /// The Response that should be returned to the Application Load Balancer.
  /// It is constructed with some default values for the optional parameters.
  AwsALBResponse({
    this.statusCode = HttpStatus.ok,
    String? statusDescription,
    this.headers,
    this.body,
    this.isBase64Encoded = false,
  }) : statusDescription = statusDescription ?? _getDescription(statusCode);
}

/// AWS ALB Event Request Context ...
@JsonSerializable()
class AwsALBEventContext {
  factory AwsALBEventContext.fromJson(Map<String, dynamic> json) =>
      _$AwsALBEventContextFromJson(json);

  Map<String, dynamic> toJson() => _$AwsALBEventContextToJson(this);

  const AwsALBEventContext();
}
