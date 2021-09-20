//
//  SecondViewController.m
//  KVOTool
//
//  Created by 郭朝顺 on 2021/8/30.
//

#import "SecondViewController.h"
#import "Person.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (nonatomic, strong) Person *person;

@end

@implementation SecondViewController

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
        i++;
    }];

    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.person && [keyPath isEqualToString:@"name"]) {
        NSLog(@"change: %@",change);
        NSLog(@"旧值是：%@", change[NSKeyValueChangeOldKey]);
        NSLog(@"新值是：%@", change[NSKeyValueChangeNewKey]);
        self.secondLabel.text = change[NSKeyValueChangeNewKey];
    }
}

- (void)dealloc {
    // iOS9之后,不移除也不会有问题了
    [self.person removeObserver:self forKeyPath:@"name"];
    NSLog(@"%s",__func__);
}


@end
