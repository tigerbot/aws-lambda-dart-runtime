import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'dynamodb_event.g.dart';

/// Event send by a DynamoDB stream that contains
/// the updated records in the DynamoDB table.
@JsonSerializable(fieldRename: FieldRename.pascal)
class AwsDynamoDBUpdateRecord extends Event {
  /// Keys ...
  final Map<String, dynamic>? keys;

  /// New Image ...
  final Map<String, dynamic>? newImage;

  /// Old Image ....
  final Map<String, dynamic>? oldImage;

  factory AwsDynamoDBUpdateRecord.fromJson(Map<String, dynamic> json) =>
      _$AwsDynamoDBUpdateRecordFromJson(json);

  Map<String, dynamic> toJson() => _$AwsDynamoDBUpdateRecordToJson(this);

  const AwsDynamoDBUpdateRecord({this.keys, this.oldImage, this.newImage});
}

/// DynamoDB Update Event Record ...
@JsonSerializable()
class AwsDynamoDBUpdateEventRecord {
  final AwsDynamoDBUpdateRecord? dynamodb;

  /// Event Id ...
  final String? eventId;

  /// Event Name ...
  final String? eventName;

  /// Event Source ...
  final String? eventSource;

  /// Event Version ...
  final String? eventVersion;

  /// AWS Region ...
  final String? awsRegion;

  /// Event Source ARN ...
  final String? eventSourceARN;

  factory AwsDynamoDBUpdateEventRecord.fromJson(Map<String, dynamic> json) =>
      _$AwsDynamoDBUpdateEventRecordFromJson(json);

  Map<String, dynamic> toJson() => _$AwsDynamoDBUpdateEventRecordToJson(this);

  const AwsDynamoDBUpdateEventRecord({
    this.eventId,
    this.eventName,
    this.eventSource,
    this.eventVersion,
    this.awsRegion,
    this.eventSourceARN,
    this.dynamodb,
  });
}

/// DynamoDB Update Event ...
@JsonSerializable(fieldRename: FieldRename.pascal)
class AwsDynamoDBUpdateEvent extends Event {
  /// awslogs ...
  final List<AwsDynamoDBUpdateEventRecord>? records;

  factory AwsDynamoDBUpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsDynamoDBUpdateEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsDynamoDBUpdateEventToJson(this);

  const AwsDynamoDBUpdateEvent({this.records});
}
