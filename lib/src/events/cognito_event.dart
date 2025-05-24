import 'package:json_annotation/json_annotation.dart';

import '../runtime/event.dart';
part 'cognito_event.g.dart';

@JsonSerializable()
class AwsCognitoEvent extends Event {
  final int? version;
  final String? triggerSource;
  final String? region;
  final String? userPoolId;
  final String? userName;
  final Map<String, String>? callerContext;
  final AwsCognitoRequest? request;
  final AwsCognitoResponse? response;

  const AwsCognitoEvent({
    this.version,
    this.triggerSource,
    this.region,
    this.userPoolId,
    this.userName,
    this.callerContext,
    this.request,
    this.response,
  });

  factory AwsCognitoEvent.fromJson(Map<String, dynamic> json) =>
      _$AwsCognitoEventFromJson(json);

  Map<String, dynamic> toJson() => _$AwsCognitoEventToJson(this);
}

@JsonSerializable()
class AwsCognitoRequest {
  final Map<String, dynamic>? userAttributes;
  final Map<String, String>? validationData;
  final Map<String, String>? clientMetadata;
  final bool? newDeviceUsed;
  final AwsGroupConfiguration? groupConfiguration;
  final String? password;
  final String? codeParameter;

  const AwsCognitoRequest({
    this.userAttributes,
    this.validationData,
    this.clientMetadata,
    this.newDeviceUsed,
    this.codeParameter,
    this.password,
    this.groupConfiguration,
  });

  factory AwsCognitoRequest.fromJson(Map<String, dynamic> json) =>
      _$AwsCognitoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AwsCognitoRequestToJson(this);
}

@JsonSerializable()
class AwsCognitoResponse {
  final bool? autoConfirmUser;
  final bool? autoVerifyPhone;
  final bool? autoVerifyEmail;
  final AwsClaimOverrideDetails? claimsOverrideDetails;
  final Map<String, String>? userAttributes;
  final String? finalUserStatus;
  final String? messageAction;
  final List<String>? desiredDeliveryMediums;
  final bool? forceAliasCreation;
  final String? smsMessage;
  final String? emailMessage;
  final String? emailSubject;

  const AwsCognitoResponse({
    this.autoConfirmUser,
    this.autoVerifyEmail,
    this.autoVerifyPhone,
    this.claimsOverrideDetails,
    this.userAttributes,
    this.finalUserStatus,
    this.desiredDeliveryMediums,
    this.forceAliasCreation,
    this.messageAction,
    this.smsMessage,
    this.emailMessage,
    this.emailSubject,
  });

  factory AwsCognitoResponse.fromJson(Map<String, dynamic> json) =>
      _$AwsCognitoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AwsCognitoResponseToJson(this);
}

@JsonSerializable()
class AwsGroupConfiguration {
  final List<String>? groupsToOverride;
  final List<String>? iamRolesToOverride;
  final String? preferredRole;
  final Map<String, String>? clientMetadata;

  const AwsGroupConfiguration({
    this.groupsToOverride,
    this.iamRolesToOverride,
    this.preferredRole,
    this.clientMetadata,
  });

  factory AwsGroupConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AwsGroupConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$AwsGroupConfigurationToJson(this);
}

@JsonSerializable()
class AwsClaimOverrideDetails {
  final Map<String, String>? claimsToAddOrOverride;
  final List<String>? claimsToSuppress;
  final AwsGroupConfiguration? groupOverrideDetails;

  const AwsClaimOverrideDetails({
    this.claimsToAddOrOverride,
    this.claimsToSuppress,
    this.groupOverrideDetails,
  });

  factory AwsClaimOverrideDetails.fromJson(Map<String, dynamic> json) =>
      _$AwsClaimOverrideDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AwsClaimOverrideDetailsToJson(this);
}
