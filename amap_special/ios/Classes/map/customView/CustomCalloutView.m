//
//  CustomCalloutView.m
//  amap_special
//
//  Created by Tim Duncan on 2020/12/8.
//

#import "CustomCalloutView.h"
#define kArrorHeight    5
@implementation CustomCalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        
        //title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 70, 33)];
        _titleLabel.text = @"京A12132";
        _titleLabel.textColor = UIColor.blueColor;
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_titleLabel];
        
        
    }
    
    return self;
}

- (void)setModel:(UnifiedMarkerOptions *)model{
    _model = model;
    _titleLabel.text = _model.title;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


@end
