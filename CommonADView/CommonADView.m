//
//  CommonADView.m
//  CommonADViewDemo
//
//  Created by lichq on 7/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonADView.h"
#import <UIImageView+WebCache.h>
#import "UIView+GestureRecognizer.h"

@implementation CommonADView
@synthesize delegate;
@synthesize sv;
@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{    //使用xib的时候，调用的控件初始化方法
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeView];
    }
    return self;
    
}


- (void)initializeView{
    [self addScrollView];
    [self addPageControl];
}


- (void)addScrollView{
    CGRect svFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    sv = [[UIScrollView alloc]initWithFrame:svFrame];
    sv.delegate = self;   //设置委托
    
    sv.bounces = YES;
    sv.pagingEnabled = YES;
    sv.userInteractionEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    
    [self addSubview:sv];
}

- (void)addPageControl{
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    //在不设置pageControl的width时，其会通过之后的numberOfPages自动设置合适的宽。所以有此技巧的话，我们可以省去计算它的宽
    
    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    //pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
}


- (void)addTimerWithTimeInterval:(CGFloat)timeInterval{   //定时器 循环
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [timer fire];   //[timer invalidate];
}


#pragma mark - 注意:当使用xib的时候，如果再在xib上的scrollView上添加新xib控件，如Label，则会导致ScrollView无法移动，解决方法：将原本的ContentSize设置从viewDidLoad方法中调到viewDidAppear方法中。
- (void)setViewWithImages:(NSArray *)m_images direction:(NSInteger)direction{
    if (m_images.count == 1) {
        [self.sv setScrollEnabled:NO];
        [self.pageControl setAlpha:0];
    }else{
        [self.sv setScrollEnabled:YES];
        [self.pageControl setAlpha:1];
    }
    adImageNameArray = m_images;
    self.m_direction = direction;
    
#pragma mark 在头添加最后一页，在尾添加第一页，以用来循环  原理：4-[1-2-3-4]-1
    NSMutableArray *images = [[NSMutableArray alloc]init];
    [images addObject:adImageNameArray[adImageNameArray.count-1]];
    [images addObjectsFromArray:adImageNameArray];
    [images addObject:adImageNameArray[0]];
    
    
    pageControl.numberOfPages = adImageNameArray.count;
    
    
    CGSize svContentSize = CGSizeZero;
    CGPoint svContentOffset = CGPointZero;
    CGRect svRectToVisible = CGRectZero;
    
    CGPoint pageControlCenter = CGPointZero;
    
    switch (direction) {
        case eAdViewDirectionDown:  //pageController下方显示(默认)
        {
            svContentSize = CGSizeMake(self.frame.size.width * images.count, self.frame.size.height);
            svContentOffset = CGPointMake(0, 0);
            svRectToVisible = CGRectMake(self.frame.size.width * 1, 0, self.frame.size.width, self.frame.size.height);//初始时显示第一页，由第一页在4-[1-2-3-4]-1中的第二张，所以x值设为width
            pageControlCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height - 20);
            
            for (int i = 0; i < images.count; i++) {
                CGRect imageVFrame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:imageVFrame];
                imageV.tag = i;
                [self addImageView:imageV withImagePath:images[i]];
            }
            
            break;
        }
            
        case eAdViewDirectionRight:{    //竖直显示
            svContentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * images.count);
            svContentOffset = CGPointMake(0, 0);
            svRectToVisible = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height * 1);
            pageControlCenter = CGPointMake(self.frame.size.width - 10, self.frame.size.height/2);
            
            for (int i = 0; i < images.count; i++) {
                CGRect imageVFrame = CGRectMake(0, i * self.frame.size.height, self.frame.size.width, self.frame.size.height);
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:imageVFrame];
                imageV.tag = i;
                [self addImageView:imageV withImagePath:images[i]];
            }
            
            pageControl.transform = CGAffineTransformRotate(pageControl.transform, M_PI/2);//竖直
            break;
        }
        default:
            break;
    }
    
    
    [sv setContentSize:svContentSize];
    [sv setContentOffset:svContentOffset];
    [sv scrollRectToVisible:svRectToVisible animated:NO];
    [pageControl setCenter:pageControlCenter];

}




