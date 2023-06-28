//
//  NoticeNewUserOrderController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewUserOrderController.h"
#import "NoticeNewUserOrderCell.h"
#import <AVFoundation/AVFoundation.h>
#import "NoticePlayerVideoController.h"
#import <AVKit/AVKit.h>

#import "NoticePlayerVideoController.h"
@interface NoticeNewUserOrderController ()

@end

@implementation NoticeNewUserOrderController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NoticeNewUserOrderCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 66;
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"noviceTask/list" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO needMsg:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.dataArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeNewUserModel *model = [NoticeNewUserModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"main.newUserLook"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewUserOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.orderM = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewUserModel *model = self.dataArr[indexPath.row];
    model.hasLook = YES;
    [NoticeComTools setLookMp4:model.mp4Id];
    [self.tableView reloadData];
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEIFNEEDLOOKBUTTON" object:nil];
    
    NoticePlayerVideoController *ctl = [[NoticePlayerVideoController alloc] init];
    ctl.videoUrl = model.video_url;
    [self.navigationController pushViewController:ctl animated:YES];
    
}
@end
