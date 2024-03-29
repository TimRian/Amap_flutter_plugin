//
// Created by Yohom Bao on 2018-12-15.
//

#import "MapHandlers.h"
#import <CoreLocation/CoreLocation.h>
#import "MAMapView.h"
#import "AMapFoundationKit.h"
#import "AMapViewFactory.h"
#import "MapModels.h"
#import "MJExtension.h"
#import "UnifiedAssets.h"


@implementation SetCustomMapStyleID {
    MAMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;
    NSString *styleId = (NSString *) paramDic[@"styleId"];

    NSLog(@"方法map#setCustomMapStyleID iOS: styleId -> %@", styleId);

    [_mapView setCustomMapStyleID:styleId];
    result(success);
}

@end

@implementation SetCustomMapStyleOptions {
    MAMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;
    NSString *styleId = (NSString *) paramDic[@"styleId"];
    NSString *stylePath = (NSString *) paramDic[@"stylePath"];
    NSString *extraStylePath = (NSString *) paramDic[@"extraStylePath"];

    NSLog(@"方法map#SetCustomMapStyleOptions iOS: styleId -> %@", styleId);

    
    NSString *path = [UnifiedAssets getDefaultAssetPath:stylePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *pathExtra = [UnifiedAssets getDefaultAssetPath:extraStylePath];
    NSData *dataExtra = [NSData dataWithContentsOfFile:pathExtra];

    NSLog(@"方法map#SetCustomMapStyleOptions iOS: path -> %@ pathExtra -> %@", path, extraStylePath);
    
    MAMapCustomStyleOptions *option = [[MAMapCustomStyleOptions alloc] init];
    [option setStyleId:styleId];
    [option setStyleData:data];
    [option setStyleExtraData:dataExtra];
    [_mapView setCustomMapStyleOptions:option];
    [_mapView setCustomMapStyleEnabled:YES];



//    [_mapView setCustomMapStyleID:styleId];
    result(success);
}

@end


@implementation SetCustomMapStylePath {
    MAMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;
    NSString *path = (NSString *) paramDic[@"path"];

    NSLog(@"方法map#setCustomMapStylePath iOS: path -> %@", path);

    NSData *data = [NSData dataWithContentsOfFile:[UnifiedAssets getAssetPath:path]];
    [_mapView setCustomMapStyleWithWebData:data];
    result(success);
}

@end

@implementation SetMapCustomEnable {
    MAMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;
    BOOL enabled = [paramDic[@"enabled"] boolValue];

    NSLog(@"方法map#setMapCustomEnable iOS: enabled -> %d", enabled);

    [_mapView setCustomMapStyleEnabled:enabled];

    result(success);
}

@end

@implementation ConvertCoordinate {
    MAMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;
    CGFloat lat = [paramDic[@"lat"] floatValue];
    CGFloat lon = [paramDic[@"lon"] floatValue];
    int intType = [paramDic[@"type"] intValue];
    AMapCoordinateType type = [self convertTypeWithInt:intType];
    CLLocationCoordinate2D coordinate2D = AMapCoordinateConvert(CLLocationCoordinate2DMake(lat, lon), type);
    NSString *r = [NSString stringWithFormat:@"{\"latitude\":%f,\"longitude\":%f}", coordinate2D.latitude, coordinate2D.longitude];
    result(r);
}

- (AMapCoordinateType)convertTypeWithInt:(int)type {
    switch (type) {
        case 0:
            return AMapCoordinateTypeGPS;
        case 1:
            return AMapCoordinateTypeBaidu;
        case 2:
            return AMapCoordinateTypeMapBar;
        case 3:
            return AMapCoordinateTypeMapABC;
        case 4:
            return AMapCoordinateTypeSoSoMap;
        case 5:
            return AMapCoordinateTypeAliYun;
        case 6:
            return AMapCoordinateTypeGoogle;
        default:
            return AMapCoordinateTypeGPS;
    }
}

@end

@implementation CalcDistance{
    MAMapView *_mapView;
}

- (NSObject<MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *params = [call arguments];
    NSDictionary *p1 = [params valueForKey:@"p1"];
    NSDictionary *p2 = [params valueForKey:@"p2"];
    CLLocationDistance distance = MAMetersBetweenMapPoints([self getPointFromDict:p1],[self getPointFromDict:p2]);
    result([NSNumber numberWithDouble:distance]);
}

-(MAMapPoint) getPointFromDict:(NSDictionary *) dict {
    CGFloat lat = [[dict valueForKey:@"latitude"] floatValue];
    CGFloat lng = [[dict valueForKey:@"longitude"] floatValue];
    return MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
}

@end

@implementation ProcessedTrace{
    MAMapView *_mapView;
    NSOperation *_queryOperation;
    FlutterResult _result;
    NSArray <LatLng *> *_originLatLngArray;
}

- (NSObject<MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    
    _result = result;
    
    NSDictionary *params = [call arguments];

    NSString *originJson = (NSString *) params[@"origin"];

    NSArray <LatLng *> *latLngArray = [LatLng mj_objectArrayWithKeyValuesArray:originJson];
    _originLatLngArray = latLngArray;
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i=0; i<latLngArray.count; i++) {
        LatLng *aa = latLngArray[i];
        MATraceLocation *location = [[MATraceLocation alloc] init];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(aa.latitude, aa.longitude);
        location.loc = coordinate;
        location.angle = aa.angle;
        location.speed = aa.speed;
        location.time = aa.time;
        NSLog(@"%lf, %lf", location.loc.longitude, location.angle);
        [mArr addObject:location];
    }
    
    
    MATraceManager *manager = [[MATraceManager alloc] init];
    
    NSOperation *op = [manager queryProcessedTraceWith:mArr type:-1 processingCallback:^(int index, NSArray<MATracePoint *> *points) {
        //正在处理
//            [weakSelf addSubTrace:points toMapView:weakSelf.mapView2];
        }  finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
            self->_queryOperation = nil;

            NSMutableArray *traces = [NSMutableArray new];

            for (MATracePoint *r in points) {
                LatLng *ll = [[LatLng alloc] init];
                ll.latitude = r.latitude;
                ll.longitude = r.longitude;
                [traces addObject:[ll mj_JSONString]];
            }
            [self setResult:traces];
            
            
        } failedCallback:^(int errorCode, NSString *errorDesc) {
            NSLog(@"Error: %@", errorDesc);
            self->_queryOperation = nil;
            NSMutableArray *traces = [NSMutableArray new];
            for (LatLng *r in _originLatLngArray) {
                [traces addObject:[r mj_JSONString]];
            }
            [self setResult:traces];
        }];
    _queryOperation = op;
    
}
- (void)setResult:(id _Nullable)r {
    if (_result) {
        _result(r);
        _result = nil;
    }
}

