package com.wdh.amap_special.search

import com.amap.api.services.busline.BusStationQuery
import com.amap.api.services.busline.BusStationSearch
import com.amap.api.services.core.AMapException
import com.amap.api.services.core.PoiItem
import com.amap.api.services.geocoder.*
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch
import com.amap.api.services.route.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.wdh.amap_special.AMapBasePlugin
import com.wdh.amap_special.AMapBasePlugin.Companion.registrar
import com.wdh.amap_special.SearchMethodHandler
import com.wdh.amap_special.common.*


/**
 * 逆地理编码（坐标转地址）
 */
object SearchReGeocode : SearchMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val point = call.argument<String>("point") ?: "{}"
        val radius = call.argument<Double>("radius") ?: 100.0
        val latLonType = call.argument<Int>("latLonType") ?: 0

        val query = RegeocodeQuery(
                point.parseFieldJson<LatLng>().toLatLonPoint(),
                radius.toFloat(),
                when (latLonType) {
                    0 -> GeocodeSearch.AMAP
                    1 -> GeocodeSearch.GPS
                    else -> GeocodeSearch.AMAP
                }
        )

        GeocodeSearch(AMapBasePlugin.registrar.activity()).run {
            setOnGeocodeSearchListener(object : GeocodeSearch.OnGeocodeSearchListener {
                override fun onRegeocodeSearched(reGeocodeResult: RegeocodeResult?, resultID: Int) {
                    if (reGeocodeResult != null) {
                        result.success(reGeocodeResult.toAccessorJson())
                    } else {
                        result.error("搜索不到结果", "搜索不到结果", "搜索不到结果")
                    }
                }

                override fun onGeocodeSearched(geocodeResult: GeocodeResult?, resultID: Int) {

                }
            })

            getFromLocationAsyn(query)
        }
    }
}

object SearchGeocode : SearchMethodHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val structuredAddress = call.argument<String>("name") ?: ""
        val city = call.argument<String>("city") ?: ""

        GeocodeSearch(AMapBasePlugin.registrar.activity()).run {
            setOnGeocodeSearchListener(object : GeocodeSearch.OnGeocodeSearchListener {
                override fun onRegeocodeSearched(p0: RegeocodeResult?, resultID: Int) {

                }

                override fun onGeocodeSearched(geocodeResult: GeocodeResult?, resultID: Int) {
                    if (geocodeResult != null) {
                        result.success(UnifiedGeocodeResult(geocodeResult).toFieldJson())
                    } else {
                        result.error("搜索不到结果", "搜索不到结果", "搜索不到结果")
                    }
                }
            })

            getFromLocationNameAsyn(GeocodeQuery(structuredAddress, city))
        }

    }
}

object SearchPoiBound : SearchMethodHandler {
    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val query = methodCall.argument<String>("query") ?: "{}"

        log("方法map#searchPoi android端参数: query -> $query")

        query.parseFieldJson<UnifiedPoiSearchQuery>()
                .toPoiSearchBound(AMapBasePlugin.registrar.context())
                .apply {
                    setOnPoiSearchListener(object : PoiSearch.OnPoiSearchListener {
                        override fun onPoiItemSearched(result: PoiItem?, rCode: Int) {}

                        override fun onPoiSearched(result: PoiResult?, rCode: Int) {
                            if (rCode == AMapException.CODE_AMAP_SUCCESS) {
                                if (result != null) {
                                    methodResult.success(UnifiedPoiResult(result).toFieldJson())
                                } else {
                                    methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                                }
                            } else {
                                methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                            }
                        }
                    })
                }.searchPOIAsyn()
    }
}

object SearchPoiId : SearchMethodHandler {

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val id = methodCall.argument<String>("id") ?: ""

        log("方法map#searchPoiId android端参数: id -> $id")

        PoiSearch(AMapBasePlugin.registrar.context(), null).apply {
            setOnPoiSearchListener(object : PoiSearch.OnPoiSearchListener {
                override fun onPoiItemSearched(result: PoiItem?, rCode: Int) {
                    if (rCode == AMapException.CODE_AMAP_SUCCESS) {
                        if (result != null) {
                            methodResult.success(UnifiedPoiItem(result).toFieldJson())
                        } else {
                            methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                        }
                    } else {
                        methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                    }
                }

                override fun onPoiSearched(result: PoiResult?, rCode: Int) {}
            })
        }.searchPOIIdAsyn(id)
    }
}

object SearchPoiKeyword : SearchMethodHandler {

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val query = methodCall.argument<String>("query") ?: "{}"

        log("方法map#searchPoi android端参数: query -> $query")

        query.parseFieldJson<UnifiedPoiSearchQuery>()
                .toPoiSearch(AMapBasePlugin.registrar.context())
                .apply {
                    setOnPoiSearchListener(object : PoiSearch.OnPoiSearchListener {
                        override fun onPoiItemSearched(result: PoiItem?, rCode: Int) {}

                        override fun onPoiSearched(result: PoiResult?, rCode: Int) {
                            if (rCode == AMapException.CODE_AMAP_SUCCESS) {
                                if (result != null) {
                                    methodResult.success(UnifiedPoiResult(result).toFieldJson())
                                } else {
                                    methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                                }
                            } else {
                                methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                            }
                        }
                    })
                }.searchPOIAsyn()
    }
}

object SearchPoiPolygon : SearchMethodHandler {
    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val query = methodCall.argument<String>("query") ?: "{}"

        log("方法map#searchPoi android端参数: query -> $query")

