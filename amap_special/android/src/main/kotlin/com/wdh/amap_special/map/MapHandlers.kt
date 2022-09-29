package com.wdh.amap_special.map

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import com.amap.api.maps.*
import com.amap.api.maps.model.*
import com.amap.api.maps.offlinemap.OfflineMapActivity
import com.amap.api.maps.utils.overlay.SmoothMoveMarker
import com.amap.api.trace.LBSTraceClient
import com.amap.api.trace.TraceListener
import com.amap.api.trace.TraceLocation
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonParser
import com.wdh.amap_special.AMapBasePlugin
import com.wdh.amap_special.AMapBasePlugin.Companion.registrar
import com.wdh.amap_special.MapMethodHandler
import com.wdh.amap_special.common.log
import com.wdh.amap_special.common.parseFieldJson
import com.wdh.amap_special.common.toFieldJson
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.*
import java.util.*

val beijingLatLng = LatLng(39.941711, 116.382248)
var isAnimated = false
object SetCustomMapStyleID : MapMethodHandler {
    private lateinit var map: AMap

    override fun with(map: AMap): MapMethodHandler {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val styleId = call.argument("styleId") ?: ""

        log("方法map#setCustomMapStyleID android端参数: styleId -> $styleId")

        map.setCustomMapStyleID(styleId)

        result.success(success)
    }
}

object SetCustomMapStyleOptions : MapMethodHandler {
    private lateinit var map: AMap

    override fun with(map: AMap): MapMethodHandler {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        val styleId = call.argument("styleId") ?: ""
        val stylePath = call.argument("stylePath") ?: ""
        val extraStylePath = call.argument("extraStylePath") ?: ""

        log("方法map#SetCustomMapStyleOptions android端参数: styleId -> $styleId stylePath-> $stylePath extraStylePath-> $extraStylePath")

        val path = UnifiedAssets.getDefaultPath(stylePath)
        val pathExtra = UnifiedAssets.getDefaultPath(extraStylePath)

        log("方法map#SetCustomMapStyleOptions android端参数: path -> $path pathExtra-> $pathExtra")


        var buffer1: ByteArray? = null
        var buffer2: ByteArray? = null
        var is1: InputStream? = null
        var is2: InputStream? = null
        try {
            is1 = AMapBasePlugin.registrar.activity().getAssets().open(path)
            val lenght1 = is1.available()
            buffer1 = ByteArray(lenght1)
            is1.read(buffer1)
            is2 = AMapBasePlugin.registrar.activity().getAssets().open(pathExtra)
            val lenght2 = is2.available()
            buffer2 = ByteArray(lenght2)
            is2.read(buffer2)
        } catch (e: IOException) {
            e.printStackTrace()
        } finally {
            try {
                is1?.close()
                is2?.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }

        map.setCustomMapStyle(CustomMapStyleOptions()
            .setEnable(true)
            .setStyleId(styleId)
            .setStyleData(buffer1)
            .setStyleExtraData(buffer2)
        );

        result.success(success)
    }
}

object SetCustomMapStylePath : MapMethodHandler {

    private lateinit var map: AMap

    override fun with(map: AMap): SetCustomMapStylePath {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val path = call.argument("path") ?: ""

        log("方法map#setCustomMapStylePath android端参数: path -> $path")

        var outputStream: FileOutputStream? = null
        var inputStream: InputStream? = null
        val filePath: String?
        try {
            inputStream = registrar.context().assets.open(registrar.lookupKeyForAsset(path))
            val b = ByteArray(inputStream!!.available())
            inputStream.read(b)

            filePath = registrar.context().filesDir.absolutePath
            val file = File("$filePath/$path")
            if (file.exists()) {
                file.delete()
            }

            if (!file.parentFile.exists()) {
                file.parentFile.mkdirs()
            }
            file.createNewFile()
            outputStream = FileOutputStream(file)
            outputStream.write(b)
        } catch (e: IOException) {
            result.error(e.message, e.localizedMessage, e.printStackTrace())
            return
        } finally {
            inputStream?.close()
            outputStream?.close()
        }

        map.setCustomMapStylePath("$filePath/$path")

        result.success(success)
    }
}

object SetMapCustomEnable : MapMethodHandler {

