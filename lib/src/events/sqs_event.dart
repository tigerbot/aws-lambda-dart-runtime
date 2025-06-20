import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'sqs_event.g.dart';

/// SQS Event Record that is send via [AwsSQSEvent].
@JsonSerializable()
class AwsSQSEventRecord extends Event {
  /// Id of the SQS message.
  final String? messageId;

  /// Name of the receipt handle.
  final String? receiptHandle;

  /// Body of the message
  final String? body;

  /// Attributes that are send with the event.
  final Map<String, dynamic>? attributes;

  /// Message attributes that are send with the event.
  final Map<String, dynamic>? messageAttributes;

  /// The md5 hash of the message body.
  final String? md5OfBody;

  /// Source of the Event.
  final String? eventSource;

  /// Source of the Event ARN.
  final String? eventSourceARN;

  /// Aws Region this event was emitted from
  final String? awsRegion;

  factory AwsSQSEventRecord.fromJson(Map<String, dynamic> json) {
    return _$AwsSQSEventRecordFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsSQSEventRecordToJson(this);

  const AwsSQSEventRecord({
    this.messageId,
    this.body,
    this.receiptHandle,
    this.attributes,
    this.messageAttributes,
    this.md5OfBody,
    this.eventSource,
    this.eventSourceARN,
    this.awsRegion,
  });
}

/// Event that is send via SQS to trigger for an innovation
/// of a Lambda.
@JsonSerializable(fieldRename: FieldRename.pascal)
class AwsSQSEvent extends Event {
  /// The SQS message records that have been send with the event.
  final List<AwsSQSEventRecord>? records;

  factory AwsSQSEvent.fromJson(Map<String, dynamic> json) {
    return _$AwsSQSEventFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsSQSEventToJson(this);

  const AwsSQSEvent({this.records});
}
