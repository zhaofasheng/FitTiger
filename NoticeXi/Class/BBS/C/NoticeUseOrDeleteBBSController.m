//
//  NoticeUseOrDeleteBBSController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeUseOrDeleteBBSController.h"
#import "NoticeMineViewController.h"
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeSendBBSController.h"
@interface NoticeUseOrDeleteBBSController ()
@property (nonatomic, strong) NoticeBBSDetailHeaderView *headerView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@end

@implementation NoticeUseOrDeleteBBSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height = NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_BAR_HEIGHT, height,height)];
    [backBtn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"btn_nav_back":@"btn_nav_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(height+5,(height-35)/2+STATUS_BAR_HEIGHT,35,35)];
    _iconImageView.layer.cornerRadius = 35/2;
    _iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
    [_iconImageView addGestureRecognizer:iconTap];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:self.bbsModel.userInfo.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    
    _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,STATUS_BAR_HEIGHT, 160,height)];
    _nickNameL.font = THRETEENTEXTFONTSIZE;
    _nickNameL.textColor = GetColorWithName(VMainTextColor);
    _nickNameL.text = self.bbsModel.userInfo.nick_name;
    [self.view addSubview:_nickNameL];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-45, STATUS_BAR_HEIGHT+(height-25)/2, 45, 25)];
    deleteBtn.layer.cornerRadius = 3;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#FC6677"];
    [self.view addSubview:deleteBtn];
    
    UIButton *useBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-45-10-45, STATUS_BAR_HEIGHT+(height-25)/2, 45, 25)];
    useBtn.layer.cornerRadius = 3;
    useBtn.layer.masksToBounds = YES;
    [useBtn setTitle:@"采纳" forState:UIControlStateNormal];
    [useBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    useBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
    [useBtn addTarget:self action:@selector(useClick) forControlEvents:UIControlEventTouchUpInside];
    useBtn.backgroundColor =GetColorWithName(VMainThumeColor);
    [self.view addSubview:useBtn];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.headerView = [[NoticeBBSDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0)];
    self.headerView.bbsModel = self.bbsModel;
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
}



- (void)deleteClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:[NoticeTools getLocalStrWith:@"songList.suredele"] sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:weakSelf.mangagerCode forKey:@"confirmPasswd"];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/contributions/%@",weakSelf.bbsModel.contribution_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    if (weakSelf.managerTypeBlock) {
                        weakSelf.managerTypeBlock(2, @"");
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];

}

- (void)useClick{
    NoticeSendBBSController *ctl = [[NoticeSendBBSController alloc] init];
    ctl.manageCode = self.mangagerCode;
    ctl.isFromCaiNa = YES;
    ctl.bbsM = self.bbsModel;
    __weak typeof(self) weakSelf = self;
    ctl.managerTypeBlock = ^(NSInteger type, NSString * _Nonnull postId) {
        if (weakSelf.managerTypeBlock) {
            weakSelf.managerTypeBlock(type, postId);
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];

}

- (void)userInfoTap{
    if ([self.bbsModel.userInfo.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeMineViewController *ctl = [[NoticeMineViewController alloc] init];
        ctl.isFromOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        
    }else{
        NoticeOtherUserInfoViewController *ctl = [[NoticeOtherUserInfoViewController alloc] init];
        ctl.userId = self.bbsModel.userInfo.userId;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