@end

@implementation GetCenterPoint{
     MAMapView *_mapView;
}

- (NSObject<MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    CLLocationCoordinate2D coor = _mapView.centerCoordinate;
    LatLng *latlng = [LatLng new];
    latlng.latitude = coor.latitude;
    latlng.longitude = coor.longitude;
    result([latlng mj_JSONString]);
}

@end

@implementation ClearMap {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];

    result(success);
}

@end

@implementation OpenOfflineManager {

}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    UIViewController *ctl = [MAOfflineMapViewController sharedInstance];
    UINavigationController *naviCtl = [[UINavigationController alloc] initWithRootViewController:ctl];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    
    [[ctl navigationItem]setLeftBarButtonItem:item];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: naviCtl animated:YES completion:nil];
}

-(void)dismiss{
    UIViewController *ctl = [MAOfflineMapViewController sharedInstance];
    if([ctl navigationController]){
        [[ctl navigationController] dismissViewControllerAnimated:true completion:nil];
    }
}

@end

@implementation SetLanguage {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    // 由于iOS端是从0开始算的, 所以这里减去1
    NSString *language = (NSString *) paramDic[@"language"];

    NSLog(@"方法map#setLanguage ios端参数: language -> %@", language);

    [_mapView performSelector:NSSelectorFromString(@"setMapLanguage:") withObject:language];

    result(success);
}

@end

@implementation SetMapType {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    // 由于iOS端是从0开始算的, 所以这里减去1
    NSInteger mapType = [paramDic[@"mapType"] integerValue] - 1;

    [_mapView setMapType:(MAMapType) mapType];

    result(success);
}

@end

@implementation SetMyLocationStyle {
    MAMapView *_mapView;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *styleJson = (NSString *) paramDic[@"myLocationStyle"];

    NSLog(@"方法setMyLocationStyle ios端参数: styleJson -> %@", styleJson);
    [[UnifiedMyLocationStyle mj_objectWithKeyValues:styleJson] applyTo:_mapView];

    result(success);
}

