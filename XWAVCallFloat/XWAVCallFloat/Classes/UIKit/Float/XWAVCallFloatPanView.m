//
//  XWAVCallFloatPanView.m
//  ilinkchat
//
//  Created by 武小武 on 2021/8/12.
//

#import "XWAVCallFloatPanView.h"

#define panSize 90

@implementation XWAVCallFloatPanView


- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(FloatWidth-panSize, FloatHeight/3, panSize, panSize);

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        self.userInteractionEnabled = YES;;
        [self addGestureRecognizer:pan];
        self.alpha = 1.0;
        [XWAVCallFloatTool setView:self Radii:CGSizeMake(17, 17) RoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft shadom:YES];

    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer*)pan{
    CGPoint tpoint = [pan translationInView:self];
    CGPoint center =  self.center;
    center.x += tpoint.x;
    center.y += tpoint.y;
    self.center = center;
    [pan setTranslation:CGPointZero inView:self];
    CGRect rect = self.frame;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [XWAVCallFloatTool setView:self Radii:CGSizeMake(17, 17) RoundingCorners:UIRectCornerAllCorners shadom:YES];
            for (UIImageView *view in self.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    CGRect rect = view.frame;
                    rect.origin.x += 7;
                    view.frame = rect;
                }
            }
        }
            break;

        case UIGestureRecognizerStateEnded:
        {

            if (rect.origin.y < FloatStatusBarHeight) {
                rect.origin.y = FloatStatusBarHeight;
            }else if (rect.origin.y> (FloatIS_iPhoneX?(FloatHeight-rect.size.height-panSize/2):(FloatHeight-rect.size.height))){
                rect.origin.y = FloatIS_iPhoneX?(FloatHeight-rect.size.height-panSize/2):(FloatHeight-rect.size.height);
            }
            
            if (self.frame.origin.x>=FloatWidth/2) {
                rect.origin.x = FloatWidth - rect.size.width;
            }else if (self.frame.origin.x<FloatWidth/2){
                rect.origin.x = 0;
            }
        }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = rect;
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (self.frame.origin.x>=FloatWidth/2) {
                [XWAVCallFloatTool setView:self Radii:CGSizeMake(17, 17) RoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft shadom:YES];
                for (UIImageView *view in self.subviews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        CGRect rect = view.frame;
                        rect.origin.x -= 7;
                        view.frame = rect;
                    }
                }
            }else if (self.frame.origin.x<FloatWidth/2){
                [XWAVCallFloatTool setView:self Radii:CGSizeMake(17, 17) RoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight shadom:YES];
                for (UIImageView *view in self.subviews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        CGRect rect = view.frame;
                        rect.origin.x -= 7;
                        view.frame = rect;
                    }
                }
            }
            
        }
    }];
}

