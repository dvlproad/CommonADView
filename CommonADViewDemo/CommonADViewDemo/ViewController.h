//
//  ViewController.h
//  CommonADViewDemo
//
//  Created by lichq on 7/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonADView.h"
#import <UIImageView+WebCache.h>

@interface ViewController : UIViewController<CommonADViewDelegate>{
    
}
@property(nonatomic, strong) IBOutlet CommonADView *commonADView;


@end

