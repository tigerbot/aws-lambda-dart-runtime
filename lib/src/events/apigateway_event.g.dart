// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apigateway_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AwsApiGatewayEvent _$AwsApiGatewayEventFromJson(Map<String, dynamic> json) =>
    AwsApiGatewayEvent(
      resource: json['resource'] as String?,
      path: json['path'] as String?,
      httpMethod: json['httpMethod'] as String?,
      body: json['body'] as String?,
      headers: json['headers'] == null
          ? null
          : AwsApiGatewayEventHeaders.fromJson(
              json['headers'] as Map<String, dynamic>),
      queryStringParameters:
          json['queryStringParameters'] as Map<String, dynamic>?,
      stageVariables: json['stageVariables'] as Map<String, dynamic>?,
      requestContext: json['requestContext'] == null
          ? null
          : AwsApiGatewayEventRequestContext.fromJson(
              json['requestContext'] as Map<String, dynamic>),
      pathParameters: json['pathParameters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AwsApiGatewayEventToJson(AwsApiGatewayEvent instance) =>
    <String, dynamic>{
      'path': instance.path,
      'resource': instance.resource,
      'httpMethod': instance.httpMethod,
      'body': instance.body,
      'headers': instance.headers,
      'pathParameters': instance.pathParameters,
      'queryStringParameters': instance.queryStringParameters,
      'stageVariables': instance.stageVariables,
      'requestContext': instance.requestContext,
    };

AwsApiGatewayEventRequestContext _$AwsApiGatewayEventRequestContextFromJson(
        Map<String, dynamic> json) =>
    AwsApiGatewayEventRequestContext(
      accountId: json['accountId'] as String?,
      resourceId: json['resourceId'] as String?,
      stage: json['stage'] as String?,
      eventType: json['eventType'] as String?,
      routeKey: json['routeKey'] as String?,
      connectionId: json['connectionId'] as String?,
      requestId: json['requestId'] as String?,
      extendedRequestId: json['extendedRequestId'] as String?,
      resourcePath: json['resourcePath'] as String?,
      httpMethod: json['httpMethod'] as String?,
      apiId: json['apiId'] as String?,
      domainName: json['domainName'] as String?,
    );

Map<String, dynamic> _$AwsApiGatewayEventRequestContextToJson(
        AwsApiGatewayEventRequestContext instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'resourceId': instance.resourceId,
      'stage': instance.stage,
      'eventType': instance.eventType,
      'routeKey': instance.routeKey,
      'connectionId': instance.connectionId,
      'requestId': instance.requestId,
      'extendedRequestId': instance.extendedRequestId,
      'resourcePath': instance.resourcePath,
      'httpMethod': instance.httpMethod,
      'apiId': instance.apiId,
      'domainName': instance.domainName,
    };

AwsApiGatewayEventRequestContextIdentity
    _$AwsApiGatewayEventRequestContextIdentityFromJson(
            Map<String, dynamic> json) =>
        AwsApiGatewayEventRequestContextIdentity(
          cognitoIdentityPoolId: json['cognitoIdentityPoolId'] as String?,
          cognitoAuthenticationProvider:
              json['cognitoAuthenticationProvider'] as String?,
          cognitoAuthenticationType:
              json['cognitoAuthenticationType'] as String?,
          caller: json['caller'] as String?,
          accountId: json['accountId'] as String?,
          cognitoIdentityId: json['cognitoIdentityId'] as String?,
          apiKey: json['apiKey'] as String?,
          sourceIp: json['sourceIp'] as String?,
          user: json['user'] as String?,
          userAgent: json['userAgent'] as String?,
          userArn: json['userArn'] as String?,
        );

Map<String, dynamic> _$AwsApiGatewayEventRequestContextIdentityToJson(
        AwsApiGatewayEventRequestContextIdentity instance) =>
    <String, dynamic>{
      'cognitoIdentityPoolId': instance.cognitoIdentityPoolId,
      'accountId': instance.accountId,
      'cognitoIdentityId': instance.cognitoIdentityId,
      'caller': instance.caller,
      'apiKey': instance.apiKey,
      'sourceIp': instance.sourceIp,
      'cognitoAuthenticationType': instance.cognitoAuthenticationType,
      'cognitoAuthenticationProvider': instance.cognitoAuthenticationProvider,
      'userArn': instance.userArn,
      'userAgent': instance.userAgent,
      'user': instance.user,
    };
