// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'feature_flag.dart';

class JitsiMeetingOptions {
  final String roomNameOrUrl;
  final String? serverUrl;
  final String? subject;
  final String? token;
  final bool? isAudioMuted;
  final bool? isAudioOnly;
  final bool? isVideoMuted;
  final String? userDisplayName;
  final String? userEmail;
  final String? userAvatarUrl;
  final Map<FeatureFlag, Object?>? featureFlags;
  final Map<String, Object?>? configOverrides;

  JitsiMeetingOptions({
    required this.roomNameOrUrl,
    this.serverUrl,
    this.subject,
    this.token,
    this.isAudioMuted,
    this.isAudioOnly,
    this.isVideoMuted,
    this.userDisplayName,
    this.userEmail,
    this.userAvatarUrl,
    this.featureFlags,
    this.configOverrides,
  });

  @override
  String toString() {
    return 'JitsiMeetingOptions{roomNameOrUrl: $roomNameOrUrl, serverUrl: $serverUrl, subject: $subject, token: $token, isAudioMuted: $isAudioMuted, isAudioOnly: $isAudioOnly, isVideoMuted: $isVideoMuted, userDisplayName: $userDisplayName, userEmail: $userEmail, userAvatarUrl: $userAvatarUrl, featureFlags: $featureFlags, configOverrides: $configOverrides}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JitsiMeetingOptions &&
          runtimeType == other.runtimeType &&
          roomNameOrUrl == other.roomNameOrUrl &&
          serverUrl == other.serverUrl &&
          subject == other.subject &&
          token == other.token &&
          isAudioMuted == other.isAudioMuted &&
          isAudioOnly == other.isAudioOnly &&
          isVideoMuted == other.isVideoMuted &&
          userDisplayName == other.userDisplayName &&
          userEmail == other.userEmail &&
          userAvatarUrl == other.userAvatarUrl &&
          const MapEquality().equals(featureFlags, other.featureFlags) &&
          const MapEquality().equals(configOverrides, other.configOverrides);

  @override
  int get hashCode =>
      roomNameOrUrl.hashCode ^
      serverUrl.hashCode ^
      subject.hashCode ^
      token.hashCode ^
      isAudioMuted.hashCode ^
      isAudioOnly.hashCode ^
      isVideoMuted.hashCode ^
      userDisplayName.hashCode ^
      userEmail.hashCode ^
      userAvatarUrl.hashCode ^
      const MapEquality().hash(featureFlags) ^
      const MapEquality().hash(configOverrides);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomNameOrUrl': roomNameOrUrl,
      'serverUrl': serverUrl,
      'subject': subject,
      'token': token,
      'isAudioMuted': isAudioMuted,
      'isAudioOnly': isAudioOnly,
      'isVideoMuted': isVideoMuted,
      'userDisplayName': userDisplayName,
      'userEmail': userEmail,
      'userAvatarUrl': userAvatarUrl,
      'featureFlags': featureFlags,
      'configOverrides': configOverrides,
    };
  }

  factory JitsiMeetingOptions.fromMap(Map<String, dynamic> map) {
    return JitsiMeetingOptions(
      roomNameOrUrl: map['roomNameOrUrl'] as String,
      serverUrl: map['serverUrl'] != null ? map['serverUrl'] as String : null,
      subject: map['subject'] != null ? map['subject'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      isAudioMuted: map['isAudioMuted'] != null ? map['isAudioMuted'] as bool : null,
      isAudioOnly: map['isAudioOnly'] != null ? map['isAudioOnly'] as bool : null,
      isVideoMuted: map['isVideoMuted'] != null ? map['isVideoMuted'] as bool : null,
      userDisplayName: map['userDisplayName'] != null ? map['userDisplayName'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      userAvatarUrl: map['userAvatarUrl'] != null ? map['userAvatarUrl'] as String : null,
      featureFlags: map['featureFlags'] != null ? Map<FeatureFlag, Object?>.from(map['featureFlags'] as Map<FeatureFlag, Object?>) : null,
      configOverrides: map['configOverrides'] != null ? Map<String, Object?>.from(map['configOverrides'] as Map<String, Object?>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JitsiMeetingOptions.fromJson(String source) => JitsiMeetingOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
