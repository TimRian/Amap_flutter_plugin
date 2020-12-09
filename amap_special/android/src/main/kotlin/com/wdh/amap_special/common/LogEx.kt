package com.wdh.amap_special.common

import android.util.Log
import com.wdh.amap_special.BuildConfig

fun Any.log(content: String) {
    if (BuildConfig.DEBUG) {
        Log.d(this::class.simpleName, content)
    }
}