    private lateinit var map: AMap

    override fun with(map: AMap): SetMapCustomEnable {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val enabled = call.argument("enabled") ?: false

        log("方法map#setMapCustomEnable android端参数: enabled -> $enabled")

        map.setMapCustomEnable(enabled)

        result.success(success)
    }
}

object ConvertCoordinate : MapMethodHandler {

    lateinit var map: AMap

    private val types = arrayListOf(
        CoordinateConverter.CoordType.GPS,
        CoordinateConverter.CoordType.BAIDU,
        CoordinateConverter.CoordType.MAPBAR,
        CoordinateConverter.CoordType.MAPABC,
        CoordinateConverter.CoordType.SOSOMAP,
        CoordinateConverter.CoordType.ALIYUN,
        CoordinateConverter.CoordType.GOOGLE
    )

    override fun with(map: AMap): ConvertCoordinate {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val lat = call.argument<Double>("lat")!!
        val lon = call.argument<Double>("lon")!!
        val typeIndex = call.argument<Int>("type")!!
        val amapCoordinate = CoordinateConverter(AMapBasePlugin.registrar.context())
            .from(types[typeIndex])
            .coord(LatLng(lat, lon, false))
            .convert()

        result.success(amapCoordinate.toFieldJson())
    }
}

object CalcDistance : MapMethodHandler {
    lateinit var map: AMap

    override fun with(map: AMap): CalcDistance {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val p1 = call.argument<Map<String, Any>>("p1")
        val p2 = call.argument<Map<String, Any>>("p2")
        val latlng1 = p1!!.getLntlng()
        val latlng2 = p2!!.getLntlng()
        val dis = AMapUtils.calculateLineDistance(latlng1, latlng2)
        result.success(dis)
    }

    private fun Map<String, Any>.getLntlng(): LatLng {
        val lat = get("latitude") as Double
        val lng = get("longitude") as Double
        return LatLng(lat, lng)
    }
}

object ClearMap : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): ClearMap {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        map.clear(true)

        result.success(success)
    }
}

object OpenOfflineManager : MapMethodHandler {

    override fun with(map: AMap): MapMethodHandler {
        return this
    }

    override fun onMethodCall(p0: MethodCall, p1: MethodChannel.Result) {
        AMapBasePlugin.registrar.activity().startActivity(
            Intent(AMapBasePlugin.registrar.activity(),
                OfflineMapActivity::class.java)
        )
    }
}

object SetLanguage : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetLanguage {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val language = call.argument<String>("language") ?: "0"

        log("方法map#setLanguage android端参数: language -> $language")

        map.setMapLanguage(language)

        result.success(success)
    }
}

object SetMapType : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetMapType {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val mapType = call.argument<Int>("mapType") ?: 1

        log("方法map#setMapType android端参数: mapType -> $mapType")

        map.mapType = mapType

        result.success(success)
    }
}

object SetMyLocationStyle : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetMyLocationStyle {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val styleJson = call.argument<String>("myLocationStyle") ?: "{}"

        log("方法setMyLocationEnabled android端参数: styleJson -> $styleJson")

        styleJson.parseFieldJson<UnifiedMyLocationStyle>().applyTo(map)

        result.success(success)
    }
}

object SetUiSettings : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetUiSettings {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val uiSettingsJson = call.argument<String>("uiSettings") ?: "{}"

        log("方法setUiSettings android端参数: uiSettingsJson -> $uiSettingsJson")

        uiSettingsJson.parseFieldJson<UnifiedUiSettings>().applyTo(map)

        result.success(success)
    }
}

object ShowIndoorMap : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): ShowIndoorMap {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val enabled = call.argument<Boolean>("showIndoorMap") ?: false

        log("方法map#showIndoorMap android端参数: enabled -> $enabled")

        map.showIndoorMap(enabled)

        result.success(success)
    }
}

