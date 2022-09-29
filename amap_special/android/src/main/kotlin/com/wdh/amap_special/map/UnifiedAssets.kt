package com.wdh.amap_special.map

import android.graphics.BitmapFactory
import com.amap.api.maps.model.BitmapDescriptor
import com.amap.api.maps.model.BitmapDescriptorFactory
import com.wdh.amap_special.AMapBasePlugin.Companion.registrar

object UnifiedAssets {
    private val assetManager = registrar.context().assets

    /**
     * 获取宿主app的图片
     */
    fun getBitmapDescriptor(asset: String): BitmapDescriptor {
        val assetFileDescriptor = assetManager.openFd(registrar.lookupKeyForAsset(asset))
        return BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(assetFileDescriptor.createInputStream()))
    }

    /**
     * 获取plugin自带的图片
     */
    fun getDefaultBitmapDescriptor(asset: String): BitmapDescriptor {
        return BitmapDescriptorFactory.fromAsset(registrar.lookupKeyForAsset(asset, "amap_special"))
    }

    fun getDefaultPath(asset: String): String {
        return registrar.lookupKeyForAsset(asset, "amap_special")
    }
}