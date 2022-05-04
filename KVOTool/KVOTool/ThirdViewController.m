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

@property (nonatomic, strong) UIScrollView *currScrollView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // 监听这个值, 不移除会crash
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(10, 100, 90, 90)];
    tableView1.contentSize = CGSizeMake(100, 1000);
    tableView1.tag = 100;
    tableView1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tableView1];
    self.currScrollView = tableView1;


    [self.kvoTool observeObject:self.currScrollView keyPaths:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nonnull observer, id  _Nonnull object, NSDictionary * _Nonnull change) {

        NSLog(@"KVOTool:%@ %@ %@",observer,object,change);
        NSLog(@"旧值是：%@", change[NSKeyValueChangeOldKey]);
        NSLog(@"新值是：%@", change[NSKeyValueChangeNewKey]);
    }];
    // 重复添加同一对象的同一个keyPath不会执行,做了重复添加的判断
    [self.kvoTool observeObject:self.currScrollView keyPaths:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nonnull observer, id  _Nonnull object, NSDictionary * _Nonnull change) {

        NSLog(@"KVOTool:%@ %@ %@",observer,object,change);
        NSLog(@"旧值是：%@", change[NSKeyValueChangeOldKey]);
        NSLog(@"新值是：%@", change[NSKeyValueChangeNewKey]);
    }];
    [self.kvoTool observeObject:self.currScrollView keyPaths:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nonnull observer, id  _Nonnull object, NSDictionary * _Nonnull change) {

        NSLog(@"KVOTool:%@ %@ %@",observer,object,change);
        NSLog(@"旧值是：%@", change[NSKeyValueChangeOldKey]);
        NSLog(@"新值是：%@", change[NSKeyValueChangeNewKey]);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"移除观察者,重复调用也不会crash");
        [self.kvoTool removeObserverObject:self.currScrollView forKeyPath:@"contentOffset"];
        [self.kvoTool removeObserverObject:self.currScrollView forKeyPath:@"contentOffset"];
        [self.kvoTool removeObserverObject:self.currScrollView forKeyPath:@"contentOffset"];

    });


}

- (void)dealloc {
    // 不移除也不会crash
    NSLog(@"%s",__func__);
}

@end
