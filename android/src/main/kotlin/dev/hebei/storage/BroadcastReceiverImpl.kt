package dev.hebei.storage

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.annotation.Keep

@Keep
class BroadcastReceiverImpl(private val callback: Callback) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        callback.onReceive(context, intent)
    }

    interface Callback {
        fun onReceive(context: Context, intent: Intent)
    }
}