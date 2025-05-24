import 'dart:io';
import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() {
  const customHeaders = {'Set-Cookie': 'saved_value=dummy'};

  group('fromString', () {
    const addedHeader = {'Content-Type': 'text/html; charset=utf-8'};

    test('creates response with default values', () {
      final response = AwsALBResponse.fromString('SUCCESS');

      expect(response.body, equals('SUCCESS'));
      expect(response.statusCode, equals(200));
      expect(response.headers, equals(addedHeader));
      expect(response.isBase64Encoded, equals(false));
    });

    test('creates a response with HTTP Status 400', () {
      final response = AwsALBResponse.fromString('SUCCESS',
          statusCode: HttpStatus.badRequest);

      expect(response.body, equals('SUCCESS'));
      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(response.statusDescription, equals('400 Bad Request'));
      expect(response.headers, equals(addedHeader));
      expect(response.isBase64Encoded, equals(false));
    });

    test('creates an event additional headers', () {
      final response =
          AwsALBResponse.fromString("<body/>", headers: customHeaders);

      expect(response.headers,
          equals(Map.from(customHeaders)..addAll(addedHeader)));
    });
  });

  group('fromJson', () {
    const addedHeader = {'Content-Type': 'application/json; charset=utf-8'};
    test('creates event with default values', () {
      final response = AwsApiGatewayResponse.fromJson({});

      expect(response.body, equals("{}"));
      expect(response.statusCode, equals(200));
      expect(response.headers, equals(addedHeader));
      expect(response.isBase64Encoded, equals(false));
    });

    test('creates an event with HTTP Status 400', () {
      final response =
          AwsApiGatewayResponse.fromJson({}, statusCode: HttpStatus.badRequest);

      expect(response.body, equals({}.toString()));
      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(response.isBase64Encoded, equals(false));
    });

    test('creates an event additional headers', () {
      final response =
          AwsApiGatewayResponse.fromJson({}, headers: customHeaders);

      expect(response.headers,
          equals(Map.from(customHeaders)..addAll(addedHeader)));
    });
  });

  group('toJson', () {
    test('with default values', () {
      const expected = {'statusCode': 200, 'statusDescription': '200 OK'};
      final response = AwsHttpResponse();

      expect(response.toJson(), equals(expected));
    });

    test('with all values', () {
      const b64Body = 'SGVsbG8gV29ybGQhCg==';
      const expected = {
        'statusCode': 400,
        'statusDescription': 'Custom Message',
        'headers': customHeaders,
        'body': b64Body,
        'isBase64Encoded': true,
      };
      final response = AwsHttpResponse(
        statusCode: 400,
        statusDescription: 'Custom Message',
        headers: customHeaders,
        body: b64Body,
        isBase64Encoded: true,
      );

      expect(response.toJson(), equals(expected));
    });
  });
}
