//
//  FourViewController.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/9/20.
//

#import "FourViewController.h"
#import "NSObject+FBKVOController.h"
#import "Person.h"
#import "School.h"

@interface FourViewController ()

@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) School *school;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *person = [[Person alloc] init];
    self.person = person;
    [self.KVOController observe:person keyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"111-- ");
    }];

    School *school = [[School alloc] init];
    self.school = school;
    [self.KVOController observe:school keyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"222-- ");

    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    self.person.name = touches.anyObject.description;
    self.school.name = touches.anyObject.description;

}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


@end