object AddMarker : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): AddMarker {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val optionsJson = call.argument<String>("markerOptions") ?: "{}"
        isAnimated = call.argument("isAnimated") ?: false
        log("方法marker#addMarker android端参数: optionsJson -> $optionsJson")

        optionsJson.parseFieldJson<UnifiedMarkerOptions>().applyTo(map)

        result.success(success)
    }
}

object AddMarkers : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): AddMarkers {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val moveToCenter = call.argument<Boolean>("moveToCenter") ?: true
        val optionsListJson = call.argument<String>("markerOptionsList") ?: "[]"
        val clear = call.argument<Boolean>("clear") ?: false

        log("方法marker#addMarkers android端参数: optionsListJson -> $optionsListJson")

        val optionsList = ArrayList(optionsListJson.parseFieldJson<List<UnifiedMarkerOptions>>().map { it.toMarkerOption() })
        if (clear) map.mapScreenMarkers.forEach { it.remove() }
        val markerList = map.addMarkers(optionsList, moveToCenter)
//        if (markerList!=null){
//            for (item in markerList){
//                item.showInfoWindow()
//            }
//        }
        result.success(success)
    }
}
private var moveMarker: SmoothMoveMarker ?= null
object addMoveAnimation : MapMethodHandler, SmoothMoveMarker.MoveListener {

    lateinit var map: AMap
    override fun with(map: AMap): addMoveAnimation {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val coordinatesListJson = call.argument<String>("coordinatesList") ?: ""
        val duration: Double = call.argument<Double>("duration") ?: 0.0
        val actions = call.argument<Int>("actions") ?: 1
        val icon : String = call.argument<String>("icon")?: ""
        /*      if (icon.equals("") || icon == null) {
                  return
              }
              map!!.clear();*/
        log("方法addMoveAnimation#onMethodCall android端参数: coordinatesListJson -> $coordinatesListJson")
        log("方 法addMoveAnimation#onMethodCall android端参数: duration -> $duration")
        log("方 法addMoveAnimation#onMethodCall android端参数: actions -> $actions")
        log("方 法addMoveAnimation#onMethodCall android端参数: icon -> $icon")

        //Json的解析类对象
        val parser = JsonParser()
        //将JSON的String 转成一个JsonArray对象
        val jsonArray: JsonArray = parser.parse(coordinatesListJson).getAsJsonArray()
        val gson = Gson()
        val latlngList: ArrayList<LatLng> = ArrayList()
        for (user in jsonArray) {
            //使用GSON，直接转成Bean对象
            val lat: LatLng = gson.fromJson(user, LatLng::class.java)
            latlngList.add(lat)
        }

        map.animateCamera(CameraUpdateFactory.newLatLngBounds(
            LatLngBounds.builder().run {
                coordinatesListJson.parseFieldJson<List<LatLng>>().forEach {
                    include(it)
                }
                build()
            },
            100
        ))
        if (moveMarker != null && actions ==1) {
            moveMarker?.removeMarker();
            moveMarker?.destroy();
            moveMarker = null;
        }
        if (moveMarker == null) {
            moveMarker= SmoothMoveMarker(map)
        }
        // 设置滑动的图标
        moveMarker?.setDescriptor(UnifiedAssets.getBitmapDescriptor(icon))
        moveMarker?.setPoints(latlngList) //设置平滑移动的轨迹list
        moveMarker?.setTotalDuration(duration.toInt())
        if (actions ==1) {
            moveMarker?.startSmoothMove();
        }else{
            moveMarker?.stopMove();
        }
//        AMapFactory.fail="";


        moveMarker?.setMoveListener(this);
        result.success(success)
    }

    override fun move(distance: Double) {
        if (distance == 0.0) {
            moveMarker?.removeMarker();
            moveMarker?.stopMove();
            moveMarker?.destroy();
            moveMarker = null;
            AMapBasePlugin.registrar.activity().runOnUiThread(){
                mapPlayFinshUserSink?.success("回放结束")
            }
        }
    }
}


object lBSTraceClient : MapMethodHandler, TraceListener {

