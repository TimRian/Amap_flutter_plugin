//
// Created by Yohom Bao on 2018-12-15.
//

#import "LocationHandlers.h"
#import "MJExtension.h"
#import "AmapSpecialPlugin.h"
#import "LocationModels.h"

static AMapLocationManager *_locationManager;

@implementation Init {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[AMapLocationManager alloc] init];
        if (@available(iOS 14.0, *)) {
            _locationManager.locationAccuracyMode = AMapLocationFullAndReduceAccuracy;
        } else {
            // Fallback on earlier versions
        }
    }

    return self;
}


- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    result(@"成功");
}

@end


#pragma 开始定位

@implementation StartLocate {
    FlutterEventChannel *_locationEventChannel;
    FlutterEventSink _sink;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationEventChannel = [FlutterEventChannel eventChannelWithName:@"foton/location_event"
                                                          binaryMessenger:[[AmapSpecialPlugin registrar] messenger]];
        [_locationEventChannel setStreamHandler:self];
    }

    return self;
}


- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *params = call.arguments;
    NSString *optionJson = params[@"options"];

    NSLog(@"startLocate ios端: options.toJsonString() -> %@", optionJson);
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //定位不能用
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"\n定位未开启！为了更好的体验，请到【设置->隐私->定位服务】中开启！"
             delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        result(@"定位未开启");
        return;
    }
    

    UnifiedLocationClientOptions *options = [UnifiedLocationClientOptions mj_objectWithKeyValues:optionJson];

    _locationManager.delegate = self;

    [options applyTo:_locationManager];

    if (options.isOnceLocation) {
        [_locationManager requestLocationWithReGeocode:YES
                                       completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                                           if (error) {
                                               result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                                                                          message:error.localizedDescription
                                                                          details:error.localizedDescription]);
                                           } else {
                                               result(@"开始定位");
                                           }

            self->_sink([[[UnifiedAMapLocation alloc] initWithLocation:location
                                                                                  withRegoecode:regeocode
                                                                                      withError:error] mj_JSONString]);
                                       }];
    } else {
        [_locationManager startUpdatingLocation];
    }

}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (_sink) {
        _sink([[[UnifiedAMapLocation alloc] initWithLocation:location
                                               withRegoecode:reGeocode
                                                   withError:nil] mj_JSONString]);
    }
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
    _sink = events;
    return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireTemporaryFullAccuracyAuth:(CLLocationManager*)locationManager completion:(void(^)(NSError *error))completion
{
    // 通过字段判断可以明确当前用户开启的定位，如果是模糊定位
    // 申请精准定位
    if (@available(iOS 14.0, *)) {
        if(manager.currentAuthorization == CLAccuracyAuthorizationReducedAccuracy){
            // -1
            [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"purposeKeyGetLocation" completion:^(NSError * _Nullable error) {
                NSLog(@"%@", [NSString stringWithFormat:@"requestTemporaryFullAccuracyAuthorizationWithPurposeKey error%@",error]);
                if(completion){
                    completion(error);
                }
            }];
        } else {
            // Fallback on earlier versions
            NSLog(@"定位失败");
        }
    } else {
        // Fallback on earlier versions
    }
}

@end


#pragma 结束定位

@implementation StopLocate {

}
- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    [_locationManager stopUpdatingLocation];
}

@end
