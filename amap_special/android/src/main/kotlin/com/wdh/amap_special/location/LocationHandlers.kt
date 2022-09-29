package com.wdh.amap_special.location

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Color
import android.os.Build
import androidx.core.content.ContextCompat.getSystemService
import com.amap.api.location.AMapLocationClient
import com.wdh.amap_special.AMapBasePlugin
import com.wdh.amap_special.AMapBasePlugin.Companion.registrar
import com.wdh.amap_special.LocationMethodHandler
import com.wdh.amap_special.R
import com.wdh.amap_special.common.log
import com.wdh.amap_special.common.parseFieldJson
import com.wdh.amap_special.common.toFieldJson
import com.wdh.amap_special.location.Init.locationClient
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


object Init : LocationMethodHandler {
    @SuppressLint("StaticFieldLeak")
    lateinit var locationClient: AMapLocationClient

    private var locationEventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        locationEventChannel = EventChannel(registrar.messenger(), "foton/location_event")
        locationEventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                eventSink = sink
            }

            override fun onCancel(p0: Any?) {

            }
        })

        locationClient = AMapLocationClient(registrar.activity().applicationContext).apply {
            setLocationListener {
                eventSink?.success(UnifiedAMapLocation(it).toFieldJson())

            }
        }

        result.success("初始化成功")
    }
}

object StartLocate : LocationMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val optionJson = call.argument<String>("options") ?: "{}"

        log("startLocate android端: options.toJsonString() -> $optionJson")
        locationClient.enableBackgroundLocation(2001, buildNotification());
        locationClient.setLocationOption(
            optionJson.parseFieldJson<UnifiedLocationClientOptions>().toLocationClientOptions()
        )
        locationClient.startLocation()
        //启动后台定位，第一个参数为通知栏ID，建议整个APP使用一个
        result.success("开始定位")
    }
}

private const val NOTIFICATION_CHANNEL_NAME = "BackgroundLocation"
private var notificationManager: NotificationManager? = null
var isCreateChannel = false
@SuppressLint("NewApi")
private fun buildNotification(): Notification? {
    var builder: Notification.Builder? = null
    var notification: Notification? = null
    if (Build.VERSION.SDK_INT >= 26) {
        //Android O上对Notification进行了修改，如果设置的targetSDKVersion>=26建议使用此种方式创建通知栏
        if (null == notificationManager) {
            notificationManager =
                AMapBasePlugin.registrar.activity().getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?
        }
        val channelId: String = AMapBasePlugin.registrar.activity().getPackageName()
        if (!isCreateChannel) {
            val notificationChannel = NotificationChannel(
                channelId,
                NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT
            )
            notificationChannel.enableLights(true) //是否在桌面icon右上角展示小圆点
            notificationChannel.lightColor = Color.BLUE //小圆点颜色
            notificationChannel.setShowBadge(true) //是否在久按桌面图标时显示此渠道的通知
            notificationManager!!.createNotificationChannel(notificationChannel)
            isCreateChannel = true
        }
        builder = Notification.Builder(AMapBasePlugin.registrar.activity(), channelId)
    } else {
        builder = Notification.Builder(AMapBasePlugin.registrar.activity())
    }
    builder.setSmallIcon(R.mipmap.ic_launcher)
        .setContentTitle("福戴服务商")
        .setContentText("正在后台运行")
        .setWhen(System.currentTimeMillis())
    notification = if (Build.VERSION.SDK_INT >= 16) {
        builder.build()
    } else {
        return builder.notification
    }
    return notification
}

object StopLocate : LocationMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        locationClient.disableBackgroundLocation(true);
        locationClient.stopLocation()
        log("停止定位")
        result.success("停止定位")
    }
}