package com.wdh.amap_special.navi.handler

import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Poi
import com.amap.api.navi.AmapNaviPage
import com.amap.api.navi.AmapNaviParams
import com.amap.api.navi.AmapNaviType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.wdh.amap_special.AMapBasePlugin
import com.wdh.amap_special.NaviMethodHandler
import com.wdh.amap_special.map.success

object StartNavi: NaviMethodHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val lat = call.argument<Double>("lat")!!
        val lon = call.argument<Double>("lon")!!
        val naviType = call.argument<Int>("naviType") ?: AmapNaviType.DRIVER

        val end = Poi(null, LatLng(lat, lon), "")
        AmapNaviPage.getInstance().showRouteActivity(
                AMapBasePlugin.registrar.activity(),
                AmapNaviParams(null, null, end, when (naviType) {
                    0 -> AmapNaviType.DRIVER
                    1 -> AmapNaviType.WALK
                    2 -> AmapNaviType.RIDE
                    else -> AmapNaviType.DRIVER
                }),
                null
        )
        result.success(success)
    }
}