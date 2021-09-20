//
//  KVOInfo.h
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import <Foundation/Foundation.h>
#import "KVOTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface KVOInfo : NSObject

@property (nonatomic, strong) id observeObject;

@property (nonatomic, copy) NSString *keyPath;

@property (nonatomic, copy) KVOCallBackBlock callBackBlock;

@end

NS_ASSUME_NONNULL_END
