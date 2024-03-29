package com.wdh.amap_special

import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.core.app.ActivityCompat
import com.amap.api.location.AMapLocationClient
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.wdh.amap_special.LOCATION_METHOD_HANDLER
import com.wdh.amap_special.MAP_METHOD_HANDLER
import com.wdh.amap_special.NAVI_METHOD_HANDLER
import com.wdh.amap_special.SEARCH_METHOD_HANDLER
import com.wdh.amap_special.map.AMapFactory
import java.util.concurrent.atomic.AtomicInteger

const val CREATED = 1
const val RESUMED = 3
const val STOPPED = 5
const val DESTROYED = 6

class AMapBasePlugin {
    companion object : Application.ActivityLifecycleCallbacks {

        lateinit var registrar: Registrar
        private var registrarActivityHashCode: Int = 0
        val activityState = AtomicInteger(0)

        // 权限请求的相关变量
        private var permissionRequestCode = 0
        private var methodResult: MethodChannel.Result? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            // 由于registrar用到的地方比较多, 这里直接放到全局变量里去好了
            Companion.registrar = registrar
            registrarActivityHashCode = registrar.activity().hashCode()

            // 注册生命周期回调, 保证地图初始化的时候对应的是正确的activity状态
            registrar.activity().application.registerActivityLifecycleCallbacks(this)
         
            // 设置权限 channel
            MethodChannel(registrar.messenger(), "foton/permission")
                    .setMethodCallHandler { methodCall, result ->
                        when (methodCall.method) {
                            "requestPermission" -> {
                                permissionRequestCode = methodCall.hashCode()
                                methodResult = result

                                ActivityCompat.requestPermissions(
                                        registrar.activity(),
                                        arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                                                Manifest.permission.ACCESS_FINE_LOCATION,
                                                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                                                Manifest.permission.READ_EXTERNAL_STORAGE,
                                                    Manifest.permission.READ_PHONE_STATE),
                                        permissionRequestCode
                                )
                                registrar.addRequestPermissionsResultListener { code, _, grantResults ->
                                    if (code == permissionRequestCode) {
                                        methodResult?.success(grantResults.all { it == PackageManager.PERMISSION_GRANTED })
                                    }
                                    return@addRequestPermissionsResultListener true
                                }
                            }
                            else -> result.notImplemented()
                        }
                    }

            // 设置key channel
            MethodChannel(registrar.messenger(), "foton/amap_base")
                    .setMethodCallHandler { methodCall, result ->
                        when (methodCall.method) {
                            "setKey" -> result.success("android端需要在Manifest里配置key")
                            else -> result.notImplemented()
                        }
                    }

            // 地图计算工具相关method channel
            MethodChannel(registrar.messenger(), "foton/tool")
                    .setMethodCallHandler { call, result ->
                        MAP_METHOD_HANDLER[call.method]
                                ?.onMethodCall(call, result) ?: result.notImplemented()
                    }
//            MethodChannel(registrar.messenger(), "foton/map")
//                    .setMethodCallHandler { call, result ->
//                        MAP_METHOD_HANDLER[call.method]
//                                ?.onMethodCall(call, result) ?: result.notImplemented()
//                    }

            // 离线地图 channel
            MethodChannel(registrar.messenger(), "foton/offline")
                    .setMethodCallHandler { call, result ->
                        MAP_METHOD_HANDLER[call.method]
                                ?.onMethodCall(call, result) ?: result.notImplemented()
                    }

            // 搜索 channel
            MethodChannel(registrar.messenger(), "foton/search")
                    .setMethodCallHandler { call, result ->
                        SEARCH_METHOD_HANDLER[call.method]
                                ?.onMethodCall(call, result) ?: result.notImplemented()
                    }

            // 导航 channel
            MethodChannel(registrar.messenger(), "foton/navi")
                    .setMethodCallHandler { call, result ->
                        NAVI_METHOD_HANDLER[call.method]
                                ?.onMethodCall(call, result) ?: result.notImplemented()
                    }

            // 定位 channel
            MethodChannel(registrar.messenger(), "foton/location")
                    .setMethodCallHandler { call, result ->
                        LOCATION_METHOD_HANDLER[call.method]
                                ?.onMethodCall(call, result) ?: result.notImplemented()
                    }
            AMapLocationClient.updatePrivacyShow(registrar.activity(),true,true)
            AMapLocationClient.updatePrivacyAgree(registrar.activity(),true)
            // MapView
            registrar
                    .platformViewRegistry()
                    .registerViewFactory("foton/AMapView", AMapFactory(activityState))
        }

        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
            if (activity.hashCode() != registrarActivityHashCode) {
                return
            }
            activityState.set(CREATED)
        }

        override fun onActivityStarted(activity: Activity) {
            if (activity.hashCode() != registrarActivityHashCode) {
                return
            }
        }

        override fun onActivityResumed(activity: Activity) {
            if (activity.hashCode() != registrarActivityHashCode) {
                return
            }
            activityState.set(RESUMED)
        }

        override fun onActivityPaused(activity: Activity) {
            if (activity.hashCode() != registrarActivityHashCode) {
                return
            }
        }

        override fun onActivityStopped(activity: Activity) {
            if (activity.hashCode() != registrarActivityHashCode) {
                return
            }
            activityState.set(STOPPED)
        }

        override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}

        override fun onActivityDestroyed(activity: Activity) {
            if (activity.hashCode() != registrarActivityHashCode) {
                return
            }
            activityState.set(DESTROYED)
        }
    }
}
