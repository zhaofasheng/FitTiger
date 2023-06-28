//
//  NoticeChangePiPeiLikeController.m
//  NoticeXi
//
//  Created by li lei on 2019/5/28.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangePiPeiLikeController.h"
#import "NoticeLabelAndSwitchCell.h"
#import "NoticePiPeiFriendListViewController.h"
@interface NoticeChangePiPeiLikeController ()<UIGestureRecognizerDelegate,SwitchChoiceDelegate>
@property (nonatomic, strong) UIButton *choiceButton;
@property (nonatomic, strong) UIButton *choiceButtonback;
@property (nonatomic, strong) UILabel *setL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) NoticePiPeiSet *setModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation NoticeChangePiPeiLikeController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //YES：允许右滑返回  NO：禁止右滑返回
    return YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = self.isPhone?GETTEXTWITE(@"ppph.dh"):GETTEXTWITE(@"ppph.hb");

    [self.tableView registerClass:[NoticeLabelAndSwitchCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell1"];
    
    UIButton *btnb = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-13-112,25/2, 112, 40)];
    [btnb setBackgroundImage:UIImageNamed(@"Ima_about_bt") forState:UIControlStateNormal];
    self.choiceButtonback = btnb;
    
    UIButton *topB = [[UIButton alloc] initWithFrame:btnb.frame];
    [topB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topB setTitle:[NoticeTools isSimpleLau]?@"选择学友":@"選擇学友" forState:UIControlStateNormal];
    topB.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [topB addTarget:self action:@selector(choiceFriendClick) forControlEvents:UIControlEventTouchUpInside];
    self.choiceButton = topB;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-65*2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, DR_SCREEN_WIDTH-30,12)];
    label.font = TWOTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [footView addSubview:label];
    footView.backgroundColor = GetColorWithName(VlistColor);
    label.text = [NoticeTools isSimpleLau]?@"如果对方也设置了你，那么一定是你们俩匹配到哦":@"如果對方也設置了妳，那麽壹定是妳們倆匹配到哦";
    self.tableView.tableFooterView = footView;
    
    UILabel *setL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(label.frame)+80, DR_SCREEN_WIDTH-30,12)];
    setL.font = SEVENTEENTEXTFONTSIZE;
    setL.textColor = GetColorWithName(VDarkTextColor);
    setL.textAlignment = NSTextAlignmentCenter;
    setL.text = [NoticeTools isSimpleLau]?@"未设置优先匹配学友":@"未設置優先匹配学友";
    _setL = setL;
    [footView addSubview:setL];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-164)/2, CGRectGetMaxY(setL.frame)+25, 164, 164)];
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.layer.masksToBounds = YES;
    [footView addSubview:self.iconImageView];
    
    _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.iconImageView.frame)+25, DR_SCREEN_WIDTH-30,13)];
    _nickNameL.font = THRETEENTEXTFONTSIZE;
    _nickNameL.textColor = GetColorWithName(VDarkTextColor);
    _nickNameL.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:_nickNameL];
    
    [self requestData];
}

- (void)requestData{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/matchSetting?matchType=%@",[[NoticeSaveModel getUserInfo]user_id],self.isPhone?@"1":@"2"] Accept:@"application/vnd.shengxi.v3.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
      
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.setModel = [NoticePiPeiSet mj_objectWithKeyValues:dict[@"data"]];
            if (self.setModel.first_avatar_url.length > 8) {
                self.iconImageView.hidden = NO;
                self.nickNameL.hidden = NO;
                NSArray *arr = [self.setModel.first_avatar_url componentsSeparatedByString:@"?"];
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:arr.count?arr[0]:@""]
                                  placeholderImage:GETUIImageNamed(@"img_empty")
                                           options:SDWebImageRefreshCached];
                self.nickNameL.text = self.setModel.first_nick_name;
                self.setL.text = [NoticeTools isSimpleLau]?@"你设置了":@"妳設置了";
            }else{
                self.iconImageView.hidden = YES;
                self.nickNameL.hidden = YES;
                self.setL.text = [NoticeTools isSimpleLau]?@"未设置优先匹配学友":@"未設置優先匹配学友";
            }
            [self.tableView reloadData];
            [self request];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)request{
    [self showHUD];
    self.dataArr = [NSMutableArray new];
    NSString *url = nil;
    url = [NSString stringWithFormat:@"users/%@/friends",[[NoticeSaveModel getUserInfo] user_id]];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyFriends *model = [NoticeMyFriends mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}


- (void)choiceFriendClick{
    if (!self.dataArr.count) {
        [self showToastWithText:@"您还没有室友哦"];
        return;
    }
    if (!self.setModel) {
        self.setModel = [[NoticePiPeiSet alloc] init];
    }
    NoticePiPeiFriendListViewController *ctl = [[NoticePiPeiFriendListViewController alloc] init];
    ctl.hasUserId = self.setModel.first_user_id;
   __weak typeof(self) weakSelf = self;
    ctl.pipeiBlock = ^(NoticeMyFriends * _Nonnull user) {
        weakSelf.setModel.first_user_id = user.user_id;
        weakSelf.setModel.first_avatar_url = user.avatar_url;
        weakSelf.setModel.first_nick_name = user.nick_name;
        [weakSelf refreshSetPipei];
    };
    
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{
    if (!self.setModel) {
        self.setModel = [[NoticePiPeiSet alloc] init];
    }
    
    self.setModel.match_new = [NSString stringWithFormat:@"%d",isOn];
    [self refreshSetPipei];
}

- (void)refreshSetPipei{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.setModel.match_new forKey:@"matchNew"];
    [parm setObject:self.isPhone? @"1":@"2" forKey:@"matchType"];
    [parm setObject:self.setModel.first_user_id?self.setModel.first_user_id:@"0" forKey:@"firstUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/matchSetting",[[NoticeSaveModel getUserInfo]user_id]] Accept:@"application/vnd.shengxi.v3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (self.setModel.first_avatar_url.length > 8) {
                self.iconImageView.hidden = NO;
                self.nickNameL.hidden = NO;
                NSArray *arr = [self.setModel.first_avatar_url componentsSeparatedByString:@"?"];
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:arr.count?arr[0]:@""]
                                      placeholderImage:GETUIImageNamed(@"img_empty")
                                               options:SDWebImageRefreshCached];
                self.nickNameL.text = self.setModel.first_nick_name;
                self.setL.text = [NoticeTools isSimpleLau]?@"你设置了":@"妳設置了";
            }else{
                self.iconImageView.hidden = YES;
                self.nickNameL.hidden = YES;
                self.setL.text = [NoticeTools isSimpleLau]?@"未设置优先匹配学友":@"未設置優先匹配学友";
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeLabelAndSwitchCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.mainL.text = [NoticeTools isSimpleLau]?@"匹配沒有匹配过的人":@"匹配沒有匹配過的人";
        cell2.choiceTag = indexPath.row;
        cell2.choiceSection = indexPath.section;
        cell2.delegate = self;
        cell2.switchButton.on = [self.setModel.match_new boolValue];
        return cell2;
    }else{
        NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.mainL.text = [NoticeTools isSimpleLau]?@"优先匹配一名学友:":@"優先匹配壹名学友:";
        [self.choiceButtonback removeFromSuperview];
        [cell.contentView addSubview:self.choiceButtonback];
        [self.choiceButton removeFromSuperview];
        [cell.contentView addSubview:self.choiceButton];
        cell.subImageV.hidden = YES;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

@end
