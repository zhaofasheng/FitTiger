//
//  NoticeColorChoiceViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeColorChoiceViewController.h"

@interface NoticeColorChoiceViewController ()

@end

@implementation NoticeColorChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.getcolor = [[GetColor alloc]initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20,self.view.frame.size.height-100)];
    [self.view addSubview:self.getcolor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.getcolor runThisMetodWhenViewDidAppear];
}

@end
