import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'cloudwatch_event.g.dart';

/// Event that is send via SQS to trigger for an innovation
/// of a Lambda.
///
/// Example
///
/// ```
/// {
///   "id": "cdc73f9d-aea9-11e3-9d5a-835b769c0d9c",
///   "detail-type": "Scheduled Event",
///   "source": "aws.events",
///   "account": "{{{account-id}}}",
///   "time": "1970-01-01T00:00:00Z",
///   "region": "eu-west-1",
///   "resources": [
///     "arn:aws:events:eu-west-1:123456789012:rule/ExampleRule"
///   ],
///   "detail": {}
/// }
/// ```
@JsonSerializable(fieldRename: FieldRename.kebab)
class AwsCloudwatchEvent extends Event {
  /// Resources ...
  final List<String>? resources;

  /// Region ...
  final String? region;

  /// Id ...
  final String? id;

  /// Source ...
  final String? source;

  /// Account ...
  final String? account;

  /// Data Type ...
  final String? detailType;

  /// Detail ...
  final Map<String, dynamic>? detail;

  /// Time ...
  final DateTime? time;

  factory AwsCloudwatchEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsCloudwatchEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsCloudwatchEventToJson(this);

  const AwsCloudwatchEvent({
    this.resources,
    this.region,
    this.id,
    this.source,
    this.account,
    this.detailType,
    this.detail,
    this.time,
  });
}
