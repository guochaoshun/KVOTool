//
//  NSObject+KVOTool.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/9/20.
//

#import "NSObject+KVOTool.h"
#import <objc/message.h>

@implementation NSObject (KVOTool)

- (void)setKvoTool:(KVOTool *)kvoTool {
    objc_setAssociatedObject(self, @selector(kvoTool), kvoTool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KVOTool *)kvoTool {
    id kvoTool = objc_getAssociatedObject(self, @selector(kvoTool));
    // 懒加载
    if (kvoTool == nil) {
      kvoTool = [[KVOTool alloc] init];
      self.kvoTool = kvoTool;
    }
    return kvoTool;
}

@end
