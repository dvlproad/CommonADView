//
//  ADViewController.h
//  CommonADViewDemo
//
//  Created by ciyouzen on 7/22/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonADView.h"
#import <UIImageView+WebCache.h>

@interface ADViewController : UIViewController<CommonADViewDelegate>{
    
}
@property(nonatomic, strong) IBOutlet CommonADView *commonADView;

@end
