/// JitsiMeetingListener
///
/// Class holding the callback functions for conference events.
class JitsiMeetingListener {
  final Function(String url)? onConferenceWillJoin;
  final Function(String url)? onConferenceJoined;
  final Function(String url, Object? error)? onConferenceTerminated;
  final Function()? onOpened;
  final Function()? onClosed;

  JitsiMeetingListener({
    this.onConferenceWillJoin,
    this.onConferenceJoined,
    this.onConferenceTerminated,
    this.onOpened,
    this.onClosed,
  });
}
