import 'dart:async';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

class MyCustomEvent extends Event {
  final Map<String, dynamic> rawJson;
  const MyCustomEvent(this.rawJson);

  factory MyCustomEvent.fromJson(Map<String, dynamic> json) =>
      MyCustomEvent(json);
}

String successHandler(Context ctx, MyCustomEvent event) => "SUCCESS";

void main() async {
  /// The Runtime is a singleton. You can define the handlers as you wish.
  final rt = Runtime()
    ..registerEvent(MyCustomEvent.fromJson)
    ..registerHandler("doesnt.matter", successHandler)
    ..registerHandler('hello.apigateway', helloApiGateway);
  await rt.invoke();
}

/// This demo's handling an API Gateway request.
Future helloApiGateway(Context context, AwsApiGatewayEvent event) async {
  final response = {'message': 'hello ${context.requestId}'};

  /// it returns an response to the gateway
  return AwsApiGatewayResponse.fromJson(response);
}
