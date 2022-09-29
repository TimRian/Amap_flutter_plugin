package com.wdh.amap_special.map

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.graphics.Point
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import com.amap.api.maps.AMap
import com.amap.api.maps.AMapOptions
import com.amap.api.maps.Projection
import com.amap.api.maps.TextureMapView
import com.amap.api.maps.model.CameraPosition
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.utils.overlay.SmoothMoveMarker
import com.wdh.amap_special.*
import com.wdh.amap_special.AMapBasePlugin.Companion.registrar
import com.wdh.amap_special.common.parseFieldJson
import com.wdh.amap_special.common.toFieldJson
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.concurrent.atomic.AtomicInteger


const val mapChannelName = "foton/map"
const val markerClickedChannelName = "foton/marker_clicked"
const val regionDidChangeChannelName = "foton/regionDidChange"
const val regionWillChangeChannelName = "foton/regionWillChange"
const val mapDidZoomByUserName = "foton/mapDidZoomByUser"
const val mapDidMoveByUserName = "foton/mapDidMoveByUser"
const val playFinish = "foton/playFinish"
const val success = "调用成功"
var mId  = -1 ;
var mapPlayFinshUserSink: EventChannel.EventSink? = null
var eventSink: EventChannel.EventSink? = null


class AMapFactory(val activityState: AtomicInteger)
    : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    
    override fun create(context: Context, id: Int, params: Any?): PlatformView {
        mId = id ;
        val view = AMapView(
                context,
                id,
                activityState,
                (params as String).parseFieldJson<UnifiedAMapOptions>().toAMapOption()
        )
        view.setup()
        return view
    }
}

