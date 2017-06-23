//
//  CommonADView.h
//  CommonADViewDemo
//
//  Created by ciyouzen on 7/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ADViewDirection) {
    ADViewDirectionHorizontal,  /**< 水平滚动 */
    ADViewDirectionVertical,    /**< 竖直滚动 */
};



@protocol CommonADViewDelegate <NSObject>

@required
- (void)commonAdView_setImageView:(UIImageView *)imageV withImagePath:(NSString *)imagePath;

@optional
- (void)commonAdView_didSelectedIndex:(NSInteger)index;

@end




@interface CommonADView : UIView<UIScrollViewDelegate>{
    
}
@property (nonatomic, strong) id <CommonADViewDelegate>delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) NSInteger currentIndex; /**< 当前是第几页 */

- (void)setViewWithImages:(NSArray *)m_images direction:(ADViewDirection)direction;
- (void)addTimerWithTimeInterval:(CGFloat)timeInterval;

- (void)showPageControl;


@end
