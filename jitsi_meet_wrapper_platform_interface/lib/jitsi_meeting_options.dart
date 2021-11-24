import 'package:collection/collection.dart';

import 'feature_flag.dart';

class JitsiMeetingOptions {
  final String roomName;
  final String? serverUrl;
  final String? subject;
  final String? token;
  final bool isAudioMuted;
  final bool isAudioOnly;
  final bool isVideoMuted;
  final String? userDisplayName;
  final String? userEmail;
  final String? userAvatarUrl;
  final Map<FeatureFlag, Object?> featureFlags;

  JitsiMeetingOptions({
    required this.roomName,
    this.serverUrl,
    this.subject,
    this.token,
    this.isAudioMuted = false,
    this.isAudioOnly = false,
    this.isVideoMuted = false,
    this.userDisplayName,
    this.userEmail,
    this.userAvatarUrl,
    this.featureFlags = const {},
  });

  @override
  String toString() {
    return 'JitsiMeetingOptions{roomName: $roomName, serverUrl: $serverUrl, subject: $subject, token: $token, isAudioMuted: $isAudioMuted, isAudioOnly: $isAudioOnly, isVideoMuted: $isVideoMuted, userDisplayName: $userDisplayName, userEmail: $userEmail, userAvatarUrl: $userAvatarUrl, featureFlags: $featureFlags}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JitsiMeetingOptions &&
          runtimeType == other.runtimeType &&
          roomName == other.roomName &&
          serverUrl == other.serverUrl &&
          subject == other.subject &&
          token == other.token &&
          isAudioMuted == other.isAudioMuted &&
          isAudioOnly == other.isAudioOnly &&
          isVideoMuted == other.isVideoMuted &&
          userDisplayName == other.userDisplayName &&
          userEmail == other.userEmail &&
          userAvatarUrl == other.userAvatarUrl &&
          const MapEquality().equals(featureFlags, other.featureFlags);

  @override
  int get hashCode =>
      roomName.hashCode ^
      serverUrl.hashCode ^
      subject.hashCode ^
      token.hashCode ^
      isAudioMuted.hashCode ^
      isAudioOnly.hashCode ^
      isVideoMuted.hashCode ^
      userDisplayName.hashCode ^
      userEmail.hashCode ^
      userAvatarUrl.hashCode ^
      const MapEquality().hash(featureFlags);
}
