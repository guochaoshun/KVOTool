//
//  Person.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

- (void)dealloc {
    NSLog(@"%s %@",__func__, object_getClass(self));
}

@end
