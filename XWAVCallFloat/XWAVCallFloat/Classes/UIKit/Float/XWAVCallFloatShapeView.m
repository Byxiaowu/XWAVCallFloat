//
//  XWAVCallFloatShapeView.m
//  ilinkchat
//
//  Created by 武小武 on 2021/8/12.
//

#import "XWAVCallFloatShapeView.h"

@implementation XWAVCallFloatShapeView


+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ((CAShapeLayer *)self.layer).fillColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
        ((CAShapeLayer *)self.layer).strokeColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    if (self.rectCorner == UIRectCornerAllCorners) {
         maskPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.bounds.size.height/2 startAngle:0 endAngle:2*M_PI clockwise:YES];;
    }else{
         maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.rectCorner cornerRadii:self.radioSize];
    }
    ((CAShapeLayer *)self.layer).path = maskPath.CGPath;
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    ((CAShapeLayer *)self.layer).fillColor = backgroundColor.CGColor;
}


@end
