import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'jitsi_meet_native_view_controller.dart';
import 'package:jitsi_meet_wrapper_platform_interface/jitsi_meeting_listener.dart';
import 'package:jitsi_meet_wrapper_platform_interface/jitsi_meeting_options.dart';

typedef JItsiMeetNativeViewCreatedCallback = void Function(
    JitsiMeetViewController controller);

class JitsiMeetNativeView extends StatelessWidget {
  const JitsiMeetNativeView({
    Key? key,
    required this.onViewCreated,
    required this.options,
  }) : super(key: key);

  final JItsiMeetNativeViewCreatedCallback onViewCreated;
  final JitsiMeetingOptions options;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'plugins.jitsi_meet_wrapper:jitsi_meet_native_view';

    return UiKitView(
      viewType: viewType,
      creationParams: options.toMap(),
      layoutDirection: TextDirection.ltr,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) => onViewCreated(
        JitsiMeetViewController(
          id: id,
        ),
      );
}
