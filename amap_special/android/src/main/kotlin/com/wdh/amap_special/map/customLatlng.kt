package com.wdh.amap_special.map



/**
 * Auto-generated: 2022-04-16 9:28:28
 *
 * @author qrc
 *
 */
class CustomLatlng {
    var latitude: Double  = 0.0
    var longitude:Double = 0.0
    var angle = 0.0
    var speed = 0.0
//    var time:String = "0"

    constructor(latitude: Double, longitude: Double, angle: Double, speed: Double) {
        this.latitude = latitude
        this.longitude = longitude
        this.angle = angle
        this.speed = speed
//        this.time = time
    }


    override fun toString(): String {
        return "CustomLatlng(latitude=$latitude, longitude=$longitude, angle=$angle, speed=$speed, time)"
    }


}