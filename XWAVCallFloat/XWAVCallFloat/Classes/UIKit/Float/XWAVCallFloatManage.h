//
//  XWAVCallFloatManage.h
//  ilinkchat
//
//  Created by 武小武 on 2021/8/12.
//

#import <Foundation/Foundation.h>
#import "AVFloat_Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWAVCallFloatManage : NSObject
//单例
+ (instancetype) shareInstance;

//注册响应的controller
- (void)registerControllers:(NSArray*)controllers;
//添加
- (void)addFloat:(NSString *)controllerKey;
//
- (void)addControllers:(UIViewController *)viewController;
//
- (NSMutableArray *)getControllerCacheKey;

@end

NS_ASSUME_NONNULL_END
