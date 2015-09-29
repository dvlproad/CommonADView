# CommonADView
简单易用广告控件

##Example
```
Init
NSArray *images = @[@"http://assets.sbnation.com/assets/2512203/dogflops.gif",
@"http://f10.topitme.com/l129/101294861836acc143.jpg",
@"http://i10.topitme.com/l113/1011344257aa5d1add.jpg",
@"http://f10.topitme.com/l056/10056468227b430444.jpg",
@"http://f10.topitme.com/l/201011/07/12891369027110.jpg",
[[NSBundle mainBundle] pathForResource:@"ad1" ofType:@"png"]
];
[self.commonADView setDelegate:self];
[self.commonADView addTimerWithTimeInterval:2.0]; //option
[self.commonADView setViewWithImages:images direction:eAdViewDirectionDown];

Implete Delegate
The method `commonAdView_setImageView: withImagePath:` you should have to impleme it.
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

The method `commonAdView_didSelectedIndex:` you can impleme it dependent on youself.
- (void)commonAdView_didSelectedIndex:(NSInteger)index{
    NSLog(@"index = %d", index);
}


```