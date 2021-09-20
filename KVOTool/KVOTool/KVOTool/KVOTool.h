//
//  KVOTool.h
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//observer: 谁在观察; object:被观察的对象; change:修改的信息
typedef void(^KVOCallBackBlock)(id observer, id object, NSDictionary *change);


@interface KVOTool : NSObject

// 一般情况下,是由VC发起观察,观察某个Model/View的属性改变,
// 使用下面方法,会通过KVOTool的实例发起观察,然后把变化通过回调告诉给VC,
// 优势: 1.VC添加观察者和通知回调在一起,方便查阅; 2.无需管理移除逻辑

/// 添加观察方法
/// @param observeObject 被观察的对象
/// @param keyPath 被观察对象的属性
/// @param block 回调函数
- (void)observeObject:(id)observeObject keyPaths:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(KVOCallBackBlock)block;

/// 移除观察
/// @param observeObject 被观察的对象
/// @param keyPath 被观察对象的属性
- (void)removeObserverObject:(id)observeObject forKeyPath:(NSString *)keyPath;

/// 移除观察所有观察, 在dealloc中会自动调用
- (void)removeAllObserverObject;

@end

NS_ASSUME_NONNULL_END
