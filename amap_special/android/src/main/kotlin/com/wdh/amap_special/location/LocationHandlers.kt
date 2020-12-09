package com.wdh.amap_special.location

import android.annotation.SuppressLint
import com.amap.api.location.AMapLocationClient
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.wdh.amap_special.AMapBasePlugin.Companion.registrar
import com.wdh.amap_special.LocationMethodHandler
import com.wdh.amap_special.common.log
import com.wdh.amap_special.common.parseFieldJson
import com.wdh.amap_special.common.toFieldJson
import com.wdh.amap_special.location.Init.locationClient

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

        locationClient.setLocationOption(optionJson.parseFieldJson<UnifiedLocationClientOptions>().toLocationClientOptions())
        locationClient.startLocation()
        result.success("开始定位")
    }
}

object StopLocate : LocationMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        locationClient.stopLocation()
        log("停止定位")
        result.success("停止定位")
    }
}