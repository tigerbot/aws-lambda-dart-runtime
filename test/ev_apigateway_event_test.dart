import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

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

  group('AwsApiGatewayResponse', () {
    const customHeaders = {'Set-Cookie': 'saved_value=dummy'};

    group('fromJson', () {
      const addedHeader = {'Content-Type': 'application/json; charset=utf-8'};
      test('with default values', () {
        final response = AwsApiGatewayResponse.fromJson({});

        expect(response.body, equals("{}"));
        expect(response.statusCode, equals(200));
        expect(response.headers, equals(addedHeader));
        expect(response.isBase64Encoded, equals(false));
      });

      test('with all values', () {
        final response = AwsApiGatewayResponse.fromJson({},
            statusCode: HttpStatus.badRequest, headers: customHeaders);

        expect(response.body, equals({}.toString()));
        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(response.isBase64Encoded, equals(false));
        expect(response.headers,
            equals(Map.from(customHeaders)..addAll(addedHeader)));
      });
    });

    group('toJson', () {
      test('with default values', () {
        const expected = {'statusCode': 200};
        final response = AwsApiGatewayResponse();

        expect(response.toJson(), equals(expected));
      });

      test('with all values', () {
        const b64Body = 'SGVsbG8gV29ybGQhCg==';
        const expected = {
          'statusCode': 400,
          'headers': customHeaders,
          'body': b64Body,
          'isBase64Encoded': true,
        };
        final response = AwsApiGatewayResponse(
          statusCode: 400,
          headers: customHeaders,
          body: b64Body,
          isBase64Encoded: true,
        );

        expect(response.toJson(), equals(expected));
      });
    });
  });
}
