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

/// API Gateway Event Headers ...
@JsonSerializable()
class AwsApiGatewayEventHeaders {
  @JsonKey(name: 'Accept')
  final String? accept;

  @JsonKey(name: 'Accept-Encoding')
  final String? acceptEncoding;

  @JsonKey(name: 'CloudFront-Forwarded-Proto')
  final String? cloudfrontForwardProto;

  @JsonKey(name: 'CloudFront-Is-Desktop-Viewer')
  final String? cloudfrontIsDesktopViewer;

  @JsonKey(name: 'CloudFront-Is-Mobile-Viewer')
  final String? cloudfrontIsMobileViewer;

  @JsonKey(name: 'CloudFront-Is-SmartTV-Viewer')
  final String? cloudfrontIsSmartTvViewer;

  @JsonKey(name: 'CloudFront-Is-Tablet-Viewer')
  final String? cloudfrontIsTabletViewer;

  @JsonKey(name: 'CloudFront-Viewer-Country')
  final String? cloudfrontViewerCountry;

  @JsonKey(name: 'Host')
  final String? host;

  @JsonKey(name: 'Upgrade-Insecure-Requests')
  final String? upgradeInsecureRequests;

  @JsonKey(name: 'User-Agent')
  final String? userAgent;

  @JsonKey(name: 'Via')
  final String? via;

  @JsonKey(name: 'X-Amz-Cf-Id')
  final String? xAmzCfId;

  @JsonKey(name: 'X-Forwarded-For')
  final String? xForwardedFor;

  @JsonKey(name: 'X-Forwarded-Port')
  final String? xForwardedPort;

  @JsonKey(name: 'X-Forwarded-Proto')
  final String? xForwardedProto;

  @JsonKey(name: 'Cache-Control')
  final String? cacheControl;

  @JsonKey(name: 'X-Amzn-Trace-Id')
  final String? xAmznTraceId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late Map<String, dynamic> raw;

  factory AwsApiGatewayEventHeaders.fromJson(Map<String, dynamic> json) {
    final event = _$AwsApiGatewayEventHeadersFromJson(json);
    event.raw = json;

    return event;
  }

  Map<String, dynamic> toJson() => _$AwsApiGatewayEventHeadersToJson(this);

  AwsApiGatewayEventHeaders({
    this.accept,
    this.acceptEncoding,
    this.cloudfrontIsDesktopViewer,
    this.cloudfrontIsMobileViewer,
    this.cloudfrontIsSmartTvViewer,
    this.cloudfrontForwardProto,
    this.cloudfrontIsTabletViewer,
    this.cloudfrontViewerCountry,
    this.upgradeInsecureRequests,
    this.cacheControl,
    this.host,
    this.via,
    this.userAgent,
    this.xAmzCfId,
    this.xAmznTraceId,
    this.xForwardedFor,
    this.xForwardedPort,
    this.xForwardedProto,
  });
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
