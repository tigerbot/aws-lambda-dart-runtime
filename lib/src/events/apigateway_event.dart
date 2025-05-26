import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
import './aws_http_response.dart';

part 'apigateway_event.g.dart';

/// The response for an API Gateway event is an HTTP response.
typedef AwsApiGatewayResponse = AwsHttpResponse;

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
  final String? requestId;
  final String? resourcePath;
  final String? httpMethod;
  final String? apiId;

  factory AwsApiGatewayEventRequestContext.fromJson(
          Map<String, dynamic> json) =>
      _$AwsApiGatewayEventRequestContextFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AwsApiGatewayEventRequestContextToJson(this);

  const AwsApiGatewayEventRequestContext({
    this.accountId,
    this.resourceId,
    this.stage,
    this.requestId,
    this.resourcePath,
    this.httpMethod,
    this.apiId,
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
