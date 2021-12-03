package dev.saibotma.jitsi_meet_wrapper

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import androidx.localbroadcastmanager.content.LocalBroadcastManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.jitsi.meet.sdk.*
import java.net.URL

// Got most of this from the example:
// https://github.com/jitsi/jitsi-meet-sdk-samples/blob/18c35f7625b38233579ff34f761f4c126ba7e03a/android/kotlin/JitsiSDKTest/app/src/main/kotlin/net/jitsi/sdktest/MainActivity.kt
class JitsiMeetWrapperPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var eventStreamHandler: JitsiMeetWrapperEventStreamHandler
    private var activity: Activity? = null

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            onBroadcastReceived(intent)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "jitsi_meet_wrapper")
        methodChannel.setMethodCallHandler(this)

        eventStreamHandler = JitsiMeetWrapperEventStreamHandler()
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "jitsi_meet_wrapper_events")
        eventChannel.setStreamHandler(eventStreamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "joinMeeting" -> joinMeeting(call, result)
            else -> result.notImplemented()
        }
    }

    private fun joinMeeting(call: MethodCall, result: Result) {
        registerForBroadcastMessages()

        val room = call.argument<String>("roomName")!!
        if (room.isBlank()) {
            result.error(
                    "400",
                    "room can not be null or empty",
                    "room can not be null or empty"
            )
            return
        }

        val serverUrlString = call.argument<String>("serverUrl") ?: "https://meet.jit.si"
        val serverUrl = URL(serverUrlString)

        val subject: String? = call.argument("subject")
        val token: String? = call.argument("token")
        val isAudioMuted: Boolean = call.argument("isAudioMuted")!!
        val isAudioOnly: Boolean = call.argument("isAudioOnly")!!
        val isVideoMuted: Boolean = call.argument("isVideoMuted")!!

        val userInfo = JitsiMeetUserInfo().apply {
            displayName = call.argument("userDisplayName")
            email = call.argument("userEmail")
            val userAvatarUrlString: String? = call.argument("userAvatarUrl")
            avatar = if (userAvatarUrlString != null) URL(userAvatarUrlString) else null
        }

        val options = JitsiMeetConferenceOptions.Builder().run {
            setRoom(room)
            setServerURL(serverUrl)
            setSubject(subject)
            setToken(token)
            setAudioMuted(isAudioMuted)
            setAudioOnly(isAudioOnly)
            setVideoMuted(isVideoMuted)
            setUserInfo(userInfo)

            val featureFlags = call.argument<HashMap<String, Any?>>("featureFlags")!!
            featureFlags.forEach { (key, value) ->
                // Can only be bool, int or string according to
                // the overloads of setFeatureFlag.
                when (value) {
                    is Boolean -> setFeatureFlag(key, value)
                    is Int -> setFeatureFlag(key, value)
                    else -> setFeatureFlag(key, value.toString())
                }
            }

            val configOverrides = call.argument<HashMap<String, Any?>>("configOverrides")!!
            configOverrides.forEach { (key, value) ->
                // Can only be bool, int, array of strings or string according to
                // the overloads of setConfigOverride.
                when (value) {
                    is Boolean -> setConfigOverride(key, value)
                    is Int -> setConfigOverride(key, value)
                    is Array<*> -> setConfigOverride(key, value as Array<out String>)
                    else -> setConfigOverride(key, value.toString())
                }
            }

            build()
        }

        JitsiMeetActivity.launch(activity, options)
        result.success("Successfully joined room: $room")
    }

    override fun onDetachedFromActivity() {
        this.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        LocalBroadcastManager.getInstance(activity!!.applicationContext).unregisterReceiver(broadcastReceiver)
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    private fun registerForBroadcastMessages() {
        val intentFilter = IntentFilter()

        with(intentFilter) {
            addAction(BroadcastEvent.Type.CONFERENCE_WILL_JOIN.action)
            addAction(BroadcastEvent.Type.CONFERENCE_JOINED.action)
            addAction(BroadcastEvent.Type.CONFERENCE_TERMINATED.action)
        }

        LocalBroadcastManager.getInstance(activity!!.applicationContext)
                .registerReceiver(broadcastReceiver, intentFilter)
    }

    private fun onBroadcastReceived(intent: Intent?) {
        if (intent != null) {
            val event = BroadcastEvent(intent)
            val data = event.data
            when (event.type) {
                BroadcastEvent.Type.CONFERENCE_WILL_JOIN -> {
                    eventStreamHandler.onConferenceWillJoin(data)
                }
                BroadcastEvent.Type.CONFERENCE_JOINED -> {
                    eventStreamHandler.onConferenceJoined(data)
                }
                BroadcastEvent.Type.CONFERENCE_TERMINATED -> {
                    eventStreamHandler.onConferenceTerminated(data)
                }
                else -> {}
            }
        }
    }
}
