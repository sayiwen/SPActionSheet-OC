//
//  SPViewController.m
//  SPActionSheet
//
//  Created by sayiwen on 08/15/2023.
//  Copyright (c) 2023 sayiwen. All rights reserved.
//

#import "SPViewController.h"
#import <SPActionSheet/SPActionSheet.h>

@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
- (IBAction)ShowActionSheet:(id)sender {
    SPActionSheet *actionSheet = [SPActionSheet create:@"title" items:@[@"Hello",@"Test",@"我是最后一个"]];
    actionSheet.onItemClick = ^(SPViewModel * item, NSInteger index) {
        NSLog(@"%@:%@",@(item.viewType),@(index));
    };
    [actionSheet show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
