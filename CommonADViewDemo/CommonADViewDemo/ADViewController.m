//
//  ADViewController.m
//  CommonADViewDemo
//
//  Created by lichaoqian on 17/6/20.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *images = @[@"http://img.newyx.net/news_img/201306/20/1371714170_1812223777.gif",
                        @"http://f10.topitme.com/l129/101294861836acc143.jpg",
                        @"http://i10.topitme.com/l113/1011344257aa5d1add.jpg",
                        @"http://f10.topitme.com/l056/10056468227b430444.jpg",
                        @"http://f10.topitme.com/l/201011/07/12891369027110.jpg",
                        [[NSBundle mainBundle] pathForResource:@"ad1" ofType:@"png"]
                        ];
    [self.commonADView setDelegate:self];
    [self.commonADView addTimerWithTimeInterval:2.0]; //option
    [self.commonADView setViewWithImages:images direction:eAdViewDirectionDown];
}

- (void)commonAdView_setImageView:(UIImageView *)imageV withImagePath:(NSString *)imagePath{
    if ([imagePath hasPrefix:@"http"] == YES) {
        NSString *placeholderImagePath = [[NSBundle mainBundle] pathForResource:@"downloading.png" ofType:nil];
        UIImage *placeholderImage = [UIImage imageWithContentsOfFile:placeholderImagePath];
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        [imageV sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
    }else{
        imageV.image = [UIImage imageWithContentsOfFile:imagePath];
    }
}

- (void)commonAdView_didSelectedIndex:(NSInteger)index{
    NSLog(@"index = %d", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
