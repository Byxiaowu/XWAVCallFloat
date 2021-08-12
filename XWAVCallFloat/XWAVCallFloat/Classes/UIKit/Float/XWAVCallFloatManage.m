//
//  XWAVCallFloatManage.m
//  ilinkchat
//
//  Created by 武小武 on 2021/8/12.
//

#import "XWAVCallFloatManage.h"
#import <UIKit/UIFeedbackGenerator.h>

static XWAVCallFloatManage* floatManage = nil;

@interface XWAVCallFloatManage ()<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, XWAVCallFloatDelegate>

@property(nonatomic,strong)NSMutableDictionary *reginerVCConfig;     //注册的可加入悬浮的控制器配置
@property(nonatomic,strong)NSMutableArray *reginerVCName;            //注册的可加入悬浮的控制器classname
@property(nonatomic,strong)CADisplayLink *link;                      //定时器
@property(nonatomic,strong)XWAVCallFloatPanView *panView;            //悬浮拖动视图
@property(nonatomic,strong)UIViewController *nowVC;                  //当前拖动的VC
@property(nonatomic,strong)NSCache *cache;                           //缓存控制器
@property(nonatomic,strong)NSMutableArray *cacheKey;                 //缓存控制器中的key 用于获取全部缓存
@end

@implementation XWAVCallFloatManage

//单例
+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        floatManage = [[super allocWithZone:NULL] init] ;
        UIViewController *currentVC = [XWAVCallFloatTool getCurrentVC];
        currentVC.navigationController.delegate = floatManage;
        currentVC.navigationController.interactivePopGestureRecognizer.delegate = floatManage;
    });
    
    return floatManage ;
}

//注册响应的controller
- (void)registerControllers:(NSArray*)controllers{
    for (id dic in controllers) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self.reginerVCConfig setObject:dic forKey:dic[@"controllerName"]];
            [self.reginerVCName addObject:dic[@"controllerName"]];
        }else if ([dic isKindOfClass:[NSString class]]) {
            [self.reginerVCConfig setObject:@{@"controllerName":dic} forKey:dic];
            [self.reginerVCName addObject:dic];
        }
    }
}
- (NSMutableArray *)getControllerCacheKey
{
    return self.cacheKey;
}

- (void)addControllers:(UIViewController *)viewController
{
    self.nowVC = viewController;
    NSString *key = [self getKey:viewController];
    
    if (![self.cache objectForKey:key]) {
        NSMutableDictionary *mdic = [NSMutableDictionary new];
        [mdic setObject:viewController forKey:@"controller"];
        [mdic setObject:key forKey:@"key"];
        if ([self.reginerVCConfig objectForKey:NSStringFromClass([self.nowVC class])]) {
            NSDictionary *dic = [self.reginerVCConfig objectForKey:NSStringFromClass([self.nowVC class])];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [mdic setObject:obj forKey:key];
            }];
        }
        [self.cache setObject:mdic forKey:key];
        [self.cacheKey addObject:key];
    }


    if ([self.cacheKey indexOfObject:key] == NSNotFound) {
        NSInteger count = 0;
        for (NSString *tmpKey in self.cacheKey) {
             NSDictionary *dic = [self.cache objectForKey:tmpKey];
             NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            if (mdic[@"hide"]&& [mdic[@"hide"] boolValue]) {
                count+=1;
                [mdic setValue:@(NO) forKey:@"hide"];
            }
            [self.cache setObject:[NSDictionary dictionaryWithDictionary:mdic] forKey:tmpKey];
        }
        if (count) {
            if ([faloatWindow.subviews indexOfObject:self.panView]==NSNotFound) {
                [faloatWindow addSubview:self.panView];
                self.panView.deleagte = self;
            }
            [self.panView updateBall:self.cache withKeyArr:self.cacheKey];
        }
    }
    NSLog(@"ViewController---%p",viewController);
}
- (void)addFloat:(NSString *)controllerKey
{
    if ([[faloatWindow subviews] indexOfObject:self.panView] == NSNotFound) {
        [faloatWindow addSubview:self.panView];
        self.panView.deleagte = self;
    }
    for (NSString *tmpKey in self.cacheKey) {
        NSDictionary *dic = [self.cache objectForKey:tmpKey];
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([tmpKey isEqualToString:controllerKey]) {
            [mdic setValue:@(NO) forKey:@"hide"];
        }
        NSDictionary *temDic = (NSDictionary *)mdic;
        [self.cache setObject:temDic forKey:tmpKey];
    }
    if ([self.cacheKey indexOfObject:controllerKey] != NSNotFound) {
        [self.panView updateBall:self.cache withKeyArr:self.cacheKey];
    }
    
    
}
//浮动视图点击方法
- (void)panViewTapAction:(UITapGestureRecognizer*)tap{
//    [self.panView showData:self.cache withKeyArr:self.cacheKey];
    NSMutableArray *data = [NSMutableArray new];
    for (NSString *key in self.cacheKey) {
        NSDictionary *dic = [self.cache objectForKey:key];
         if (![dic objectForKey:@"hide"]||![[dic objectForKey:@"hide"] boolValue]) {
            [data addObject:[self.cache objectForKey:key]];
        }
    }
    // 数据有
    if (data.count > 0) {
        id dic = data[0];
        UIViewController *VC = dic[@"controller"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:VC animated:YES completion:nil];
        [self hideCache:dic[@"key"]];
    }
    
}

