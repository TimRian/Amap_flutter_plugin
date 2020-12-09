//
// Created by Yohom Bao on 2018-12-16.
//

#import "SearchHandlers.h"
#import "Misc.h"
#import "MJExtension.h"
#import "SearchModels.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation SearchGeocode {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *name = (NSString *) paramDic[@"name"];
    NSString *city = (NSString *) paramDic[@"city"];

    NSLog(@"search#searchGeocode ios端参数: name -> %@, city -> %@", name, city);

    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
    request.address = name;
    request.city = city;

    [_search AMapGeocodeSearch:request];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0) {
        _result([FlutterError errorWithCode:@"搜索不到结果"
                                    message:@"搜索不到结果"
                                    details:nil]);
        return;
    }

    _result([[[UnifiedGeocodeResult alloc] initWithAMapGeocodeSearchResponse:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}

@end

@implementation SearchReGeocode {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *pointJson = (NSString *) paramDic[@"point"];
    double radius = [paramDic[@"radius"] doubleValue];
    NSInteger latLonType = [paramDic[@"latLonType"] integerValue];

    NSLog(@"search#searchReGeocode ios端参数: point -> %@, radius -> %f, latLonType -> %d", pointJson, radius, latLonType);

    AMapGeoPoint *point = [AMapGeoPoint mj_objectWithKeyValues:pointJson];

    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:point.latitude longitude:point.longitude];
    request.requireExtension = YES;
    request.radius = (NSInteger) radius;

    [_search AMapReGoecodeSearch:request];
}

/// 逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode == nil) {
        _result([FlutterError errorWithCode:@"搜索不到结果"
                                    message:@"搜索不到结果"
                                    details:nil]);
        return;
    }

    _result([[[UnifiedReGeocodeResult alloc] initWithAMapReGeocodeSearchResponse:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}

@end

@implementation SearchPoiBound {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *query = (NSString *) paramDic[@"query"];

    NSLog(@"方法map#searchPoiBound ios端参数: query -> %@", query);

    UnifiedPoiSearchQuery *request = [UnifiedPoiSearchQuery mj_objectWithKeyValues:query];

    [_search AMapPOIAroundSearch:[request toAMapPOIAroundSearchRequest]];
}

/// poi搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"poi搜索回调");
    _result([[[UnifiedPoiResult alloc] initWithPoiResult:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}
@end

@implementation SearchPoiId {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;
    NSString *id = (NSString *) paramDic[@"id"];

    NSLog(@"方法map#searchPoiId ios端参数: id -> %@", id);

    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    request.uid = id;
    request.requireExtension = YES;
    [_search AMapPOIIDSearch:request];
}

/// poi搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"poi搜索回调");
    _result([[[UnifiedPoiResult alloc] initWithPoiResult:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}
@end

@implementation SearchPoiKeyword {
    AMapSearchAPI *_search;
    FlutterResult _result;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *query = (NSString *) paramDic[@"query"];

    NSLog(@"方法map#searchPoi ios端参数: query -> %@", query);
    UnifiedPoiSearchQuery *request = [UnifiedPoiSearchQuery mj_objectWithKeyValues:query];

    [_search AMapPOIKeywordsSearch:[request toAMapPOIKeywordsSearchRequest]];
}

/// poi搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"poi搜索回调");
    _result([[[UnifiedPoiResult alloc] initWithPoiResult:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}
@end

@implementation SearchPoiPolygon {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *query = (NSString *) paramDic[@"query"];

    NSLog(@"方法map#searchPoiPolygon ios端参数: query -> %@", query);

    UnifiedPoiSearchQuery *request = [UnifiedPoiSearchQuery mj_objectWithKeyValues:query];

    [_search AMapPOIPolygonSearch:[request toAMapPOIPolygonSearchRequest]];
}

/// poi搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"poi搜索回调");
    _result([[[UnifiedPoiResult alloc] initWithPoiResult:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}

@end

@implementation SearchRoutePoiLine {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *query = (NSString *) paramDic[@"query"];

    NSLog(@"方法map#searchRoutePoiLine ios端参数: query -> %@", query);

    UnifiedRoutePoiSearchQuery *request = [UnifiedRoutePoiSearchQuery mj_objectWithKeyValues:query];

    [_search AMapRoutePOISearch:[request toAMapRoutePOISearchRequestLine]];
}

/// 沿途搜索回调
- (void)onRoutePOISearchDone:(AMapRoutePOISearchRequest *)request response:(AMapRoutePOISearchResponse *)response {
    NSLog(@"poi搜索回调");
    _result([[[UnifiedRoutePOISearchResult alloc] initWithAMapRoutePOISearchResponse:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}

@end

@implementation SearchRoutePoiPolygon {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *query = (NSString *) paramDic[@"query"];

    NSLog(@"方法map#searchRoutePoiLine ios端参数: query -> %@", query);

    UnifiedRoutePoiSearchQuery *request = [UnifiedRoutePoiSearchQuery mj_objectWithKeyValues:query];

    [_search AMapRoutePOISearch:[request toAMapRoutePOISearchRequestPolygon]];
}

/// 沿途搜索回调
- (void)onRoutePOISearchDone:(AMapRoutePOISearchRequest *)request response:(AMapRoutePOISearchResponse *)response {
    NSLog(@"poi搜索回调");
    _result([[[UnifiedRoutePOISearchResult alloc] initWithAMapRoutePOISearchResponse:response] mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"搜索失败回调");
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}

@end

@implementation CalculateDriveRoute {
    RoutePlanParam *_routePlanParam;
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *routePlanParamJson = (NSString *) paramDic[@"routePlanParam"];

    NSLog(@"方法calculateDriveRoute ios端参数: routePlanParamJson -> %@", routePlanParamJson);

    _routePlanParam = [RoutePlanParam mj_objectWithKeyValues:routePlanParamJson];

    // 路线请求参数构造
    AMapDrivingRouteSearchRequest *routeQuery = [[AMapDrivingRouteSearchRequest alloc] init];
    routeQuery.origin = _routePlanParam.from;
    routeQuery.destination = _routePlanParam.to;
    routeQuery.strategy = _routePlanParam.mode;
    routeQuery.waypoints = _routePlanParam.passedByPoints;
    routeQuery.avoidpolygons = _routePlanParam.avoidPolygons;
    routeQuery.avoidroad = _routePlanParam.avoidRoad;
    routeQuery.requireExtension = YES;

    [_search AMapDrivingRouteSearch:routeQuery];
}

/// 路径规划搜索回调.
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route.paths.count == 0) {
        return _result(@"没有规划出合适的路线");
    }

    _result([[[UnifiedDriveRouteResult alloc] initWithAMapRouteSearchResponse:response] mj_JSONString]);
}

/// 路线规划失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if (_result != nil) {
        _result([NSString stringWithFormat:@"路线规划失败, 错误码: %ld", (long) error.code]);
    }
}

@end

@implementation DistanceSearch {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;
    NSDictionary *dict = call.arguments;
    NSArray<NSDictionary *> *originArray = [dict valueForKey:@"origin"];
    NSDictionary *targetDict = [dict valueForKey:@"target"];

    NSArray<AMapGeoPoint *> *srcPoints = [AMapGeoPoint mj_objectArrayWithKeyValuesArray:originArray];
    AMapGeoPoint *target = [AMapGeoPoint mj_objectWithKeyValues:targetDict];

    AMapDistanceSearchRequest *request = [AMapDistanceSearchRequest new];
    request.type = [[dict valueForKey:@"type"] intValue];
    request.origins = srcPoints;
    request.destination = target;

    [_search AMapDistanceSearch:request];
}

- (void)onDistanceSearchDone:(AMapDistanceSearchRequest *)request response:(AMapDistanceSearchResponse *)response {
    NSArray<AMapDistanceResult *> *results = [response results];

    NSMutableArray *distances = [NSMutableArray new];

    for (AMapDistanceResult *r in results) {
        [distances addObject:@(r.distance)];
    }
    [self setResult:distances];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"测量失败 失败代码 code==> %ld", (long) [error code]];
    [self setResult:[FlutterError errorWithCode:msg message:nil details:nil]];
}

- (void)setResult:(id _Nullable)r {
    if (_result) {
        _result(r);
        _result = nil;
    }
}

@end

@implementation SearchBusStation {
    AMapSearchAPI *_search;
    FlutterResult _result;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 搜索api回调设置
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall *)call :(FlutterResult)result {
    _result = result;

    NSDictionary *paramDic = call.arguments;

    NSString *stationName = (NSString *) paramDic[@"stationName"];
    NSString *city = (NSString *) paramDic[@"city"];

    NSLog(@"方法map#searchBusStation ios端参数: stationName -> %@, city -> %@", stationName, city);

    AMapBusStopSearchRequest *request = [[AMapBusStopSearchRequest alloc] init];
    request.keywords = stationName;
    request.city = city;

    [_search AMapBusStopSearch:request];
}

/// 公交站点回调
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response {
    if (response.busstops.count == 0) {
        return _result([FlutterError errorWithCode:@"没有搜索到结果"
                                           message:@"没有搜索到结果"
                                           details:@"没有搜索到结果"]);
    }

    NSLog([response mj_JSONString]);
    _result([response mj_JSONString]);
}

/// 搜索失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    _result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", error.code]
                                message:[Misc toAMapErrorDesc:error.code]
                                details:nil]);
}

@end