@SuppressLint("CheckResult")
class AMapView(context: Context,
               private val id: Int,
               private val activityState: AtomicInteger,
               amapOptions: AMapOptions) : PlatformView, Application.ActivityLifecycleCallbacks ,AMap.OnCameraChangeListener, AMap.OnMapTouchListener{

    private val mapView = TextureMapView(context, amapOptions)
    private var disposed = false
    private val registrarActivityHashCode: Int = AMapBasePlugin.registrar.activity().hashCode()
    // 地图拖拽事件channel


    override fun getView(): View = mapView

    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        mapView.onDestroy()

        registrar.activity().application.unregisterActivityLifecycleCallbacks(this)
    }

    fun setup() {
        when (activityState.get()) {
            STOPPED -> {
                mapView.onCreate(null)
                mapView.onResume()
                mapView.onPause()
            }
            RESUMED -> {
                mapView.onCreate(null)
                mapView.onResume()
            }
            CREATED -> mapView.onCreate(null)
            DESTROYED -> {
            }
            else -> throw IllegalArgumentException("Cannot interpret " + activityState.get() + " as an activity activityState")
        }

        // 地图相关method channel
        val mapChannel = MethodChannel(registrar.messenger(), "$mapChannelName$id")
        mapChannel.setMethodCallHandler { call, result ->
            MAP_METHOD_HANDLER[call.method]
                    ?.with(mapView.map)
                    ?.onMethodCall(call, result) ?: result.notImplemented()
        }

        // marker click event channel
        val markerClickedEventChannel = EventChannel(registrar.messenger(), "$markerClickedChannelName$id")
        Logger.e("markerClickedChannelName ---------markerClickedChannelName" + "$markerClickedChannelName$mId")
        markerClickedEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p: Any?, sink: EventChannel.EventSink?) {
                eventSink = sink
            }

            override fun onCancel(p: Any?) {}
        })
        mapView.map.setOnMarkerClickListener {
            it.showInfoWindow()
            eventSink?.success(UnifiedMarkerOptions(it.options).toFieldJson())
            true
        }


        val mapDragEventChannel = EventChannel(registrar.messenger(), "$regionDidChangeChannelName$id")
        mapDragEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p: Any?, sink: EventChannel.EventSink?) {
                mapDragEventSink = sink
            }

            override fun onCancel(p: Any?) {}
        })
        var mapDragStartEventSink: EventChannel.EventSink? = null
        val mapDragStartEventChannel = EventChannel(registrar.messenger(), "$regionWillChangeChannelName$id")
        mapDragStartEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p: Any?, sink: EventChannel.EventSink?) {
                mapDragStartEventSink = sink
            }

            override fun onCancel(p: Any?) {}
        })

        val mapDidZoomByUserEventChannel = EventChannel(registrar.messenger(), "$mapDidZoomByUserName$id")
        mapDidZoomByUserEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p: Any?, sink: EventChannel.EventSink?) {
                mapDidZoomByUserSink = sink
            }

            override fun onCancel(p: Any?) {}
        })

        val mapDidMoveByUserEventChannel = EventChannel(registrar.messenger(), "$mapDidMoveByUserName$id")
        mapDidMoveByUserEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p: Any?, sink: EventChannel.EventSink?) {
                mapDidMoveByUserSink = sink
            }

            override fun onCancel(p: Any?) {}
        })

        val mapDidPlayFinishByUserEventChannel = EventChannel(registrar.messenger(), "$playFinish$id")
        mapDidPlayFinishByUserEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p: Any?, sink: EventChannel.EventSink?) {
                mapPlayFinshUserSink = sink
            }
            override fun onCancel(p: Any?) {}
        })
        mapView.map.setOnCameraChangeListener(this)
        mapView.map.setOnMapTouchListener(this)
        Logger.e("AMapView ---------" + "setOnCameraChangeListener")
        // 注册生命周期
        registrar.activity().application.registerActivityLifecycleCallbacks(this)
    }

    var mapDragEventSink: EventChannel.EventSink? = null
    var mapDidZoomByUserSink: EventChannel.EventSink? = null
    var mapDidMoveByUserSink: EventChannel.EventSink? = null
    var oldx: Double ? = 0.0;
    var oldy: Double? = 0.0;
    var zoomL: Double?  = 0.0;

    override fun onCameraChangeFinish(p0: CameraPosition?) {
        val mg = mapDragEventSink;
        if (mg!=null){
            val left: Int = mapView.getLeft()
            val top: Int = mapView.getTop()
            val right: Int = mapView.getRight()
            val bottom: Int = mapView.getBottom()
            // 获得屏幕点击的位置
            val x = (mapView.getX() + (right - left) / 2).toInt()
            val y = (mapView.getY() + (bottom - top) / 2).toInt()
            val projection: Projection = mapView.map.getProjection()
            val pt: LatLng = projection.fromScreenLocation(Point(x, y))
            mg.success(pt.toFieldJson())
        }
            
        Logger.e("AMapView ---------" + "onCameraChangeFinish")

        if (oldx == 0.0){
            zoomL = mapView.map.cameraPosition.zoom.toDouble();
            oldx = mapView.map.cameraPosition.target.latitude;
            oldy = mapView.map.cameraPosition.target.longitude;
        }
    }


    override fun onTouch(p0: MotionEvent?) {

        val zoom = mapDidZoomByUserSink;
        val move = mapDidMoveByUserSink;

        if (MotionEvent.ACTION_UP==p0?.action){
            //新的
            var newx = mapView.map.cameraPosition.target.latitude;
            var newy = mapView.map.cameraPosition.target.longitude;
            var newzoomL = mapView.map.cameraPosition.zoom;

            if (oldx != newx || oldy != oldy){
                val pt: LatLng = mapView.map.cameraPosition.target;
                if (zoomL != newzoomL.toDouble()){
                    if (zoom!=null){
                        zoom?.success(pt.toFieldJson())
                    }
                }else{
                    if (move!=null){
                        move?.success(pt.toFieldJson())
                    }
                }
            }
            //记录值
            oldx = newx;
            oldy = newy;
            zoomL = newzoomL.toDouble();
        }

        Logger.e("====++++++++" + p0.toString())

    }

    override fun onCameraChange(p0: CameraPosition?) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onCreate(savedInstanceState)
    }

    override fun onActivityStarted(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivityResumed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onResume()
    }

    override fun onActivityPaused(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onPause()
    }

    override fun onActivityStopped(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onSaveInstanceState(outState)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onDestroy()
    }

}

//class OnCameraChangeListenerImpl(private val mapDragEventChannel: EventChannel.EventSink) : AMap.OnCameraChangeListener{
//
//
//    override fun onCameraChangeFinish(p: CameraPosition?) {
//        mapDragEventChannel?.success()
//    }
//
//    override fun onCameraChange(p: CameraPosition?) {
//        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
//    }
//}