#pragma -mark WMZFloatDelegate
- (void)updateCache:(NSString*)key{
    if ([self.cacheKey indexOfObject:key]!=NSNotFound) {
        [self.cacheKey removeObject:key];
        [self.cache removeObjectForKey:key];
        if (self.cacheKey.count == 0) {
            [self.panView effectViewAction];
            [self.panView removeFromSuperview];
            self.panView = nil;
        }
        [self.panView updateBall:self.cache withKeyArr:self.cacheKey];
    }
}

- (void)hideCache:(NSString*)key{
    if ([self.cacheKey indexOfObject:key]!=NSNotFound) {
        NSInteger count = 0;
        for (NSString *tmpKey in self.cacheKey) {
            NSDictionary *dic = [self.cache objectForKey:tmpKey];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            if ([tmpKey isEqualToString:key]) {
                [mdic setValue:@(YES) forKey:@"hide"];
            }else{
                [mdic setValue:@(NO) forKey:@"hide"];
                count+=1;
            }
            NSDictionary *temDic = (NSDictionary *)mdic;
            [self.cache setObject:temDic forKey:tmpKey];
        }
        
        if (count == 0) {
            [self.panView effectViewAction];
            [self.panView removeFromSuperview];
            self.panView = nil;
        }
        
    }
}

- (BOOL)checkCache:(NSString*)key{
    BOOL exist = NO;
    if ([self.cacheKey indexOfObject:key]!=NSNotFound) {
        NSDictionary *dic = [self.cache objectForKey:key];
        if (dic[@"hide"]&&[dic[@"hide"] boolValue]) {
            exist = YES;
        }
    }
    return exist;
}

//获取唯一key 控制器的地址+控制器的className
- (NSString*)getKey:(UIViewController*)vc{
   return [NSString stringWithFormat:@"%@-%p",NSStringFromClass([vc class]),vc];
}


#pragma mark --- lazy
- (NSMutableArray *)reginerVCName{
    if (!_reginerVCName) {
        _reginerVCName = [NSMutableArray new];
    }
    return _reginerVCName;
}

- (NSMutableDictionary *)reginerVCConfig{
    if (!_reginerVCConfig) {
        _reginerVCConfig = [NSMutableDictionary new];
    }
    return _reginerVCConfig;
}

- (XWAVCallFloatPanView *)panView{
    if (!_panView) {
        _panView = [XWAVCallFloatPanView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panViewTapAction:)];
        [_panView addGestureRecognizer:tap];
    }
    return _panView;
}

- (NSMutableArray *)cacheKey{
    if (!_cacheKey) {
        _cacheKey = [NSMutableArray new];
    }
    return _cacheKey;
}

- (NSCache *)cache{
    if (!_cache) {
        _cache = [NSCache new];
        _cache.countLimit = 5;
    }
    return _cache;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [XWAVCallFloatManage shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [XWAVCallFloatManage shareInstance];
}

@end
