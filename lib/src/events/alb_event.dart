import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
import './aws_http_response.dart';

part 'alb_event.g.dart';

/// The response for an ALB event is an HTTP response.
typedef AwsALBResponse = AwsHttpResponse;

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

/// AWS ALB Event Request Context ...
@JsonSerializable()
class AwsALBEventContext {
  factory AwsALBEventContext.fromJson(Map<String, dynamic> json) =>
      _$AwsALBEventContextFromJson(json);

  Map<String, dynamic> toJson() => _$AwsALBEventContextToJson(this);

  const AwsALBEventContext();
}
