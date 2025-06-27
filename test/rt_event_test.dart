import 'package:test/test.dart';

import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';
import 'package:aws_lambda_runtime/src/runtime/environment.dart';

class CustomTestEvent extends Event {
  factory CustomTestEvent.fromJson(Map<String, dynamic> json) {
    return CustomTestEvent();
  }

  CustomTestEvent();
}

void main() {
  group('events', () {
    test('can be (de)registered from the Event class', () {
      Event.registerEvent(CustomTestEvent.fromJson);
      expect(Event.exists<CustomTestEvent>(), true);

      Event.deregisterEvent<CustomTestEvent>();
      expect(Event.exists<CustomTestEvent>(), false);
    });

    test('can be registered from a Runtime instance', () {
      final env = Environment(runtimeAPI: 'foo', handler: 'bar');
      final rt = Runtime.fromEnv(env);

      rt.registerEvent(CustomTestEvent.fromJson);
      expect(Event.exists<CustomTestEvent>(), true);

      rt.deregisterEvent<CustomTestEvent>();
      expect(Event.exists<CustomTestEvent>(), false);
    });

    test('parser can be retrieved', () {
      final parser = Event.parser<AwsALBEvent>();
      expect(parser, equals(AwsALBEvent.fromJson));
    });
  });
}