@end

@implementation SetUiSettings {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *uiSettingsJson = (NSString *) paramDic[@"uiSettings"];

    NSLog(@"方法setUiSettings ios端参数: uiSettingsJson -> %@", uiSettingsJson);
    [[UnifiedUiSettings mj_objectWithKeyValues:uiSettingsJson] applyTo:_mapView];

    result(success);

}

@end

@implementation ShowIndoorMap {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    BOOL enabled = (BOOL) paramDic[@"showIndoorMap"];

    NSLog(@"方法map#showIndoorMap android端参数: enabled -> %d", enabled);

    _mapView.showsIndoorMap = enabled;

    result(success);
}

@end

@implementation AddMarker {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *optionsJson = (NSString *) paramDic[@"markerOptions"];

    NSLog(@"方法marker#addMarker ios端参数: optionsJson -> %@", optionsJson);
    UnifiedMarkerOptions *markerOptions = [UnifiedMarkerOptions mj_objectWithKeyValues:optionsJson];

    NSNumber *boolNum = paramDic[@"isAnimated"];
    BOOL isAnimated = [boolNum boolValue];
    
    if(isAnimated){
        MarkerAnimatedAnnotation *anno = [[MarkerAnimatedAnnotation alloc] init];
        anno.coordinate = [markerOptions.position toCLLocationCoordinate2D];
        anno.title = markerOptions.title;
        anno.markerOptions = markerOptions;
        [_mapView addAnnotation:anno];
        [_mapView setCenterCoordinate:[markerOptions.position toCLLocationCoordinate2D] animated:YES];
    }else{
        MarkerAnnotation *annotation = [[MarkerAnnotation alloc] init];
        annotation.coordinate = [markerOptions.position toCLLocationCoordinate2D];
        annotation.title = markerOptions.title;
        annotation.subtitle = markerOptions.snippet;
        annotation.markerOptions = markerOptions;
        [_mapView addAnnotation:annotation];
    }
   

    result(success);
}

@end

@implementation AddMarkers {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *moveToCenter = (NSString *) paramDic[@"moveToCenter"];
    NSString *optionsListJson = (NSString *) paramDic[@"markerOptionsList"];
    BOOL clear = (BOOL) paramDic[@"clear"];

    NSLog(@"方法marker#addMarkers ios端参数: optionsListJson -> %@", optionsListJson);
    if (clear) [_mapView removeAnnotations:_mapView.annotations];

    NSArray *rawOptionsList = [NSJSONSerialization JSONObjectWithData:[optionsListJson dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:kNilOptions
                                                                error:nil];
    NSMutableArray<MarkerAnnotation *> *optionList = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < rawOptionsList.count; ++i) {
        UnifiedMarkerOptions *options = [UnifiedMarkerOptions mj_objectWithKeyValues:rawOptionsList[i]];
        MarkerAnnotation *annotation = [[MarkerAnnotation alloc] init];
        annotation.coordinate = [options.position toCLLocationCoordinate2D];
        annotation.title = options.title;
        annotation.subtitle = options.snippet;
        annotation.markerOptions = options;
        [optionList addObject:annotation];
    }

    [_mapView addAnnotations:optionList];
    if (moveToCenter.boolValue) {
        [_mapView showAnnotations:optionList animated:YES];
    }

    result(success);
}

@end

@implementation addMoveAnimation{
    MAMapView *_mapView;
    long currentCount;
    long count;
    NSString *duration;
    NSString *isFinish;
    NSString *isStop;
    NSString *originTime;
    NSString *isRepeat;
    CLLocationCoordinate2D *coordinate;
    NSArray *rawOptionsList;
}

- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    currentCount = 1;
    count = 1;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    
    NSDictionary *paramDic = call.arguments;
    
    __block MAAnimatedAnnotation *anno;
    [_mapView.annotations enumerateObjectsUsingBlock:^(MAAnimatedAnnotation *annotation, NSUInteger idx, BOOL * _Nonnull stop) {
        //if([annotation isKindOfClass:[MarkerAnimatedAnnotation class]]){
        //    anno = annotation;
        //}
        if([annotation.title isEqualToString:@"小车"]){
            anno = annotation;
        }
    }];
    
    if(anno == nil){
        result(@"没有小车");
        return;
    }
    
    int actions = [paramDic[@"actions"] intValue];//
    
    
    //暂停
    if (actions == 2) {
        for (MAAnnotationMoveAnimation *animation in [anno allMoveAnimations]) {
            [animation cancel];
            currentCount = animation.passedPointCount;
            count = animation.count;
            
            rawOptionsList = [rawOptionsList subarrayWithRange:NSMakeRange(currentCount, count-currentCount)];
            double d = [self->duration doubleValue];
            double per = currentCount*1.0 / count;
            self->duration = [NSString stringWithFormat:@"%lf", d*per];
            
            self->isStop = @"YES";
            self->isFinish = @"YES"; //继续播放
            self->isRepeat = @"NO";
        }
        return;
    }
    
    //播放
    
    if (actions == 1) {
        
        double dura = [paramDic[@"duration"] doubleValue];
        
        BOOL diff = NO;
        BOOL cancel = NO;
        if ([self->originTime doubleValue] != dura) {
            diff = YES;
            self->originTime = [NSString stringWithFormat:@"%lf", dura];
            //取消以前的 (半路开始)
            for (MAAnnotationMoveAnimation *animation in [anno allMoveAnimations]) {
                [animation cancel];
                cancel = YES;
                currentCount = animation.passedPointCount;
                count = animation.count;
                
                rawOptionsList = [rawOptionsList subarrayWithRange:NSMakeRange(currentCount, count-currentCount)];
                double d = [self->originTime doubleValue];
                double per = (count-currentCount)*1.0 / count;
                self->duration = [NSString stringWithFormat:@"%lf", d*per];
                
                self->isStop = @"YES";
                self->isFinish = @"YES"; //继续播放
            }
        }else{
            //新的
            if([self->isRepeat isEqual:@"YES"]){
                self->isStop = @"NO";
            }
            //暂停
            if([self->isRepeat isEqual:@"NO"]){
                self->isStop = @"YES";
            }
        }
        
        
        if (self->isFinish == nil || [self->isFinish  isEqual: @"YES"] || diff==YES) {
            
            if ([self->isStop isEqual:@"YES"]) {
                
            }else{
                currentCount = 1;
                self->isFinish = @"NO";
                self->isStop =  @"NO";
                
                NSString *coordinatesListJson = (NSString *) paramDic[@"coordinatesList"];
                
                if([coordinatesListJson isEqualToString:@"[]"]){
                    result(@"没有轨迹");
                    return;
                }
                
                rawOptionsList = [NSJSONSerialization JSONObjectWithData:[coordinatesListJson dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options:kNilOptions
                                                                            error:nil];
                
                coordinate = malloc(sizeof(CLLocationCoordinate2D)*rawOptionsList.count);
                
                
                if (cancel == NO) {
                    double dura = [paramDic[@"duration"] doubleValue];
                    self->duration = [NSString stringWithFormat:@"%lf", dura];
                }
            }

            for (NSUInteger i = 0; i < rawOptionsList.count; ++i) {
                LatLng *position = [LatLng mj_objectWithKeyValues:rawOptionsList[i]];
                
                if(i==0){
                    //复位
                    anno.coordinate = [position toCLLocationCoordinate2D];
                }
                
                CLLocationCoordinate2D *point = &coordinate[i];
                point->latitude = position.latitude;
                point->longitude = position.longitude;
            }
            
            
            [anno addMoveAnimationWithKeyCoordinates:coordinate count:rawOptionsList.count withDuration:[self->duration doubleValue] withName:anno.title completeCallback:^(BOOL isFinished) {
                if(isFinished){
                    free(self->coordinate);
                    self->rawOptionsList = nil;
                    self->isFinish = @"YES";
                    self->isStop = @"NO";
                    self->isRepeat = @"YES";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"palyFinish" object:nil];
                }
            }];
        }
        
    }
    
    
    
