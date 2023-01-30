import 'package:aws_lambda_runtime/runtime/event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dynamodb_event.g.dart';

/// Event send by a DynamoDB stream that contains
/// the updated records in the DynamoDB table.
@JsonSerializable()
class AwsDynamoDBUpdateRecord extends Event {
  /// Keys ...
  @JsonKey(name: 'Keys')
  final Map<String, dynamic>? keys;

  /// New Image ...
  @JsonKey(name: 'NewImage')
  final Map<String, dynamic>? newImage;

  /// Old Image ....
  @JsonKey(name: 'OldImage')
  final Map<String, dynamic>? oldImage;

  factory AwsDynamoDBUpdateRecord.fromJson(Map<String, dynamic> json) =>
      _$AwsDynamoDBUpdateRecordFromJson(json);

  Map<String, dynamic> toJson() => _$AwsDynamoDBUpdateRecordToJson(this);

  const AwsDynamoDBUpdateRecord({this.keys, this.oldImage, this.newImage});
}

/// DynamoDB Update Event Record ...
@JsonSerializable()
class AwsDynamoDBUpdateEventRecord {
  @JsonKey()
  final AwsDynamoDBUpdateRecord? dynamodb;

  /// Event Id ...
  @JsonKey()
  final String? eventId;

  /// Event Name ...
  @JsonKey()
  final String? eventName;

  /// Event Source ...
  @JsonKey()
  final String? eventSource;

  /// Event Version ...
  @JsonKey()
  final String? eventVersion;

  /// AWS Region ...
  @JsonKey()
  final String? awsRegion;

  /// Event Source ARN ...
  @JsonKey()
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
@JsonSerializable()
class AwsDynamoDBUpdateEvent extends Event {
  /// awslogs ...
  @JsonKey(name: 'Records')
  final List<AwsDynamoDBUpdateEventRecord>? records;

  factory AwsDynamoDBUpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsDynamoDBUpdateEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsDynamoDBUpdateEventToJson(this);

  const AwsDynamoDBUpdateEvent({this.records});
}
