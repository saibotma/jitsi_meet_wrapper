
import 'dart:async';

import 'package:flutter/services.dart';

class JitsiMeetWrapper {
  static const MethodChannel _channel = MethodChannel('jitsi_meet_wrapper');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
