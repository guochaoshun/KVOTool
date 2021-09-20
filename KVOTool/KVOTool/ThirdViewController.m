//
//  ThirdViewController.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import "ThirdViewController.h"
#import "Person.h"
#import "NSObject+KVOTool.h"

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) Person *person2;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSString *result = @"哀吾生之须臾,\n\
羡长江之无穷";

    __block int i = 0;
    __weak typeof(self) weakSelf = self;
    self.person = [[Person alloc] init];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (i>result.length) {
            [timer invalidate];
            return;
        }
        weakSelf.person.name = [result substringToIndex:i];
        weakSelf.person.age = 10+i;
        i++;
    }];

    
    [self.kvoTool observeObject:self.person keyPaths:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nonnull observer, id  _Nonnull object, NSDictionary * _Nonnull change) {

        NSLog(@"观察name,旧值是：%@,新值是：%@", change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
        weakSelf.label.text = change[NSKeyValueChangeNewKey];
    }];

    [self.kvoTool observeObject:self.person keyPaths:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nonnull observer, id  _Nonnull object, NSDictionary * _Nonnull change) {
        NSLog(@"第一次添加age观察,新值是：%@", change[NSKeyValueChangeNewKey]);
    }];
    
    [self.kvoTool observeObject:self.person keyPaths:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nonnull observer, id  _Nonnull object, NSDictionary * _Nonnull change) {
        NSLog(@"第二次添加age观察,新值是：%@", change[NSKeyValueChangeNewKey]);
    }];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    });

}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
