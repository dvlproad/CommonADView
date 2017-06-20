//
//  CommonADView.h
//  CommonADViewDemo
//
//  Created by lichq on 7/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum eAdViewDirection{
    eAdViewDirectionDown = 0,
    eAdViewDirectionRight
}AdViewDirection;



@protocol CommonADViewDelegate <NSObject>

@required
- (void)commonAdView_setImageView:(UIImageView *)imageV withImagePath:(NSString *)imagePath;

@optional
- (void)commonAdView_didSelectedIndex:(NSInteger)index;

@end




@interface CommonADView : UIView<UIScrollViewDelegate>{
    NSArray *adImageNameArray;
}
@property (nonatomic, strong) id <CommonADViewDelegate>delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property(nonatomic) NSInteger m_direction;


- (void)setViewWithImages:(NSArray *)m_images direction:(NSInteger)direction;
- (void)addTimerWithTimeInterval:(CGFloat)timeInterval;


@end
