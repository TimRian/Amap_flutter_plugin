#import <Foundation/Foundation.h>
#import "IMethodHandler.h"
#import "AMapLocationKit.h"

@class AMapLocationManager;

#pragma 初始化

@interface Init : NSObject <LocationMethodHandler>
@end

#pragma 开始定位

@interface StartLocate : NSObject <LocationMethodHandler, AMapLocationManagerDelegate, FlutterStreamHandler>
@end

#pragma 结束定位

@interface StopLocate : NSObject <LocationMethodHandler>
@end
