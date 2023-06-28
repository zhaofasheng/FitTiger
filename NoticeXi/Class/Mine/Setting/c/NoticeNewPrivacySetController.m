//
//  NoticeNewPrivacySetController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/27.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewPrivacySetController.h"

@interface NoticeNewPrivacySetController ()

@end

@implementation NoticeNewPrivacySetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-65*2-40-BOTTOM_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,25, DR_SCREEN_WIDTH, 12)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = TWOTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [footView addSubview:label];
    
    CGFloat imgHeight =self.type == 1? 305: 332;
    CGFloat imgWidth =self.type == 1? 215: 176;
    
    UIImageView *showImgView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-imgWidth)/2, CGRectGetMaxY(label.frame)+20, imgWidth, imgHeight)];
    if (self.type == 0) {
        
        UIView *navTitleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-90, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        UILabel *titleV = [[UILabel alloc] initWithFrame:CGRectMake((navTitleV.frame.size.width-GET_STRWIDTH(@"封面迷你时光机", 18, 18)-25)/2, 0, GET_STRWIDTH(@"封面迷你时光机", 18, 18), NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        titleV.textAlignment = NSTextAlignmentCenter;
        titleV.textColor = GetColorWithName(VMainTextColor);
        titleV.font = EIGHTEENTEXTFONTSIZE;
        titleV.text = [NoticeTools getTextWithSim:@"封面迷你时光机" fantText:@"封面迷妳時光機"];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleV.frame)+5,(navTitleV.frame.size.height-20)/2, 20, 20)];
        imgV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_fmsgj":@"Image_fmsgjy");
        [navTitleV addSubview:titleV];
        [navTitleV addSubview:imgV];
        self.navigationItem.titleView = navTitleV;
        self.titArr = @[[NoticeTools getTextWithSim:@"仅自己和学友可见" fantText:@"僅自己和学友可見"],[NoticeTools getTextWithSim:@"不是学友也能看见" fantText:@"不是学友也能看見"]];
        
        showImgView.image = UIImageNamed(@"Image_mnsugfs");
        label.text = [NoticeTools getTextWithSim:@"会随机播放时光机中的心情(不含私密心情)" fantText:@"會隨機播放時光機中的心情(不含私密心情)"];
        UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-GET_STRWIDTH(label.text, 12, 12))/2-25,42/2, 20, 20)];
        imgV1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_fmsgj":@"Image_fmsgjy");
        [footView addSubview:imgV1];
        self.tableView.tableFooterView = footView;
        [footView addSubview:showImgView];
    }else if (self.type == 1){
        self.navigationItem.title = [NoticeTools getTextWithSim:@"信息流展示内容" fantText:@"信息流展示內容"];
        showImgView.image = UIImageNamed(@"Image_setxinxil");
        label.text = [NoticeTools getTextWithSim:@"根据你的选择对参观者展示相应信息流" fantText:@"根據妳的選擇對參觀者展示相應信息流"];
        self.tableView.tableFooterView = footView;
        [footView addSubview:showImgView];
        self.titArr = @[[NoticeTools getTextWithSim:@"过往共享心情" fantText:@"過往共享心情"],[NoticeTools getTextWithSim:@"什么都不展示" fantText:@"什麽都不展示"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        if ((self.isOpen && indexPath.row == 1) || (!self.isOpen && indexPath.row == 0)) {
            return;
        }
        [self showHUD];
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setValue:@"moodbook" forKey:@"settingTag"];
        [parm setValue:@"minimachine_visibility" forKey:@"settingName"];
        [parm setValue:indexPath.row == 0?@"1":@"2" forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.openBlock) {
                    self.openBlock(indexPath.row == 0 ? NO:YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else if (self.type == 1){
        if ((self.isOpen && indexPath.row == 0) || (!self.isOpen && indexPath.row == 1)) {
            return;
        }
        [self showHUD];
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setValue:@"moodbook" forKey:@"settingTag"];
        [parm setValue:@"share_voice_visibility" forKey:@"settingName"];
        [parm setValue:indexPath.row == 0?@"2":@"1" forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.openBlock) {
                    self.openBlock(indexPath.row == 0 ? YES:NO);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    cell.subImageV.image = [UIImage imageNamed:@"setGou"];
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-10-15,(65 - 15*33/43)/2, 15, 15*33/43);
    if (self.type == 0) {//迷你时光机
        if (indexPath.row == 0) {
            cell.subImageV.hidden = self.isOpen ? YES:NO;
        }else{
            cell.subImageV.hidden = self.isOpen ? NO:YES;
        }
    }else if (self.type == 1){//信息流
        if (indexPath.row == 0) {
            cell.subImageV.hidden = self.isOpen ? NO:YES;
        }else{
            cell.subImageV.hidden = self.isOpen ? YES:NO;
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    view.backgroundColor = GetColorWithName(VlistColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,300, 40)];
    if (self.type == 0) {
        label.text = [NoticeTools getTextWithSim:@"显示规则" fantText:@"顯示規則"];
    }else if (self.type == 1){
        label.text = [NoticeTools getTextWithSim:@"对参观我心情簿的人展示" fantText:@"對參觀我心情簿的人展示"];
    }
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

@end
