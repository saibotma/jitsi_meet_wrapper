import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

void main() {
  const MethodChannel channel = MethodChannel('jitsi_meet_wrapper');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await JitsiMeetWrapper.platformVersion, '42');
  });
}
