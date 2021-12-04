package dev.saibotma.jitsi_meet_wrapper

import io.flutter.plugin.common.EventChannel
import java.io.Serializable

// Needs to be singleton as it is not possible to pass object references to activities
// and JitsiMeetWrapperActivity needs access to it.
class JitsiMeetWrapperEventStreamHandler private constructor() : EventChannel.StreamHandler {
    companion object {
        val instance = JitsiMeetWrapperEventStreamHandler()
    }

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun onConferenceWillJoin(data: MutableMap<String, Any>?) {
        eventSink?.success(mapOf("event" to "conferenceWillJoin", "data" to data))
    }

    fun onConferenceJoined(data: MutableMap<String, Any>?) {
        eventSink?.success(mapOf("event" to "conferenceJoined", "data" to data))
    }

    fun onConferenceTerminated(data: MutableMap<String, Any>?) {
        eventSink?.success(mapOf("event" to "conferenceTerminated", "data" to data))
    }

    fun onReadyToClose() {
        eventSink?.success(mapOf("event" to "readyToClose"))
    }
}