    lateinit var map: AMap
    lateinit var latlngList: List<CustomLatlng>
    lateinit var mResult : MethodChannel.Result
    override fun with(map: AMap): lBSTraceClient{
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        mResult = result
//        val origin : List<String> = call.argument<List<String>>("origin")?:
        val optionsListJson = call.argument<String>("origin") ?: "[]"
/*        //Json的解析类对象
        val parser = JsonParser()
        //将JSON的String 转成一个JsonArray对象
        val jsonArray: JsonArray = parser.parse(origin).getAsJsonAr       ray()*/
        log("方法lBSTraceClient#onMethodCall android端参数: optionsListJson -> ${optionsListJson.toString()}")
        latlngList = optionsListJson.parseFieldJson<List<CustomLatlng>>();
        log("方法lBSTraceClient#onMethodCall android端参数: latlngList -> ${latlngList.toString()}")


//        val latlngList: ArrayList<LatLng> = ArrayList()
//        val gson = Gson()
//        optionsList.forEach{
//            val lat: LatLng = gson.fromJson(it, LatLng::class.java)
//            latlngList.add(lat)
//        }

        /*  val latlngList: ArrayList<LatLng> = ArrayList()
          for (user in jsonArray) {
              //使用GSON，直接转成Bean对象
              val lat: LatLng = gson.fromJson(user, LatLng::class.java)
              latlngList.add(lat)
          }*/
        val mTraceClient = LBSTraceClient(registrar.activity().applicationContext)
        val traceList: ArrayList<TraceLocation> = ArrayList()

        for (user in latlngList) {
            var traceLocation = TraceLocation();
//            traceLocation.latitude = user.longitude
//            traceLocation.longitude = user.latitude 
            traceLocation.latitude = user.latitude
            traceLocation.longitude = user.longitude
            traceLocation.speed = user.speed.toFloat()
            traceLocation.bearing = user.angle.toFloat()

//            traceLocation.time = time
            traceList.add(traceLocation)
        }
        mTraceClient.queryProcessedTrace(1,traceList,LBSTraceClient.TYPE_AMAP, this)

        log("方法lBSTraceClient#onMethodCall android端参数: origin -> ${traceList.toString()}")
    }

    override fun onRequestFailed(p0: Int, p1: String?) {
        log("onRequestFailed")

        val latlngListString: ArrayList<String> = ArrayList()
        latlngList?.forEach {
            var st = it.toFieldJson();
            latlngListString.add(st)
        }
        mResult.success(latlngListString)

    }

    override fun onTraceProcessing(p0: Int, p1: Int, p2: MutableList<LatLng>?) {
        log("onTraceProcessing")
    }

    override fun onFinished(p0: Int, list: MutableList<LatLng>?, p2: Int, p3: Int) {
        log("onFinished")
        val latlngList: ArrayList<LatLng> = ArrayList()
        list?.forEach {
            latlngList .add(LatLng(it.latitude,it.longitude))
        }
        val latlngListString: ArrayList<String> = ArrayList()
        latlngList?.forEach {
            var st = it.toFieldJson();
            latlngListString.add(st)
        }
        mResult.success(latlngListString)
    }
}



/*object dectory : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): dectory {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        map.clear()
        map.addCircle(options)

        result.success(success)
    }
}*/
object AddCircle : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): AddCircle {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val optionStr = call.argument<String>("options") ?: "{}"
        val obj = JSONObject(optionStr)
        val options = CircleOptions()
        options.strokeWidth(obj.getString("width").toFloat())
        options.fillColor(Color.argb(10, 0, 0, 180))
        options.strokeColor(Color.argb(180, 3, 145, 255))
//        if (obj.getString("fillColor")!=null){
//            options.fillColor(Color.parseColor(obj.getString("fillColor")))
//        }
//        if (obj.getString("strokeColor")!=null){
//            options.strokeColor(Color.parseColor(obj.getString("strokeColor")))
//        }
        options.center(LatLng(obj.getJSONObject("position").getDouble("latitude"), obj.getJSONObject("position").getDouble("longitude")))
        options.radius(obj.getDouble("radius"))

