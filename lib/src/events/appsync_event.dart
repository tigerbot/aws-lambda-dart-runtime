import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'appsync_event.g.dart';

/// App Sync Event ...
@JsonSerializable()
class AwsAppSyncEvent extends Event {
  final String? version;

  final String? operation;

  final String? payload;

  factory AwsAppSyncEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsAppSyncEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsAppSyncEventToJson(this);

  const AwsAppSyncEvent({this.version, this.operation, this.payload});
}
