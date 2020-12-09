//
//  CustomAnnotationView.h
//  amap_special
//
//  Created by Tim Duncan on 2020/12/8.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "MapModels.h"
#import "CustomCalloutView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong)CustomCalloutView *calloutView;
@property (nonatomic, strong)UnifiedMarkerOptions *model;

@end

NS_ASSUME_NONNULL_END
