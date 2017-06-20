//
//  ADViewController.h
//  CommonADViewDemo
//
//  Created by lichaoqian on 17/6/20.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonADView.h"
#import <UIImageView+WebCache.h>

@interface ADViewController : UIViewController<CommonADViewDelegate>{
    
}
@property(nonatomic, strong) IBOutlet CommonADView *commonADView;

@end
