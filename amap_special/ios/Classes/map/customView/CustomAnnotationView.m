//
//  CustomAnnotationView.m
//  amap_special
//
//  Created by Tim Duncan on 2020/12/8.
//

#import "CustomAnnotationView.h"
#import "NSString+Color.h"
@implementation CustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected) {
        
        if (self.calloutView == nil) {
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 80, 38)];
            
            if (_model.title.length == 0) {
                self.calloutView.frame = CGRectMake(0, 0, 0, 0);
            }else{
                self.calloutView.frame = CGRectMake(0, 0, 80, 38);
            }
            
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                       -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        self.calloutView.model = _model;
        self.calloutView.titleLabel.text = _model.title;
        self.calloutView.titleLabel.textColor = [_model.titleColor hexStringToColor];
        [self addSubview:self.calloutView];
        
    }else{
//        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
 
    return inside;
}

#pragma mark - Life Cycle
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.model=((MarkerAnnotation *) annotation).markerOptions;
    }
    return self;
}


@end
