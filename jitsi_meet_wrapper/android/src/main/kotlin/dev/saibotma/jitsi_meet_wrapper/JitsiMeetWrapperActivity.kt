package dev.saibotma.jitsi_meet_wrapper

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import org.jitsi.meet.sdk.JitsiMeetActivity
import org.jitsi.meet.sdk.JitsiMeetConferenceOptions
import java.util.HashMap


class JitsiMeetWrapperActivity : JitsiMeetActivity() {
    private val eventStreamHandler = JitsiMeetWrapperEventStreamHandler.instance

    companion object {
        fun launch(context: Context, options: JitsiMeetConferenceOptions?) {
            val intent = Intent(context, JitsiMeetWrapperActivity::class.java)
            intent.action = "org.jitsi.meet.CONFERENCE"
            intent.putExtra("JitsiMeetConferenceOptions", options)
            if (context !is Activity) {
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        eventStreamHandler.onOpened()
    }

    override fun onReadyToClose() {
        super.onReadyToClose()
        eventStreamHandler.onReadyToClose()
    }

    override fun onConferenceWillJoin(extraData: HashMap<String, Any>?) {
        super.onConferenceWillJoin(extraData)
        eventStreamHandler.onConferenceWillJoin(extraData)
    }

    override fun onConferenceJoined(extraData: HashMap<String, Any>?) {
        super.onConferenceJoined(extraData)
        eventStreamHandler.onConferenceJoined(extraData)
    }

    override fun onConferenceTerminated(extraData: HashMap<String, Any>?) {
        super.onConferenceTerminated(extraData)
        eventStreamHandler.onConferenceTerminated(extraData)
    }

    override fun onDestroy() {
        super.onDestroy()
        eventStreamHandler.onClosed()
    }
}