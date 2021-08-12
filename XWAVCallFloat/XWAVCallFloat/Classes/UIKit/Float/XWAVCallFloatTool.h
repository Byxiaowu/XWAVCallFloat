//
//  XWAVCallFloatTool.h
//  ilinkchat
//
//  Created by 武小武 on 2021/8/12.
//

#import <Foundation/Foundation.h>
#import "AVFloat_Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWAVCallFloatTool : NSObject
//获取当前VC
+ (UIViewController *)getCurrentVC;
//圆心到点的距离>?半径
+ (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect;
//设置圆角 单边
+(void)setView:(UIView*)view Radii:(CGSize)size RoundingCorners:(UIRectCorner)rectCorner;
//设置圆角 单边 + 阴影
+(void)setView:(UIView*)view Radii:(CGSize)size RoundingCorners:(UIRectCorner)rectCorner shadom:(BOOL)shadom;
@end

NS_ASSUME_NONNULL_END

