//
//  XWAVCallFloatPanView.h
//  ilinkchat
//
//  Created by 武小武 on 2021/8/12.
//

#import <UIKit/UIKit.h>
#import "AVFloat_Header.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XWAVCallFloatDelegate <NSObject>
//删除cache
- (void)updateCache:(NSString*)key;
//更新cache
- (void)hideCache:(NSString*)key;
//检测缓存是否出现
- (BOOL)checkCache:(NSString*)key;
@end

@interface XWAVCallFloatPanView : UIView
//deleagte
@property(nonatomic,weak) id<XWAVCallFloatDelegate> deleagte;
//更新圆形图案 最大5个图案
- (void)updateBall:(NSCache*)cache withKeyArr:(NSArray*)keyArr;
//背景点击 关闭
- (void)effectViewAction;
@end

NS_ASSUME_NONNULL_END

