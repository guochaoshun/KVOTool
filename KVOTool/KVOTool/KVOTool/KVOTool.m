//
//  KVOTool.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import "KVOTool.h"
#import "KVOInfo.h"

/**
1.直接用的可变字典,没有加锁,不确定是否需要优化
2.目前使用object地址+keyPath做唯一标识, 如果还想精确点可以加上NSKeyValueObservingOptions,但是觉得没必要,就不加了
3.KVOInfo使用strong引用了observeObject,目前测试可以释放内存,不存在循环应用,
    注意:observeObject不能是持有KVOTool的对象,这样会有循环引用,但是自己观察自己,是不是有点怪,所以这种情况就没处理
 */


@interface KVOTool ()

// 使用object地址+keyPath做key, KVOInfo做value,KVOInfo包含kvo所需全部信息
@property (nonatomic, strong) NSMutableDictionary *dic;

@end


@implementation KVOTool

- (void)observeObject:(id)observeObject keyPaths:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void(^)(id observer, id object, NSDictionary *change))block {

    // 使用observeObject+keyPath作为唯一标识
    NSString *key = [self p_createKeyWithObject:observeObject keyPath:keyPath];
    if (key.length == 0) {
        NSAssert(NO, @"入参不正确, %@ %@",observeObject,keyPath);
        return;
    }
    // 1.防止重复添加观察者
    if ([self.dic objectForKey:key]) {
        NSLog(@"重复添加观察者, %@ %@",observeObject,keyPath);
        return;
    }

    // 2.添加观察者,被观察的对象添加self作为观察者,观察keypath的options变化
    [observeObject addObserver:self forKeyPath:keyPath options:options context:nil];

    // 3.保存信息
    KVOInfo *info = [[KVOInfo alloc] init];
    info.keyPath = keyPath;
    info.callBackBlock = block;
    info.observeObject = observeObject;
    [self.dic setObject:info forKey:key];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    NSString *key = [self p_createKeyWithObject:object keyPath:keyPath];
    KVOInfo *info = [self.dic objectForKey:key];
    if (info) {
        if (info.callBackBlock) {
            info.callBackBlock(self, object, change);
        }
    }

}

/// 移除观察
- (void)removeObserverObject:(id)observeObject forKeyPath:(NSString *)keyPath {
    NSString *key = [self p_createKeyWithObject:observeObject keyPath:keyPath];
    KVOInfo *info = [self.dic objectForKey:key];
    if (info) {
        [info.observeObject removeObserver:self forKeyPath:info.keyPath];
        [self.dic removeObjectForKey:key];
        info = nil;
    }
}

/// 移除观察所有观察, 在dealloc中会自动调用
- (void)removeAllObserverObject {
    for (KVOInfo *info in _dic.allValues) {
        [info.observeObject removeObserver:self forKeyPath:info.keyPath];
    }
}


#pragma mark 私有方法
/// 生成唯一的key, 使用对象的地址+keyPath
- (NSString *)p_createKeyWithObject:(NSObject *)object keyPath:(NSString *)keyPath {
    if (!object) {
        return @"";
    }
    if (!keyPath || keyPath.length == 0) {
        return @"";
    }
    NSString *resultKey = [NSString stringWithFormat:@"KVOTool_%@_%p_%@",[object class],object,keyPath];
    return resultKey;
}

- (NSMutableDictionary *)dic {
    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (void)dealloc {
    [self removeAllObserverObject];
    NSLog(@"%s",__func__);
}

@end
