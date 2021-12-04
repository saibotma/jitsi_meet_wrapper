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
}