        map.clear(true)
        map.addCircle(options)

        result.success(success)
    }
}

object AddPolyline : MapMethodHandler {
    lateinit var map: AMap

    override fun with(map: AMap): MapMethodHandler {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val options = call.argument<String>("options")?.parseFieldJson<UnifiedPolylineOptions>()

        log("map#AddPolyline android端参数: options -> $options")

        options?.applyTo(map)

        result.success(success)
    }
}

object ClearMarker : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): ClearMarker {
        this.map = map
        return this
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        map.mapScreenMarkers.forEach { it.remove() }

        result.success(success)
    }
}

object ChangeLatLng : MapMethodHandler {

    lateinit var map: AMap
    override fun with(map: AMap): ChangeLatLng {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val targetJson = methodCall.argument<String>("target") ?: "{}"

        map.animateCamera(CameraUpdateFactory.changeLatLng(targetJson.parseFieldJson<LatLng>()))

        methodResult.success(success)
    }
}

object GetCenterLnglat : MapMethodHandler {
    lateinit var map: AMap
    override fun with(map: AMap): MapMethodHandler {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val target = map.cameraPosition.target
        methodResult.success(target.toFieldJson())
    }
}

object SetMapStatusLimits : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetMapStatusLimits {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val swLatLng: LatLng? = methodCall.argument<String>("swLatLng")?.parseFieldJson()
        val neLatLng: LatLng? = methodCall.argument<String>("neLatLng")?.parseFieldJson()

        map.setMapStatusLimits(LatLngBounds(swLatLng, neLatLng))

        methodResult.success(success)
    }
}

object getVisibleRegion : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): getVisibleRegion {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result){
        val projection: Projection = map.getProjection()
        val visibleRegion: VisibleRegion = projection.getVisibleRegion() //可视区域四个角的坐标

        methodResult.success(visibleRegion.toFieldJson())

    }
}

object SetMapCenter : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetMapCenter {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val target: LatLng = methodCall.argument<String>("target")?.parseFieldJson()
            ?: beijingLatLng
        val zoom: Double = methodCall.argument<Double>("zoom") ?: 10.0
        val tilt: Double = methodCall.argument<Double>("tilt") ?: 0.0
        val bearing: Double = methodCall.argument<Double>("bearing") ?: 0.0

        map.moveCamera(CameraUpdateFactory.newCameraPosition(CameraPosition(target, zoom.toFloat(), tilt.toFloat(), bearing.toFloat())))

        methodResult.success(success)
    }
}

object SetZoomLevel : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): SetZoomLevel {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val zoomLevel = methodCall.argument<Int>("zoomLevel") ?: 15

        map.moveCamera(CameraUpdateFactory.zoomTo(zoomLevel.toFloat()))

        methodResult.success(success)
    }
}

object ZoomToSpan : MapMethodHandler {

    lateinit var map: AMap

    override fun with(map: AMap): ZoomToSpan {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val boundJson = methodCall.argument<String>("bound") ?: "[]"
        val padding = methodCall.argument<Int>("padding") ?: 80

        map.moveCamera(CameraUpdateFactory.newLatLngBounds(
            LatLngBounds.builder().run {
                boundJson.parseFieldJson<List<LatLng>>().forEach {
                    include(it)
                }
                build()
            },
            padding
        ))

        methodResult.success(success)
    }
}

object ScreenShot : MapMethodHandler {
    lateinit var map: AMap
    override fun with(map: AMap): MapMethodHandler {
        this.map = map
        return this
    }

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        map.getMapScreenShot(object : AMap.OnMapScreenShotListener {
            override fun onMapScreenShot(bitmap: Bitmap?) {
            }

            override fun onMapScreenShot(bitmap: Bitmap?, status: Int) {
                if (bitmap == null) {
                    methodResult.error("截图失败", null, null)
                    return
                }
                if (status != 0) {
                    val outputStream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
                    methodResult.success(outputStream.toByteArray())
                } else {
                    methodResult.error("截图失败,渲染未完成", "截图失败,渲染未完成", null)
                }
            }
        })
    }
}
