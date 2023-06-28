//
//  NoticeBBSMarkController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/18.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSMarkController.h"
#import "NoticeWebViewController.h"
@interface NoticeBBSMarkController ()

@end

@implementation NoticeBBSMarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"被删除内容详情";
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30,70)];
    markL.textColor = GetColorWithName(VMainTextColor);
    markL.font = SIXTEENTEXTFONTSIZE;
    markL.numberOfLines = 0;
    NSString *str = @"这条留言由于违反「声昔舍规」已被系统删除\n请自觉遵守声昔舍规，谢谢你对声昔宿舍的贡献";
    markL.attributedText = [DDHAttributedMode setColorString:str setColor:GetColorWithName(VMainThumeColor) setLengthString:@"「声昔舍规」" beginSize:8];
    
    markL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [markL addGestureRecognizer:tap];
    
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(markL.frame)+15, DR_SCREEN_WIDTH-30,GET_STRHEIGHT(self.content, 16, DR_SCREEN_WIDTH-30))];
    contentL.textColor = GetColorWithName(VDarkTextColor);
    contentL.font = SIXTEENTEXTFONTSIZE;
    contentL.numberOfLines = 0;
    contentL.text = self.content;
    
    [self.view addSubview:markL];
    
    [self.view addSubview:contentL];
}

- (void)tap{
    NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
    NoticeWeb *web = [[NoticeWeb alloc] init];
    web.html_id = @"32";
    webctl.web = web;
    [self.navigationController pushViewController:webctl animated:YES];
}

@end