- (void)addImageView:(UIImageView *)imageV withImagePath:(NSString *)imagePath{ //or imageUrl
    [imageV addTapGestureWithTarget:self mSEL:@selector(imageViewClick:)];
    [sv addSubview:imageV];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonAdView_setImageView:withImagePath:)]) {
        [self.delegate commonAdView_setImageView:imageV withImagePath:imagePath];
    }else{
        NSLog(@"error: you have to implementation");
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;  //获取tap的view
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonAdView_didSelectedIndex:)]) {
        [self.delegate commonAdView_didSelectedIndex:imageV.tag];
    }
}


#pragma mark - ScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (self.m_direction) {
        case eAdViewDirectionDown:{
            CGFloat svWidth = self.frame.size.width;
            int page = floor( (scrollView.contentOffset.x - svWidth/(adImageNameArray.count+2)) /svWidth) + 1;
            page --;  //由于默认从第二张开始。所以如果算出来如果是第二张，其实是第一页，所以要减去一页
            pageControl.currentPage = page;
            
            break;
        }
        case eAdViewDirectionRight:{
            CGFloat svHeight = self.frame.size.height;
            int page = floor( (scrollView.contentOffset.y - svHeight/(adImageNameArray.count+2)) /svHeight) + 1;
            page --;  //由于默认从第二张开始。所以如果算出来如果是第二张，其实是第一页，所以要减去一页
            pageControl.currentPage = page;
            
            break;
        }
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (self.m_direction) {
        case eAdViewDirectionDown:{
            CGFloat svWidth = self.frame.size.width;
            CGFloat svHeight = self.frame.size.height;
            
            int currentPage = floor( (scrollView.contentOffset.x - svWidth/(adImageNameArray.count+2)) /svWidth) + 1;
            //int currentPage_ = (int)self.scrollView.contentOffset.x/pagewidth; // 和上面效果一样
            //NSLog(@"currentPage_==%d",currentPage_);
            if (currentPage==0){    // 序号0其实是4-[1-2-3-4]-1中的4
                [scrollView scrollRectToVisible:CGRectMake(svWidth * adImageNameArray.count, 0, svWidth, svHeight) animated:NO];
            }else if (currentPage==(adImageNameArray.count+1)){// 序号5其实是4-[1-2-3-4]-1中的第1，循环到第一页
                [scrollView scrollRectToVisible:CGRectMake(svWidth, 0, svWidth, svHeight) animated:NO];
            }
            
            break;
        }
        case eAdViewDirectionRight:{
            CGFloat svWidth = self.frame.size.width;
            CGFloat svHeight = self.frame.size.height;
            
            int currentPage = floor( (scrollView.contentOffset.y - svHeight/(adImageNameArray.count+2)) /svHeight) + 1;
            if (currentPage==0){
                [scrollView scrollRectToVisible:CGRectMake(0, svHeight * adImageNameArray.count, svWidth, svHeight) animated:NO];
            }else if (currentPage==(adImageNameArray.count+1)){
                [scrollView scrollRectToVisible:CGRectMake(0, svHeight, svWidth, svHeight) animated:NO];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - pageControl选择器的方法
- (void)turnPage{
    CGFloat svWidth = self.frame.size.width;
    CGFloat svHeight = self.frame.size.height;
    
    int page = pageControl.currentPage;
    
    switch (self.m_direction) {
        case eAdViewDirectionDown:{
            [sv scrollRectToVisible:CGRectMake(svWidth * (page+1),0,svWidth,svHeight) animated:NO];
            
            break;
        }
        case eAdViewDirectionRight:{
            [sv scrollRectToVisible:CGRectMake(0,svHeight * (page+1),svWidth,svHeight) animated:NO];
            
            break;
        }
        default:
            break;
    }
}



#pragma mark - 定时器 绑定的方法
- (void)runTimePage{
    int page = pageControl.currentPage;
    page++;
    page = page == adImageNameArray.count ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
