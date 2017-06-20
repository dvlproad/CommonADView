//
//  CommonADView.m
//  CommonADViewDemo
//
//  Created by lichq on 7/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonADView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+GestureRecognizer.h"

@interface CommonADView ()

@property (nonatomic, strong) UIView *containerView;

@end


@implementation CommonADView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{    //使用xib的时候，调用的控件初始化方法
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
    
}


- (void)commonInit {
    [self setupScrollView];
    [self addPageControl];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollView);
        make.top.bottom.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView.mas_width).mas_offset(0);
        make.height.mas_equalTo(self.scrollView.mas_height).mas_offset(1);
    }];
    
    
    self.scrollView.delegate = self;   //设置委托
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
}


- (void)addPageControl{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    //在不设置pageControl的width时，其会通过之后的numberOfPages自动设置合适的宽。所以有此技巧的话，我们可以省去计算它的宽
    
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    //self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
}


- (void)addTimerWithTimeInterval:(CGFloat)timeInterval{   //定时器 循环
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [timer fire];   //[timer invalidate];
}


#pragma mark - 注意:当使用xib的时候，如果再在xib上的scrollView上添加新xib控件，如Label，则会导致ScrollView无法移动，解决方法：将原本的ContentSize设置从viewDidLoad方法中调到viewDidAppear方法中。
- (void)setViewWithImages:(NSArray *)m_images direction:(NSInteger)direction{
    if (m_images.count == 1) {
        [self.scrollView setScrollEnabled:NO];
        [self.pageControl setAlpha:0];
    }else{
        [self.scrollView setScrollEnabled:YES];
        [self.pageControl setAlpha:1];
    }
    adImageNameArray = m_images;
    self.m_direction = direction;
    
#pragma mark 在头添加最后一页，在尾添加第一页，以用来循环  原理：4-[1-2-3-4]-1
    NSMutableArray *images = [[NSMutableArray alloc]init];
    [images addObject:adImageNameArray[adImageNameArray.count-1]];
    [images addObjectsFromArray:adImageNameArray];
    [images addObject:adImageNameArray[0]];
    
    
    self.pageControl.numberOfPages = adImageNameArray.count;
    
    
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
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
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
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
                imageV.tag = i;
                [self addImageView:imageV withImagePath:images[i]];
            }
            
            self.pageControl.transform = CGAffineTransformRotate(self.pageControl.transform, M_PI/2);//竖直
            break;
        }
        default:
            break;
    }
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.scrollView.mas_width).multipliedBy(images.count).mas_offset(1);
        make.height.mas_equalTo(self.scrollView.mas_height).multipliedBy(1).mas_offset(0);
    }];
    
    [self.scrollView setContentOffset:svContentOffset];
    [self.scrollView scrollRectToVisible:svRectToVisible animated:NO];
    [self.pageControl setCenter:pageControlCenter];

}




- (void)addImageView:(UIImageView *)imageV withImagePath:(NSString *)imagePath{ //or imageUrl
    [imageV addTapGestureWithTarget:self mSEL:@selector(imageViewClick:)];
    [self.scrollView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView).mas_equalTo(0);
    }];
    
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
            self.pageControl.currentPage = page;
            
            break;
        }
        case eAdViewDirectionRight:{
            CGFloat svHeight = self.frame.size.height;
            int page = floor( (scrollView.contentOffset.y - svHeight/(adImageNameArray.count+2)) /svHeight) + 1;
            page --;  //由于默认从第二张开始。所以如果算出来如果是第二张，其实是第一页，所以要减去一页
            self.pageControl.currentPage = page;
            
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
    
    NSInteger page = self.pageControl.currentPage;
    
    switch (self.m_direction) {
        case eAdViewDirectionDown:{
            [self.scrollView scrollRectToVisible:CGRectMake(svWidth * (page+1),0,svWidth,svHeight) animated:NO];
            
            break;
        }
        case eAdViewDirectionRight:{
            [self.scrollView scrollRectToVisible:CGRectMake(0,svHeight * (page+1),svWidth,svHeight) animated:NO];
            
            break;
        }
        default:
            break;
    }
}



#pragma mark - 定时器 绑定的方法
- (void)runTimePage{
    NSInteger page = self.pageControl.currentPage;
    page++;
    page = page == adImageNameArray.count ? 0 : page ;
    self.pageControl.currentPage = page;
    [self turnPage];
}

#pragma mark - addSubView
- (void)cj_makeView:(UIView *)superView addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [superView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeLeft   //left
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:edgeInsets.left]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:edgeInsets.right]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeTop    //top
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:edgeInsets.top]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeBottom //bottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:edgeInsets.bottom]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
