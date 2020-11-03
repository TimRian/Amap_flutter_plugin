#import "AmapSpecialPlugin.h"
#if __has_include(<amap_special/amap_special-Swift.h>)
#import <amap_special/amap_special-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_special-Swift.h"
#endif
#import <AMapNaviKit/AMapNaviKit.h>
#import "IMethodHandler.h"
#import "FunctionRegistry.h"
#import "AMapViewFactory.h"

static NSObject <FlutterPluginRegistrar> *_registrar;

@implementation AmapSpecialPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  [SwiftAmapSpecialPlugin registerWithRegistrar:registrar];
    
//    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"amap_special" binaryMessenger:registrar.messenger];
//    AmapSpecialPlugin *instance = [[AmapSpecialPlugin alloc] init];
//    [registrar addMethodCallDelegate:instance channel:channel];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    _registrar = registrar;
    
    // 设置权限 channel
    FlutterMethodChannel *permissionChannel = [FlutterMethodChannel methodChannelWithName:@"foton/permission" binaryMessenger:registrar.messenger];
    [permissionChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        result(@YES);
    }];
    
    // 设置key channel
    FlutterMethodChannel *setKeyChannel = [FlutterMethodChannel methodChannelWithName:@"foton/amap_base" binaryMessenger:registrar.messenger];
    [setKeyChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"setKey"]) {
            NSString *key = call.arguments[@"key"];
            [AMapServices sharedServices].apiKey = key;
            result(@"key设置成功");
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
    
    
    // 导航 channel
    FlutterMethodChannel *navChannel = [FlutterMethodChannel methodChannelWithName:@"foton/navi" binaryMessenger:registrar.messenger];
    [navChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //通道-->方法表（FunctionRegistry）->实现(实现协议)
        NSObject <NaviMethodHandler>*handler = [NaviFunctionRegistry naviMethodHandler][call.method];
        if (handler) {
            [[handler init] onMethodCall:call :result];
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
    
    // 定位 channel
    FlutterMethodChannel *locationChannel = [FlutterMethodChannel methodChannelWithName:@"foton/location" binaryMessenger:registrar.messenger];
    [locationChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSObject <LocationMethodHandler> *hander = [LocationFunctionRegistry locationMethodHandler][call.method];
        if (hander) {
            [[hander init] onMethodCall:call :result];
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
    
    // MapView 
    [_registrar registerViewFactory:[[AMapViewFactory alloc] init] withId:@"foton/AMapView"];
    
}

+ (NSObject <FlutterPluginRegistrar> *)registrar {
    return _registrar;
}


//- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
//
//    if ([call.method isEqualToString:@"getPlatformVersion"]) {
////        result("iOS " + UIDevice.current.systemVersion);
//        result([NSString stringWithFormat:@"iOS oc %@", UIDevice.currentDevice.systemVersion]);
//    }else{
//        result(FlutterMethodNotImplemented);
//    }
//
//}

@end
