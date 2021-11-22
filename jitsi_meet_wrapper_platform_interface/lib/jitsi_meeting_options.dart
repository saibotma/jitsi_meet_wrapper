import 'feature_flag/feature_flag_enum.dart';

class JitsiMeetingOptions {
  final String room;
  final String? serverUrl;
  final String? subject;
  final String? token;
  final bool? audioMuted;
  final bool? audioOnly;
  final bool? videoMuted;
  final String? userDisplayName;
  final String? userEmail;
  final String? iosAppBarRGBAColor;
  final String? userAvatarUrl;
  final Map<FeatureFlagEnum, bool> featureFlags;

  JitsiMeetingOptions({
    required this.room,
    this.serverUrl,
    this.subject,
    this.token,
    this.audioMuted,
    this.audioOnly,
    this.videoMuted,
    this.userDisplayName,
    this.userEmail,
    this.iosAppBarRGBAColor,
    this.userAvatarUrl,
    this.featureFlags = const {},
  });

  @override
  String toString() {
    return 'JitsiMeetingOptions{room: $room, serverURL: $serverUrl, '
        'subject: $subject, token: $token, audioMuted: $audioMuted, '
        'audioOnly: $audioOnly, videoMuted: $videoMuted, '
        'userDisplayName: $userDisplayName, userEmail: $userEmail, '
        'iosAppBarRGBAColor :$iosAppBarRGBAColor, featureFlags: $featureFlags }';
  }
}
