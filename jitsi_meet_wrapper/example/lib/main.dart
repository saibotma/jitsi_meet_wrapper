import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Meeting());
  }
}

class Meeting extends StatefulWidget {
  const Meeting({Key? key}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "jitsi-meet-wrapper-test-room");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final tokenText = TextEditingController();
  final userDisplayNameText = TextEditingController(text: "Plugin Test User");
  final userEmailText = TextEditingController(text: "fake@email.com");
  final userAvatarUrlText = TextEditingController();

  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Jitsi Meet Wrapper Test')),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: buildMeetConfig(),
        ),
      ),
    );
  }

  Widget buildMeetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          _buildTextField(
            labelText: "Server URL",
            controller: serverText,
            hintText: "Hint: Leave empty for meet.jitsi.si",
          ),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "Room", controller: roomText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "Subject", controller: subjectText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "Token", controller: tokenText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "User Display Name", controller: userDisplayNameText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "User Email", controller: userEmailText),
          const SizedBox(height: 16.0),
          _buildTextField(labelText: "User Avatar URL", controller: userAvatarUrlText),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          const Divider(height: 48.0, thickness: 2.0),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () => _joinMeeting(),
              child: const Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue)),
            ),
          ),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlag, bool> featureFlags = {
      FeatureFlag.isWelcomePageEnabled: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlag.isCallIntegrationEnabled] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlag.isPipEnabled] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomName: roomText.text,
      serverUrl: serverUrl,
      subject: subjectText.text,
      token: tokenText.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: userDisplayNameText.text,
      userEmail: userEmailText.text,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(options);
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: labelText, hintText: hintText),
    );
  }
}
