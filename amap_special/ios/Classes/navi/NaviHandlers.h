//
// Created by Yohom Bao on 2018-12-17.
//

#import <Foundation/Foundation.h>
#import "IMethodHandler.h"

@class AMapNaviCompositeManager;

@interface StartNavi : NSObject <NaviMethodHandler>
@property(nonatomic, strong) AMapNaviCompositeManager *compositeManager;
@end