package com.wdh.amap_special

import com.wdh.amap_special.location.Init
import com.wdh.amap_special.location.StartLocate
import com.wdh.amap_special.location.StopLocate
import com.wdh.amap_special.map.*
import com.wdh.amap_special.navi.handler.StartNavi
import com.wdh.amap_special.search.*

/**
 * 地图功能集合
 */
val MAP_METHOD_HANDLER: Map<String, MapMethodHandler> = mapOf(
        "map#setMyLocationStyle" to SetMyLocationStyle,
        "map#setUiSettings" to SetUiSettings,
        "marker#addMarker" to AddMarker,
        "marker#addMarkers" to AddMarkers,
        "map#addCircle" to AddCircle,
        "marker#clear" to ClearMarker,
        "map#showIndoorMap" to ShowIndoorMap,
        "map#setMapType" to SetMapType,
        "map#setLanguage" to SetLanguage,
        "map#clear" to ClearMap,
        "map#setZoomLevel" to SetZoomLevel,
        "map#setPosition" to SetPosition,
        "map#setMapStatusLimits" to SetMapStatusLimits,
        "map#getVisibleRegion" to getVisibleRegion,
        "tool#convertCoordinate" to ConvertCoordinate,
        "tool#calcDistance" to CalcDistance,
        "offline#openOfflineManager" to OpenOfflineManager,
        "map#addPolyline" to AddPolyline,
        "map#zoomToSpan" to ZoomToSpan,
        "map#screenshot" to ScreenShot,
        "map#setCustomMapStylePath" to SetCustomMapStylePath,
        "map#setMapCustomEnable" to SetMapCustomEnable,
        "map#setCustomMapStyleID" to SetCustomMapStyleID,
        "map#getCenterPoint" to GetCenterLnglat,
        "map#changeLatLng" to ChangeLatLng
)

/**
 * 搜索功能集合
 */
val SEARCH_METHOD_HANDLER: Map<String, SearchMethodHandler> = mapOf(
        "search#calculateDriveRoute" to CalculateDriveRoute,
        "search#searchPoi" to SearchPoiKeyword,
        "search#searchPoiBound" to SearchPoiBound,
        "search#searchPoiPolygon" to SearchPoiPolygon,
        "search#searchPoiId" to SearchPoiId,
        "search#searchRoutePoiLine" to SearchRoutePoiLine,
        "search#searchRoutePoiPolygon" to SearchRoutePoiPolygon,
        "search#searchGeocode" to SearchGeocode,
        "search#searchReGeocode" to SearchReGeocode,
        "search#searchBusStation" to SearchBusStation,
        "tool#distanceSearch" to DistanceSearchHandler
)

/**
 * 导航功能集合
 */
val NAVI_METHOD_HANDLER: Map<String, NaviMethodHandler> = mapOf(
        "navi#startNavi" to StartNavi
)

/**
 * 定位功能集合
 */
val LOCATION_METHOD_HANDLER: Map<String, LocationMethodHandler> = mapOf(
        "location#init" to Init,
        "location#startLocate" to StartLocate,
        "location#stopLocate" to StopLocate
)
