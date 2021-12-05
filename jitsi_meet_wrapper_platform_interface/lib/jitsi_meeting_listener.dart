/// JitsiMeetingListener
///
/// Class holding the callback functions for conference events.
class JitsiMeetingListener {
  /// The native view got created.
  final Function()? onOpened;
  final Function(String url)? onConferenceWillJoin;
  final Function(String url)? onConferenceJoined;
  final Function(String url, Object? error)? onConferenceTerminated;

  /// The native view got closed.
  final Function()? onClosed;

  JitsiMeetingListener({
    this.onOpened,
    this.onConferenceWillJoin,
    this.onConferenceJoined,
    this.onConferenceTerminated,
    this.onClosed,
  });
}
