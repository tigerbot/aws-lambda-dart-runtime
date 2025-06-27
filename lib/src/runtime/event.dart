import '../events/alb_event.dart';
import '../events/alexa_event.dart';
import '../events/apigateway_event.dart';
import '../events/appsync_event.dart';
import '../events/cloudwatch_event.dart';
import '../events/cloudwatch_log_event.dart';
import '../events/cognito_event.dart';
import '../events/dynamodb_event.dart';
import '../events/kinesis_data_stream_event.dart';
import '../events/s3_event.dart';
import '../events/sqs_event.dart';

/// A function which converts the JSON body from the
/// Lambda Runtime API into [E].
typedef EventParser<E extends Event> = E Function(Map<String, dynamic>);

/// Event is the abstraction for every event that
/// can be ingested by a handler.
abstract class Event {
  const Event();
  static final Map<Type, EventParser<Event>> _registry = {
    AwsALBEvent: AwsALBEvent.fromJson,
    AwsAlexaEvent: AwsAlexaEvent.fromJson,
    AwsApiGatewayEvent: AwsApiGatewayEvent.fromJson,
    AwsAppSyncEvent: AwsAppSyncEvent.fromJson,
    AwsCloudwatchEvent: AwsCloudwatchEvent.fromJson,
    AwsCloudwatchLogEvent: AwsCloudwatchLogEvent.fromJson,
    AwsCognitoEvent: AwsCognitoEvent.fromJson,
    AwsDynamoDBUpdateEvent: AwsDynamoDBUpdateEvent.fromJson,
    AwsKinesisDataStreamEvent: AwsKinesisDataStreamEvent.fromJson,
    AwsS3Event: AwsS3Event.fromJson,
    AwsSQSEvent: AwsSQSEvent.fromJson,
  };

  /// Checks if a type of event is already registered.
  static bool exists<E extends Event>() => Event._registry.containsKey(E);

  /// Returs the parser of a registered event. It is `null`
  /// if no such event has been registered.
  static EventParser<E>? parser<E extends Event>() =>
      Event._registry[E] as EventParser<E>?;

  /// Registers an event.
  static void registerEvent<E extends Event>(EventParser<E> func) =>
      Event._registry[E] = func as EventParser<Event>;

  /// Deregisters an event.
  static void deregisterEvent<E extends Event>() => Event._registry.remove(E);

  /// Creates a new event for a handler from the invocation data.
  static Event fromHandler(Type type, Map<String, dynamic> json) =>
      _registry[type]!(json);
}
