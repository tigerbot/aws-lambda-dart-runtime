import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'apigateway_event.g.dart';

/// API Gateway Response contains the data for a response
/// to the API Gateway. It contains the [body] of the HTTP response.
/// It also contains a HTTP Status Code which by default is `200`.
/// Furthermore it indicates if the [body] is Base64 encoded or not.
class AwsApiGatewayResponse {
  // HTTP Status Code of the response of the API Gateway to the client.
  int statusCode;

  /// Indicates if the [body] is Base64 encoded or not.
  bool isBase64Encoded = false;

  /// The HTTP headers that should be send with the response to the client.
  Map<String, String>? headers;

  /// The body of the HTTP Response send from the API Gateway to the client.
  String? body;

  /// Returns the JSON representation of the response. This is called by
  /// the JSON encoder to produce the response.
  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'isBase64Encoded': isBase64Encoded,
        if (headers != null) 'headers': headers,
        if (body != null) 'body': body,
      };

  /// The factory creates a new [AwsApiGatewayResponse] from JSON.
  /// It optionally a HTTP Status Code and additional headers for the response.
  factory AwsApiGatewayResponse.fromJson(
    Map<String, dynamic> body, {
    int statusCode = HttpStatus.ok,
    Map<String, String>? headers,
  }) {
    return AwsApiGatewayResponse(
      statusCode: statusCode,
      headers: (headers ?? {})..addAll({'Content-Type': 'application/json'}),
      body: json.encode(body),
    );
  }

  AwsApiGatewayResponse({
    this.statusCode = HttpStatus.ok,
    this.isBase64Encoded = false,
    this.headers,
    this.body,
  });
}

/// API Gateway Event ...
@JsonSerializable()
class AwsApiGatewayEvent extends Event {
  /// URL Path ...
  final String? path;

  /// Resource ...
  final String? resource;

  /// HTTP Method ...
  final String? httpMethod;

  /// Body ...
  final String? body;

  /// Headers ...
  final AwsApiGatewayEventHeaders? headers;

  /// Path Parameters ...
  final Map<String, dynamic>? pathParameters;

  /// Query String Parameters ...
  final Map<String, dynamic>? queryStringParameters;

  /// Stage Variables ...
  final Map<String, dynamic>? stageVariables;

  /// Request Context ...
  final AwsApiGatewayEventRequestContext? requestContext;

  factory AwsApiGatewayEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsApiGatewayEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsApiGatewayEventToJson(this);

  const AwsApiGatewayEvent({
    this.resource,
    this.path,
    this.httpMethod,
    this.body,
    this.headers,
    this.queryStringParameters,
    this.stageVariables,
    this.requestContext,
    this.pathParameters,
  });
}

/// API Gateway Event Headers contains the headers of the
/// request the gateway is handling. It handles header names
/// as case-insensitive, so `headers['ACCEPT'] == headers['accept']`
class AwsApiGatewayEventHeaders {
  final Map<String, String> _values;

  String? operator [](String index) => _values[index.toLowerCase()];

  AwsApiGatewayEventHeaders.fromJson(Map<String, dynamic> json)
      : _values = json.map(
          (key, value) => MapEntry(key.toLowerCase(), value as String),
        );

  Map<String, dynamic> toJson() => _values.cast<String, dynamic>();
}

/// API Gateway Event Request Context ...
@JsonSerializable()
class AwsApiGatewayEventRequestContext {
  final String? accountId;
  final String? resourceId;
  final String? stage;
  final String? eventType;
  final String? routeKey;
  final String? connectionId;
  final String? requestId;
  final String? extendedRequestId;
  final String? resourcePath;
  final String? httpMethod;
  final String? apiId;
  final String? domainName;

  factory AwsApiGatewayEventRequestContext.fromJson(
          Map<String, dynamic> json) =>
      _$AwsApiGatewayEventRequestContextFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AwsApiGatewayEventRequestContextToJson(this);

  const AwsApiGatewayEventRequestContext({
    this.accountId,
    this.resourceId,
    this.stage,
    this.eventType,
    this.routeKey,
    this.connectionId,
    this.requestId,
    this.extendedRequestId,
    this.resourcePath,
    this.httpMethod,
    this.apiId,
    this.domainName,
  });
}

/// API Gateway Event Identity
@JsonSerializable()
class AwsApiGatewayEventRequestContextIdentity {
  final String? cognitoIdentityPoolId;
  final String? accountId;
  final String? cognitoIdentityId;
  final String? caller;
  final String? apiKey;
  final String? sourceIp;
  final String? cognitoAuthenticationType;
  final String? cognitoAuthenticationProvider;
  final String? userArn;
  final String? userAgent;
  final String? user;

  factory AwsApiGatewayEventRequestContextIdentity.fromJson(
          Map<String, dynamic> json) =>
      _$AwsApiGatewayEventRequestContextIdentityFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AwsApiGatewayEventRequestContextIdentityToJson(this);

  const AwsApiGatewayEventRequestContextIdentity({
    this.cognitoIdentityPoolId,
    this.cognitoAuthenticationProvider,
    this.cognitoAuthenticationType,
    this.caller,
    this.accountId,
    this.cognitoIdentityId,
    this.apiKey,
    this.sourceIp,
    this.user,
    this.userAgent,
    this.userArn,
  });
}