//    if(coordinate) {
//
//        for (NSUInteger i = 0; i < rawOptionsList.count; ++i) {
//            LatLng *position = [LatLng mj_objectWithKeyValues:rawOptionsList[i]];
//
//            if(i==0){
//                //复位
//                anno.coordinate = [position toCLLocationCoordinate2D];
//            }
//
//            CLLocationCoordinate2D *point = &coordinate[i];
//            point->latitude = position.latitude;
//            point->longitude = position.longitude;
//        }
//
//
//        [anno addMoveAnimationWithKeyCoordinates:coordinate count:rawOptionsList.count withDuration:[duration doubleValue] withName:anno.title completeCallback:^(BOOL isFinished) {
//            if(isFinished){
//                free(self->coordinate);
//                self->rawOptionsList = nil;
//                self->isFinish = @"YES";
//            }
//        }];
//
//    }

    result(success);
}


@end

@implementation AddPolyline {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSString *optionsJson = (NSString *) call.arguments[@"options"];

    NSLog(@"map#addPolyline ios端参数: optionsJson -> %@", optionsJson);

    UnifiedPolylineOptions *options = [UnifiedPolylineOptions initWithJson:optionsJson];

    NSUInteger count = options.latLngList.count;

    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSUInteger i = 0; i < count; ++i) {
        commonPolylineCoords[i] = [options.latLngList[i] toCLLocationCoordinate2D];
    }

    PolylineOverlay *polyline = [PolylineOverlay polylineWithCoordinates:commonPolylineCoords count:options.latLngList.count];
    polyline.options = options;
    [_mapView addOverlay:polyline];

    result(success);
}

@end

@implementation AddCircle {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSString *optionsJson = (NSString *) call.arguments[@"options"];

    NSLog(@"map#addCircle ios端参数: optionsJson -> %@", optionsJson);

    UnifiedCircleOptions *options = [UnifiedCircleOptions initWithJson:optionsJson];
    
    //init
    CircleOverlay *circle = [CircleOverlay circleWithCenterCoordinate:CLLocationCoordinate2DMake(options.position.latitude, options.position.longitude) radius:options.radius];
    circle.options = options;
    [_mapView addOverlay:circle];

//    NSUInteger count = options.latLngList.count;
//
//    CLLocationCoordinate2D commonPolylineCoords[count];
//    for (NSUInteger i = 0; i < count; ++i) {
//        commonPolylineCoords[i] = [options.latLngList[i] toCLLocationCoordinate2D];
//    }
//
//    PolylineOverlay *polyline = [PolylineOverlay polylineWithCoordinates:commonPolylineCoords count:options.latLngList.count];
//    polyline.options = options;
//    [_mapView addOverlay:polyline];

    result(success);
}

@end

@implementation ClearMarker {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    [_mapView removeAnnotations:_mapView.annotations];

    result(success);
}

@end

@implementation ChangeLatLng {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *targetJson = (NSString *) paramDic[@"target"];

    LatLng *target = [LatLng mj_objectWithKeyValues:targetJson];

    [_mapView setCenterCoordinate:[target toCLLocationCoordinate2D] animated:YES];

    result(success);
}

@end

@implementation SetMapStatusLimits {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *center = (NSString *) paramDic[@"center"];
    CGFloat deltaLat = [paramDic[@"deltaLat"] floatValue];
    CGFloat deltaLng = [paramDic[@"deltaLng"] floatValue];

    NSLog(@"方法map#setMapStatusLimits ios端参数: center -> %@, deltaLat -> %f, deltaLng -> %f", center, deltaLat, deltaLng);


    LatLng *centerPosition = [LatLng mj_objectWithKeyValues:center];

    [_mapView setLimitRegion:MACoordinateRegionMake(
            [centerPosition toCLLocationCoordinate2D],
            MACoordinateSpanMake(deltaLat, deltaLng))
    ];

    result(success);
}

@end


