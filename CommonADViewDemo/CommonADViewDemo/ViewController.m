//
//  ViewController.m
//  CommonADViewDemo
//
//  Created by lichq on 7/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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

@end
