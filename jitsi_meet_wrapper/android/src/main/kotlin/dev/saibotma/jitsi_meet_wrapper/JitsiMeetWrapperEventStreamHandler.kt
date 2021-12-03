package dev.saibotma.jitsi_meet_wrapper

import io.flutter.plugin.common.EventChannel
import java.io.Serializable

class JitsiMeetWrapperEventStreamHandler : EventChannel.StreamHandler, Serializable {
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
}