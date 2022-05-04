//
//  FourViewController.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/9/20.
//

#import "FourViewController.h"
#import "NSObject+FBKVOController.h"


@interface FourViewController ()

@property (nonatomic, strong) UIScrollView *currScrollView;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 监听这个值, 不移除会crash
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(10, 100, 90, 90)];
    tableView1.contentSize = CGSizeMake(100, 1000);
    tableView1.tag = 100;
    tableView1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tableView1];
    self.currScrollView = tableView1;


    [self.KVOController observe:self.currScrollView keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {

        NSLog(@"KVOController:%@ %@ %@",observer,object,change);
        NSLog(@"旧值是：%@", change[NSKeyValueChangeOldKey]);
        NSLog(@"新值是：%@", change[NSKeyValueChangeNewKey]);

    }];

    // 重复添加测试
    [self.KVOController observe:self.currScrollView keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"111-- ");
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"移除观察者,重复调用也不会crash");
        [self.KVOController unobserve:self.currScrollView keyPath:@"contentOffset"];
        [self.KVOController unobserve:self.currScrollView keyPath:@"contentOffset"];
        [self.KVOController unobserve:self.currScrollView keyPath:@"contentOffset"];

    });

}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


@end
