import 'dart:io';
import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() {
  group('AwsALBResponse', () {
    const customHeaders = {'Set-Cookie': 'saved_value=dummy'};

    group('fromJson', () {
      const addedHeader = {'Content-Type': 'application/json; charset=utf-8'};
      test('with default values', () {
        final response = AwsALBResponse.fromJson({});

        expect(response.body, equals('{}'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.statusDescription, equals('200 OK'));
        expect(response.headers, equals(addedHeader));
        expect(response.isBase64Encoded, equals(false));
      });

      test('with status code', () {
        final response =
            AwsALBResponse.fromJson({}, statusCode: HttpStatus.unauthorized);
        expect(response.statusCode, equals(HttpStatus.unauthorized));
        expect(response.statusDescription, equals('401 Unauthorized'));
      });

      test('with all values', () {
        final response = AwsALBResponse.fromJson({},
            statusCode: HttpStatus.badRequest,
            statusDescription: 'Custom',
            headers: customHeaders);

        expect(response.body, equals({}.toString()));
        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(response.statusDescription, equals('Custom'));
        expect(response.isBase64Encoded, equals(false));
        expect(response.headers,
            equals(Map.from(customHeaders)..addAll(addedHeader)));
      });
    });

    group('fromString', () {
      const addedHeader = {'Content-Type': 'text/html; charset=utf-8'};

      test('with default values', () {
        final response = AwsALBResponse.fromString('SUCCESS');

        expect(response.body, equals('SUCCESS'));
        expect(response.statusDescription, equals('200 OK'));
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.headers, equals(addedHeader));
        expect(response.isBase64Encoded, equals(false));
      });

      test('with status code', () {
        final response =
            AwsALBResponse.fromJson({}, statusCode: HttpStatus.badRequest);
        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(response.statusDescription, equals('400 Bad Request'));
      });

      test('with all values', () {
        final response = AwsALBResponse.fromString('FAILURE',
            statusCode: HttpStatus.badRequest,
            statusDescription: 'Custom',
            headers: customHeaders);

        expect(response.body, equals('FAILURE'));
        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(response.statusDescription, equals('Custom'));
        expect(response.isBase64Encoded, equals(false));
        expect(response.headers,
            equals(Map.from(customHeaders)..addAll(addedHeader)));
      });
    });

    group('toJson', () {
      test('with default values', () {
        const expected = {'statusCode': 200, 'statusDescription': '200 OK'};
        final response = AwsALBResponse();

        expect(response.toJson(), equals(expected));
      });

      test('with status code', () {
        const expected = {
          'statusCode': 204,
          'statusDescription': '204 No Content'
        };
        final response = AwsALBResponse(statusCode: HttpStatus.noContent);

        expect(response.toJson(), equals(expected));
      });

      test('with all values', () {
        const b64Body = 'SGVsbG8gV29ybGQhCg==';
        const expected = {
          'statusCode': 400,
          'statusDescription': '400 CustomMessage',
          'headers': customHeaders,
          'body': b64Body,
          'isBase64Encoded': true,
        };
        final response = AwsALBResponse(
          statusCode: 400,
          statusDescription: '400 CustomMessage',
          headers: customHeaders,
          body: b64Body,
          isBase64Encoded: true,
        );

        expect(response.toJson(), equals(expected));
      });
    });
  });
}