        query.parseFieldJson<UnifiedPoiSearchQuery>()
                .toPoiSearchPolygon(AMapBasePlugin.registrar.context())
                .apply {
                    setOnPoiSearchListener(object : PoiSearch.OnPoiSearchListener {
                        override fun onPoiItemSearched(result: PoiItem?, rCode: Int) {}

                        override fun onPoiSearched(result: PoiResult?, rCode: Int) {
                            if (rCode == AMapException.CODE_AMAP_SUCCESS) {
                                if (result != null) {
                                    methodResult.success(UnifiedPoiResult(result).toFieldJson())
                                } else {
                                    methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                                }
                            } else {
                                methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                            }
                        }
                    })
                }.searchPOIAsyn()
    }
}

object SearchRoutePoiLine : SearchMethodHandler {

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val query = methodCall.argument<String>("query") ?: "{}"

        log("方法map#searchRoutePoiLine android端参数: query -> $query")

        query.parseFieldJson<UnifiedRoutePoiSearchQuery>()
                .toRoutePoiSearchLine(AMapBasePlugin.registrar.context())
                .apply {
                    setPoiSearchListener { result, rCode ->
                        if (rCode == AMapException.CODE_AMAP_SUCCESS) {
                            if (result != null) {
                                methodResult.success(UnifiedRoutePoiSearchResult(result).toFieldJson())
                            } else {
                                methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                            }
                        } else {
                            methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                        }
                    }
                }.searchRoutePOIAsyn()
    }
}

object SearchRoutePoiPolygon : SearchMethodHandler {

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val query = methodCall.argument<String>("query") ?: "{}"

        log("方法map#searchRoutePoiPolygon android端参数: query -> $query")

        query.parseFieldJson<UnifiedRoutePoiSearchQuery>()
                .toRoutePoiSearchPolygon(AMapBasePlugin.registrar.context())
                .apply {
                    setPoiSearchListener { result, rCode ->
                        if (rCode == AMapException.CODE_AMAP_SUCCESS) {
                            if (result != null) {
                                methodResult.success(UnifiedRoutePoiSearchResult(result).toFieldJson())
                            } else {
                                methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                            }
                        } else {
                            methodResult.error(rCode.toString(), rCode.toAMapError(), rCode.toAMapError())
                        }
                    }
                }.searchRoutePOIAsyn()
    }
}

object CalculateDriveRoute : SearchMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // 规划参数
        val param = call.argument<String>("routePlanParam")!!.parseFieldJson<RoutePlanParam>()

        log("方法calculateDriveRoute android端参数: routePlanParam -> $param")

        val routeQuery = RouteSearch.DriveRouteQuery(
                RouteSearch.FromAndTo(param.from.toLatLonPoint(), param.to.toLatLonPoint()),
                param.mode,
                param.passedByPoints?.map { it.toLatLonPoint() },
                param.avoidPolygons?.map { list -> list.map { it.toLatLonPoint() } },
                param.avoidRoad
        )
        RouteSearch(AMapBasePlugin.registrar.context()).run {
            setRouteSearchListener(object : RouteSearch.OnRouteSearchListener {
                override fun onDriveRouteSearched(r: DriveRouteResult?, errorCode: Int) {
                    if (errorCode != AMapException.CODE_AMAP_SUCCESS || r == null) {
                        result.error("路线规划失败, 错误码: $errorCode", null, null)
                    } else if (r.paths.isEmpty()) {
                        result.error("没有规划出合适的路线", null, null)
                    } else {
                        result.success(UnifiedDriveRouteResult(r).toFieldJson())
                    }
                }

                override fun onBusRouteSearched(result: BusRouteResult?, errorCode: Int) {}

                override fun onRideRouteSearched(result: RideRouteResult?, errorCode: Int) {}

                override fun onWalkRouteSearched(result: WalkRouteResult?, errorCode: Int) {}
            })

            calculateDriveRouteAsyn(routeQuery)
        }
    }
}

object DistanceSearchHandler : SearchMethodHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val search = DistanceSearch(AMapBasePlugin.registrar.context())
        search.setDistanceSearchListener { distanceResult, i ->
            search.setDistanceSearchListener(null)
            if (i == 1000) {
                val list = distanceResult.distanceResults.map {
                    it.distance.toInt()
                }
                result?.success(list)
            } else {
                result?.error("测量失败 code ==> $i", null, null)
            }
        }

        val origins = call.argument<List<Map<String, Any>>>("origin")!!
        val target = call.argument<Map<String, Any>>("target")!!
        val type = call.argument<Int>("type")!!

        search.calculateRouteDistanceAsyn(DistanceSearch.DistanceQuery().apply {
            this.origins = origins.map {
                it.toLatlng().toLatLonPoint()
            }.toMutableList()
            this.destination = target.toLatlng().toLatLonPoint()
            this.type = type
        })
    }

    fun Map<String, Any>.toLatlng(): LatLng {
        val lat = this["latitude"] as Double
        val lng = this["longitude"] as Double
        return LatLng(lat, lng)
    }
}

object SearchBusStation : SearchMethodHandler {

    override fun onMethodCall(methodCall: MethodCall, methodResult: MethodChannel.Result) {
        val stationName = methodCall.argument<String>("stationName") ?: ""
        val city = methodCall.argument<String>("city") ?: ""

        log("方法map#searchBusStation android端参数: stationName -> $stationName, city -> $city")

        BusStationSearch(registrar.context(), BusStationQuery(stationName, city))
                .run {
                    setOnBusStationSearchListener { result, resultCode ->
                        if (resultCode != AMapException.CODE_AMAP_SUCCESS || result == null) {
                            methodResult.error(
                                    resultCode.toString(),
                                    resultCode.toAMapError(),
                                    resultCode.toAMapError()
                            )
                        } else {
                            print(result.toAccessorJson())
                            methodResult.success(result.toAccessorJson())
                        }
                    }

                    searchBusStationAsyn()
                }
    }
}