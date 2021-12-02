/// JitsiMeetingListener
///
/// Class holding the callback functions for conference events.
class JitsiMeetingListener {
  final Function(Map<dynamic, dynamic> message)? onConferenceWillJoin;
  final Function(Map<dynamic, dynamic> message)? onConferenceJoined;
  final Function(Map<dynamic, dynamic> message)? onConferenceTerminated;

  JitsiMeetingListener({
    this.onConferenceWillJoin,
    this.onConferenceJoined,
    this.onConferenceTerminated,
  });
}
