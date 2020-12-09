//
//  CustomCalloutView.h
//  amap_special
//
//  Created by Tim Duncan on 2020/12/8.
//

#import <UIKit/UIKit.h>
#import "MapModels.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomCalloutView : UIView

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UnifiedMarkerOptions *model;

@end

NS_ASSUME_NONNULL_END
