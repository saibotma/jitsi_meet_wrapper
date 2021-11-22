import 'package:collection/collection.dart';

import 'feature_flag.dart';

class JitsiMeetingOptions {
  final String room;
  final String? serverUrl;
  final String? subject;
  final String? token;
  final bool? isAudioMuted;
  final bool? isAudioOnly;
  final bool? isVideoMuted;
  final String? userDisplayName;
  final String? userEmail;
  final String? iosAppBarRGBAColor;
  final String? userAvatarUrl;
  final Map<FeatureFlag, bool> featureFlags;

  JitsiMeetingOptions({
    required this.room,
    this.serverUrl,
    this.subject,
    this.token,
    this.isAudioMuted,
    this.isAudioOnly,
    this.isVideoMuted,
    this.userDisplayName,
    this.userEmail,
    this.iosAppBarRGBAColor,
    this.userAvatarUrl,
    this.featureFlags = const {},
  });

  @override
  String toString() {
    return 'JitsiMeetingOptions{room: $room, serverUrl: $serverUrl, subject: $subject, token: $token, isAudioMuted: $isAudioMuted, isAudioOnly: $isAudioOnly, isVideoMuted: $isVideoMuted, userDisplayName: $userDisplayName, userEmail: $userEmail, iosAppBarRGBAColor: $iosAppBarRGBAColor, userAvatarUrl: $userAvatarUrl, featureFlags: $featureFlags}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JitsiMeetingOptions &&
          runtimeType == other.runtimeType &&
          room == other.room &&
          serverUrl == other.serverUrl &&
          subject == other.subject &&
          token == other.token &&
          isAudioMuted == other.isAudioMuted &&
          isAudioOnly == other.isAudioOnly &&
          isVideoMuted == other.isVideoMuted &&
          userDisplayName == other.userDisplayName &&
          userEmail == other.userEmail &&
          iosAppBarRGBAColor == other.iosAppBarRGBAColor &&
          userAvatarUrl == other.userAvatarUrl &&
          const MapEquality().equals(featureFlags, other.featureFlags);

  @override
  int get hashCode =>
      room.hashCode ^
      serverUrl.hashCode ^
      subject.hashCode ^
      token.hashCode ^
      isAudioMuted.hashCode ^
      isAudioOnly.hashCode ^
      isVideoMuted.hashCode ^
      userDisplayName.hashCode ^
      userEmail.hashCode ^
      iosAppBarRGBAColor.hashCode ^
      userAvatarUrl.hashCode ^
      const MapEquality().hash(featureFlags);
}
