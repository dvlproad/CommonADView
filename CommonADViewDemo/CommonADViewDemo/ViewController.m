//
//  ViewController.m
//  CommonADViewDemo
//
//  Created by lichq on 7/22/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "ADViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)goADViewController:(id)sender {
    ADViewController *viewController = [[ADViewController alloc] initWithNibName:@"ADViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