// 获得对角经纬度
@implementation GetVisibleRegion {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {

    int ww = ([[UIScreen mainScreen] bounds].size.width);
    int wh = ([[UIScreen mainScreen] bounds].size.height);
    CGPoint nePoint=CGPointMake(ww, 90);
    CGPoint swPoint=CGPointMake(0, wh);
    CLLocationCoordinate2D sw=[_mapView convertPoint:swPoint toCoordinateFromView:_mapView.superview];
    CLLocationCoordinate2D ne=[_mapView convertPoint:nePoint toCoordinateFromView:_mapView.superview];

//    NSDictionary *swDic=BMKConvertBaiduCoorFrom(sw, BMK_COORDTYPE_COMMON);
//    CLLocationCoordinate2D baiduSW=BMKCoorDictionaryDecode(swDic);//左下角
//
//    NSDictionary *neDic=BMKConvertBaiduCoorFrom(ne, BMK_COORDTYPE_COMMON);
//    CLLocationCoordinate2D baiduNE=BMKCoorDictionaryDecode(neDic);//右上角
//
//    NSDictionary *paramDic=@{@"swLon":baiduSW.longitude,
//                             @"swLat":baiduSW.latitude,
//                             @"neLon":baiduNE.longitude,
//                             @"neLat":baiduNE.latitude};
    
//    NSDictionary *paramDic=@{@"swLon":@(sw.longitude),
//                             @"swLat":@(sw.latitude),
//                             @"neLon":@(ne.longitude),
//                             @"neLat":@(ne.latitude)};

    
    CLLocationCoordinate2D sw_bd = [self gaodeToBdWithLat:sw];
    CLLocationCoordinate2D ne_bd = [self gaodeToBdWithLat:ne];
    
    NSString *_swLng=[NSString stringWithFormat:@"%lf",sw_bd.longitude];
    NSString *_swLat=[NSString stringWithFormat:@"%lf",sw_bd.latitude];
    NSString *_neLng=[NSString stringWithFormat:@"%lf",ne_bd.longitude];
    NSString *_neLat=[NSString stringWithFormat:@"%lf",ne_bd.latitude];
    NSDictionary *paramDic=@{@"swLon":_swLng,
                             @"swLat":_swLat,
                             @"neLon":_neLng,
                             @"neLat":_neLat};

    result([paramDic mj_JSONString]);
}

//高德转百度
-(CLLocationCoordinate2D)gaodeToBdWithLat:(CLLocationCoordinate2D)coordinate{
    
    double x = coordinate.longitude;
    double y = coordinate.latitude;
    
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double tempLon = z * cos(theta) + 0.0065;
    double tempLat = z * sin(theta) + 0.006;
    
    CLLocationCoordinate2D coo = CLLocationCoordinate2DMake(tempLat, tempLon);
    
    return coo;
}

@end

#pragma mark -- 设置地图中心点
@implementation SetMapCenter {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *target = (NSString *) paramDic[@"target"];
    CGFloat zoom = [paramDic[@"zoom"] floatValue];
    CGFloat tilt = [paramDic[@"tilt"] floatValue];

    LatLng *position = [LatLng mj_objectWithKeyValues:target];

    [_mapView setCenterCoordinate:[position toCLLocationCoordinate2D] animated:true];
    _mapView.zoomLevel = zoom;
    _mapView.rotationDegree = tilt;

    result(success);
}

@end

@implementation SetZoomLevel {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    CGFloat zoomLevel = [paramDic[@"zoomLevel"] floatValue];

    _mapView.zoomLevel = zoomLevel;

    result(success);
}

@end

@implementation ZoomToSpan {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    NSDictionary *paramDic = call.arguments;

    NSString *boundJson = (NSString *) paramDic[@"bound"];
    NSInteger padding = [paramDic[@"padding"] integerValue] / 2;

    NSArray <LatLng *> *latLngArray = [LatLng mj_objectArrayWithKeyValuesArray:boundJson];

    NSUInteger count = latLngArray.count;

    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSUInteger i = 0; i < count; ++i) {
        commonPolylineCoords[i] = [latLngArray[i] toCLLocationCoordinate2D];
    }

    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
    [_mapView showOverlays:@[polyline] edgePadding:UIEdgeInsetsMake(padding, padding, padding, padding) animated:YES];
}

@end

@implementation ScreenShot {
    MAMapView *_mapView;
}
- (NSObject <MapMethodHandler> *)initWith:(MAMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    CGRect rect = [_mapView frame];
    [_mapView takeSnapshotInRect:rect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        if (resultImage == nil) {
            FlutterError *err = [FlutterError errorWithCode:@"截图失败,渲染未完成" message:@"截图失败,渲染未完成" details:nil];
            result(err);
            return;
        }
        if (state != 1) {
            FlutterError *err = [FlutterError errorWithCode:@"截图失败,渲染未完成" message:@"截图失败,渲染未完成" details:nil];
            result(err);
            return;
        }
        NSData *data = UIImageJPEGRepresentation(resultImage, 100);
        FlutterStandardTypedData *r = [FlutterStandardTypedData typedDataWithBytes:data];
        result(r);
    }];
}
@end