//更新圆形图案 最大5个图案
- (void)updateBall:(NSCache*)cache withKeyArr:(NSArray*)keyArr{
    NSInteger normalCount = 0;
    for (UIImageView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
            normalCount+=1;
        }
    }
    //显示的图案数组
    NSMutableArray *data = [NSMutableArray new];
    for (NSString *key in keyArr) {
        NSDictionary *dic = [cache objectForKey:key];
        if (![dic objectForKey:@"hide"]||![[dic objectForKey:@"hide"] boolValue]) {
            [data addObject:key];
        }
    }

   NSDictionary *scaleDic = @{
        @(1):@(1.0),
        @(2):@(0.5),
        @(3):@(0.38),
        @(4):@(0.35),
        @(5):@(0.30),
    };
    CGFloat scale = 0.7;
    scale *= [scaleDic[@(data.count)] floatValue];
    CGFloat height = scale*panSize;
    CGFloat width = scale*panSize;
    
    NSDictionary *dic = @{
        @(1):@[
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize*0.15, panSize*0.15, width, height)],
                    @"cornerRadius":@(13)
                }
        ],
        @(2):@[
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize*scale-panSize/6, panSize*scale , width, height)],
                    @"pathAngle":@(M_PI_4)
                },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize*scale-panSize/6+panSize*scale-4, panSize*scale , width, height)],
                    @"cornerRadius":@(13)
                }
        ],
        @(3):@[
              @{
                @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale/2, panSize*scale, width, height)],
                @"pathAngle":@(M_PI_4),
                @"toValue":@(M_PI_2+M_PI_4)
              },
              @{
                @"frame":[NSValue valueWithCGRect:CGRectMake(panSize*scale,panSize*scale  + height -4, width, height)],
                @"pathAngle":@(M_PI_4),
                @"toValue":@(M_PI*2),
                @"fromValue":@(M_PI)
              },
              @{
                @"frame":[NSValue valueWithCGRect:CGRectMake(panSize*scale +width  -2, panSize*scale + height -4, width, height)],
                @"pathAngle":@(M_PI_4),
                @"toValue":@(-M_PI_2-M_PI_4)
                },
        ],
        @(4):@[
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale/2, panSize*scale , width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(M_PI_2+M_PI_4)
                },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale,panSize*scale + height-5, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(M_PI_4),
                },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale + width +2, panSize*scale + height-7, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(-M_PI_2-M_PI_4)
                    },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale/2+2, panSize*scale  + height*2 -7-5, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(-M_PI_4)
                },
        ],
        @(5):@[

                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale/2, panSize*scale, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(M_PI_2+M_PI_4),
                    @"controlPoint":[NSValue valueWithCGPoint:CGPointMake(width/3, height/3)]
                },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale/2-panSize*scale/2,panSize*scale + height -5, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(M_PI_4+M_PI_4/2),
                    @"controlPoint":[NSValue valueWithCGPoint:CGPointMake(width/3, height/3)]
                },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2 +3 ,panSize*scale + height -5 -2, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(-M_PI_2-M_PI_4),
                    @"controlPoint":[NSValue valueWithCGPoint:CGPointMake(width/3, height/3)]
                    },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale+3, panSize*scale + height*2 -5 -2 -1, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(2*M_PI),
                    @"fromValue":@(M_PI),
                    @"controlPoint":[NSValue valueWithCGPoint:CGPointMake(width/3, height/3)]
                },
                @{
                    @"frame":[NSValue valueWithCGRect:CGRectMake(panSize/2-panSize*scale+3 + width -2,  panSize*scale + height*2 -5 -2 -1-1, width, height)],
                    @"pathAngle":@(M_PI_4),
                    @"toValue":@(-M_PI_2/3-M_PI_4),
                    @"controlPoint":[NSValue valueWithCGPoint:CGPointMake(width/3, height/3)]
                },
        ],
    };
    
    NSArray *config = dic[@(data.count)];
    
    NSMutableArray *imageArr = [NSMutableArray new];
    for (NSString *key in data) {
        UIImageView *image = [UIImageView new];
        image.backgroundColor = UIColor.whiteColor;
        image.layer.masksToBounds = YES;
        [imageArr addObject:image];
        [self addSubview:image];
        [self bringSubviewToFront:image];
        
        // 通话的图标
        NSBundle *bundle =  [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XWAVCallFloatPanView class]] pathForResource:@"XWAVCallFloat" ofType:@"bundle"]];
        NSString *path = [bundle pathForResource:@"icon_voice_phone" ofType:@"png"];
        
        UIImageView *typeImageView = [[UIImageView alloc] init];
        typeImageView.image = [UIImage imageWithContentsOfFile:path];
        typeImageView.frame = CGRectMake((63-19)/2.0, 13, 19, 19);
        [image addSubview:typeImageView];
        
        // 通话的时长
        UILabel *timeLB = [[UILabel alloc] init];
        timeLB.frame = CGRectMake(0, CGRectGetMaxY(typeImageView.frame), width, 32);
        timeLB.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"12:24" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:117/255.0 green:111/255.0 blue:243/255.0 alpha:1.0]}];
        timeLB.attributedText = string;
        [image addSubview:timeLB];
    }
    
    CFTimeInterval time = ((data.count == normalCount)?0.01:1);
    
    for (int i = 0; i<imageArr.count; i++) {
        UIImageView *image = imageArr[i];
        NSDictionary *frameDic = config[i];
        image.frame = [frameDic[@"frame"] CGRectValue];
        if (frameDic[@"cornerRadius"]) {
            image.layer.cornerRadius = [frameDic[@"cornerRadius"] floatValue];
        }
        if (frameDic[@"pathAngle"]) {
            CGPoint point = [frameDic[@"controlPoint"] CGPointValue];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = [self getPathWithRadius:13 center:CGPointMake(image.frame.size.width/2, image.frame.size.height/2) angle:[frameDic[@"pathAngle"] doubleValue] controlPoint:point].CGPath;
            layer.frame = image.bounds;
            if (frameDic[@"toValue"]) {
                double toValue = [frameDic[@"toValue"] doubleValue];
                double fromValue =  [frameDic[@"fromValue"] doubleValue];
                [layer addAnimation:[self getAnimationWithValue:toValue fromValue:fromValue duration:time] forKey:nil];
            }
            image.layer.mask = layer;
            
        }
    }
}

//获取扇形
- (UIBezierPath*)getPathWithRadius:(CGFloat)radio center:(CGPoint)centerPoint angle:(double)angle controlPoint:(CGPoint)controlPoint{
    if (controlPoint.x == 0&&controlPoint.y == 0) {
        controlPoint = centerPoint;
    }
    UIBezierPath *otherPath = [UIBezierPath bezierPath];
    CGFloat line = cos(angle)*radio;
    [otherPath moveToPoint:CGPointMake(centerPoint.x+line,centerPoint.y-line)];
    [otherPath addQuadCurveToPoint:CGPointMake(centerPoint.x+line, line+centerPoint.y) controlPoint:CGPointMake(controlPoint.x, centerPoint.y)];
    [otherPath addArcWithCenter:centerPoint radius:radio startAngle:angle endAngle:2*M_PI- angle clockwise:YES];

    return otherPath;
    
}

//动画
- (CABasicAnimation*)getAnimationWithValue:(double)value fromValue:(double)fromValue duration:(CFTimeInterval)duration{
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    if (fromValue) {
        an.fromValue = @(fromValue);
    }
    an.toValue = @(value);
    an.removedOnCompletion = NO;
    an.fillMode = kCAFillModeForwards;
    an.duration = duration;
    return an;
}


//背景点击 关闭
- (void)effectViewAction{
    self.hidden = NO;
}

- (void)dealloc{
    
}

@end
