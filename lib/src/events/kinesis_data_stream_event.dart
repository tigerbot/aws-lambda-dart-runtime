import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'kinesis_data_stream_event.g.dart';

/// Kinesis .....
@JsonSerializable()
class AwsKinesisDataStream extends Event {
  /// Partition Key ...
  final String? partitionKey;

  /// Kinesis Schema Version ...
  final String? kinesisSchemaVersion;

  /// Data ...
  final String? data;

  /// Sequenzer Number ...
  final String? sequenceNumber;

  /// Approximate Arrival Timestamp ...
  final int? approximateArrivalTimestamp;

  factory AwsKinesisDataStream.fromJson(Map<String, dynamic> json) {
    return _$AwsKinesisDataStreamFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsKinesisDataStreamToJson(this);

  const AwsKinesisDataStream({
    this.partitionKey,
    this.kinesisSchemaVersion,
    this.data,
    this.sequenceNumber,
    this.approximateArrivalTimestamp,
  });
}

/// Kinesis record that is send via [AwsKinesisDataStreamEvent].
@JsonSerializable()
class AwsKinesisDataStreamRecord {
  /// Data ...
  final AwsKinesisDataStream? kinesis;

  /// Source of the Event.
  final String? eventSource;

  /// Event Id ...
  final String? eventID;

  /// Event Version ...
  final String? eventVersion;

  /// Event Name ...
  final String? eventName;

  /// Event Source ARN ...
  final String? eventSourceARN;

  /// Invokey Identity ARN ...
  final String? invokeIdentityArn;

  /// Aws Region this event was emitted from
  final String? awsRegion;

  factory AwsKinesisDataStreamRecord.fromJson(Map<String, dynamic> json) {
    return _$AwsKinesisDataStreamRecordFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsKinesisDataStreamRecordToJson(this);

  const AwsKinesisDataStreamRecord({
    this.kinesis,
    this.invokeIdentityArn,
    this.eventName,
    this.eventID,
    this.eventSource,
    this.eventVersion,
    this.eventSourceARN,
    this.awsRegion,
  });
}

/// Kinesis Event ...
@JsonSerializable(fieldRename: FieldRename.pascal)
class AwsKinesisDataStreamEvent extends Event {
  /// The SQS message records that have been send with the event.
  final List<AwsKinesisDataStreamRecord>? records;

  factory AwsKinesisDataStreamEvent.fromJson(Map<String, dynamic> json) {
    return _$AwsKinesisDataStreamEventFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsKinesisDataStreamEventToJson(this);

  const AwsKinesisDataStreamEvent({this.records});
}
