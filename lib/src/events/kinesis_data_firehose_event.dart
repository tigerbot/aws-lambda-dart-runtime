import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'kinesis_data_firehose_event.g.dart';

/// Kinesis .....
@JsonSerializable()
class AwsKinesisFirehoseData extends Event {
  /// Record ID ...
  final String? recordId;

  /// Approximated Arrival Timestamp ...
  final int? approximateArrivalTimestamp;

  /// Data ...
  final String? data;

  factory AwsKinesisFirehoseData.fromJson(Map<String, dynamic> json) {
    return _$AwsKinesisFirehoseDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsKinesisFirehoseDataToJson(this);

  const AwsKinesisFirehoseData({
    this.recordId,
    this.data,
    this.approximateArrivalTimestamp,
  });
}

/// Kinesis Event ...
@JsonSerializable()
class AwsKinesisFirehoseDataEvent {
  /// Invocation ID ...
  final String? invocationId;

  /// Delivery Stream ARN ...
  final String? deliveryStreamArn;

  /// Region ...
  final String? region;

  /// Records ...
  final List<AwsKinesisFirehoseData>? records;

  factory AwsKinesisFirehoseDataEvent.fromJson(Map<String, dynamic> json) {
    return _$AwsKinesisFirehoseDataEventFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AwsKinesisFirehoseDataEventToJson(this);

  const AwsKinesisFirehoseDataEvent({
    this.records,
    this.invocationId,
    this.deliveryStreamArn,
    this.region,
  });
}
