//
//  SecondViewController.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (nonatomic, strong) UIScrollView *currScrollView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    // 监听这个值, 不移除会crash
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(10, 100, 90, 90)];
    tableView1.contentSize = CGSizeMake(100, 1000);
    tableView1.tag = 100;
    tableView1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tableView1];
    self.currScrollView = tableView1;
    // 系统方法, dealloc 中不移除会crash
    [self.currScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];



}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change: %@",change);
    NSLog(@"旧值是：%@", change[NSKeyValueChangeOldKey]);
    NSLog(@"新值是：%@", change[NSKeyValueChangeNewKey]);

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.backgroundColor = color;
}

- (void)dealloc {
#pragma mark 系统的KVO不移除肯定会crash, 必须加上这个才能避免crash
//    [self.currScrollView removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"%s",__func__);
}


@end

/*
继续测试还发现某些类的某些属性不移除监听也不会crash, 比如监听下面4个属性, 在dealloc中不调用移除操作也不会crash, 可能系统有补救策略.
self.currScrollView.contentSize,  系统类的结构体属性
self.view.backgroundColor,  系统类的对象属性
self.currScrollView.frame  系统类的结构体属性
self.person.name  自建类的对象属性

而self.currScrollView.contentOffset 在dealloc中不调用取消观察者, 则必定会crash,
有点搞不懂系统的机制是什么? 什么情况有能补救? 搜索资料也未找到系统提供的文档.
所以测试都以self.currScrollView.contentOffset为例,能100%复现crash,才能验证防护效果

作为开发者, 能做的就是保持注册和取消成对出现, 不要过于依赖系统的补救.
 */
