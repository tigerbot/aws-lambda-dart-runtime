import 'dart:io';
import 'dart:convert';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';
import 'package:test/test.dart';

final file = 'data/apigateway_event.json';

final String contents = File(file).readAsStringSync();
final Map<String, dynamic> json = jsonDecode(contents) as Map<String, dynamic>;

void main() {
  group('apigateway_default', () {
    test('json got parsed and creates an event', () async {
      final event = AwsApiGatewayEvent.fromJson(json);

      expect(event.body, equals(jsonEncode({'foo': 'bar'})));
      expect(event.path, equals('/test/hello'));
      expect(event.requestContext?.httpMethod, equals('POST'));
      expect(event.requestContext?.accountId, equals('123456789012'));
      expect(event.requestContext?.requestId,
          equals('41b45ea3-70b5-11e6-b7bd-69b5aaebc7d9'));
      expect(event.queryStringParameters, equals({'name': 'me'}));
      expect(event.requestContext?.resourcePath, equals('/{proxy+}'));
      expect(event.headers?['Accept-Encoding'],
          equals('gzip, deflate, lzma, sdch, br'));
    });
  });
}
