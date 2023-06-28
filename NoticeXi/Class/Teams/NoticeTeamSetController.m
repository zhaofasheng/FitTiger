//
//  NoticeTeamSetController.m
//  NoticeXi
//
//  Created by li lei on 2023/6/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamSetController.h"
#import "UIView+CLSetRect.h"
#import "NoticeTextView.h"
#import "NoticeTeamMemberView.h"
#import "NoticeChangeTeamNickNameView.h"
#import "YYPersonItem.h"
#import "NoticeTeamMemberListController.h"
@interface NoticeTeamSetController ()<NoticeReceveMessageSendMessageDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) NoticeTextView *contentL;
@property (nonatomic, strong) UIImageView *groupImageView;
@property (nonatomic, strong) UILabel *groupNameL;
@property (nonatomic, strong) UIImageView *peopleNumView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) NoticeTeamMemberView *memberView;
@property (nonatomic, strong) NSMutableArray *personArr;
@property (nonatomic, strong) NSMutableArray *syArr;
@property (nonatomic, assign) NSInteger allPersons;
@property (nonatomic, strong) UIView *manageView;

@end

@implementation NoticeTeamSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.hidden = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 250)];
    imageView.image = UIImageNamed(@"setteamhead_img");
    [self.view addSubview:imageView];
    
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.navBarView];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 673+(self.identity.intValue>1?70:0))];
    self.headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = self.headerView.backgroundColor;
    
    //社团信息，规则，人数
    UIView *rulView = [[UIView alloc] initWithFrame:CGRectMake(15, 44, DR_SCREEN_WIDTH-30, 200)];
    rulView.backgroundColor = [UIColor whiteColor];
    [rulView setAllCorner:12];
    [self.headerView addSubview:rulView];
    
    self.groupImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 72, 72)];
    [self.groupImageView setAllCorner:16];
    [self.headerView addSubview:self.groupImageView];
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:self.teamModel.img_url]];
    
    self.groupNameL = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, DR_SCREEN_WIDTH-150, 28)];
    self.groupNameL.font = XGEightBoldFontSize;
    self.groupNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [rulView addSubview:self.groupNameL];
    self.groupNameL.text = self.teamModel.title;
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 64, DR_SCREEN_WIDTH-60, 120)];
    backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [backV setAllCorner:8];
    [rulView addSubview:backV];
    
    self.contentL = [[NoticeTextView alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-80,100)];
    self.contentL.font = THRETEENTEXTFONTSIZE;
    self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    self.contentL.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
    self.contentL.editable = NO;
    [backV addSubview:self.contentL];
    self.contentL.isContent = YES;
    self.contentL.textContainerInset = UIEdgeInsetsMake(10, -5, 0, -5);
    self.contentL.attributedText = [NoticeTools getStringWithLineHight:6 string:self.teamModel.rule];
    
    self.memberView = [[NoticeTeamMemberView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(rulView.frame)+15, DR_SCREEN_WIDTH-30, 140)];
    [self.headerView addSubview:self.memberView];
    self.memberView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(memberViewTap)];
    [self.memberView addGestureRecognizer:tap];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.memberView.frame)+15, DR_SCREEN_WIDTH-30, 54)];
    nameView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [nameView setAllCorner:12];
    [self.headerView addSubview:nameView];

    UILabel *nametitleL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,130, 54)];
    nametitleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    nametitleL.font = XGSIXBoldFontSize;
    nametitleL.text = @"我在本社的昵称";
    [nameView addSubview:nametitleL];
    
    CGFloat nameWidth = GET_STRWIDTH(@"海绵宝宝笑得没心没肺", 14, 54)+10;
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(nameView.frame.size.width-15-24-nameWidth, 0, nameWidth, 54)];
    nameL.font = FOURTHTEENTEXTFONTSIZE;
    nameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    [nameView addSubview:nameL];
    nameL.textAlignment = NSTextAlignmentRight;
    nameL.text = self.teamModel.mass_nick_name;
    self.nameL = nameL;
    
    UIImageView *intImage = [[UIImageView alloc] initWithFrame:CGRectMake(nameView.frame.size.width-15-24, 15, 24, 24)];
    intImage.image = UIImageNamed(@"cellnextbutton");
    [nameView addSubview:intImage];
    intImage.userInteractionEnabled = YES;
    
    nameView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNameTap)];
    [nameView addGestureRecognizer:tap1];
        
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(nameView.frame)+15, DR_SCREEN_WIDTH-30, 54)];
    noticeView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [noticeView setAllCorner:12];
    [self.headerView addSubview:noticeView];

    UILabel *noticetitleL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,130, 54)];
    noticetitleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    noticetitleL.font = XGSIXBoldFontSize;
    noticetitleL.text = @"消息免打扰";
    [noticeView addSubview:noticetitleL];
    
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(noticeView.frame.size.width-15-44,15,44,24)];
    _switchButton.onTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    _switchButton.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _switchButton.tintColor = [UIColor colorWithHexString:@"#8A8F99"];
    [_switchButton addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventValueChanged];
    _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [noticeView addSubview:_switchButton];
    [_switchButton setOn:!self.teamModel.mass_remind.boolValue];
    
    if(self.identity.intValue > 1){
        self.manageView = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(noticeView.frame)+15, DR_SCREEN_WIDTH-30, 54)];
        self.manageView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.manageView setAllCorner:12];
        [self.headerView addSubview:self.manageView];

        UILabel *mantitleL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,130, 54)];
        mantitleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        mantitleL.font = XGSIXBoldFontSize;
        mantitleL.text = @"管理成员";
        [self.manageView addSubview:mantitleL];
        

        UIImageView *intImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.manageView.frame.size.width-15-24, 15, 24, 24)];
        intImage1.image = UIImageNamed(@"cellnextbutton");
        [self.manageView addSubview:intImage1];
        intImage1.userInteractionEnabled = YES;
        
        self.manageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manageTap)];
        [self.manageView addGestureRecognizer:tapm];
    }
    
    UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(35,(self.identity.intValue>1?CGRectGetMaxY(self.manageView.frame): CGRectGetMaxY(noticeView.frame))+55, DR_SCREEN_WIDTH-70, 50)];
    [outBtn setTitle:@"退出社团" forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    outBtn.titleLabel.font = XGEightBoldFontSize;
    [outBtn setAllCorner:25];
    outBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [outBtn addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:outBtn];
    
    self.personArr = [[NSMutableArray alloc] init];
    [self requestPerson];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.memberDelegate = self;
}

- (void)manageTap{
    if(self.identity.intValue < 2){
        [self showToastWithText:@"你已不是管理员身份哦~"];
        return;
    }
    NoticeTeamMemberListController *ctl = [[NoticeTeamMemberListController alloc] init];
    ctl.teamModel = self.teamModel;
    ctl.isMamger = YES;
    ctl.identity = self.identity;
    if(self.personArr.count){
        ctl.personArr = self.personArr;
        ctl.syArr = self.syArr;
    }
 
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)memberViewTap{
    NoticeTeamMemberListController *ctl = [[NoticeTeamMemberListController alloc] init];
    ctl.teamModel = self.teamModel;
    ctl.identity = self.identity;
    if(self.personArr.count){
        ctl.personArr = self.personArr;
        ctl.syArr = self.syArr;
    }
 
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)didReceiveMemberOutOrJoinTeamChat:(NoticeOneToOne *)message{
    if(!message.data){
        return;
    }
    NoticeTeamChatModel *chat = [NoticeTeamChatModel mj_objectWithKeyValues:message.data];
    if(![chat.mass_id isEqualToString:self.teamModel.teamId]){//不是这个社团的，不接收
        return;
    }
    if([message.action isEqualToString:@"memberRemove"] || [message.action isEqualToString:@"memberQuit"]){//移出社团成员
        self.allPersons -= 1;
        [self remvokUserId:chat.to_user_id];
        return;
    }
    
    if ([message.action isEqualToString:@"managerRemove"]) {//管理员身份被取消
        [self mamagerUserId:chat.to_user_id];
        if([chat.to_user_id isEqualToString:[NoticeTools getuserId]]){
            self.identity = @"1";
        }
        return;
    }
    
    if([message.action isEqualToString:@"memberJoin"]){

        [self requestPerson];
    }
}

- (void)mamagerUserId:(NSString *)userId{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                person.identity = @"1";
                break;
            }
        }
    }
    self.memberView.numL.text = [NSString stringWithFormat:@"%ld人",self.allPersons];
}

- (void)remvokUserId:(NSString *)userId{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                [item.personArr removeObject:person];
                break;
            }
        }
    }
    self.memberView.numL.text = [NSString stringWithFormat:@"%ld人",self.allPersons];
}

- (void)requestPerson{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/member/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            NSMutableArray *syArr = [[NSMutableArray alloc] init];
        
            YYPersonItem *allData = [YYPersonItem mj_objectWithKeyValues:dict[@"data"]];
            [self.personArr removeAllObjects];
            if(allData.administrators.count){
                YYPersonItem *adminItem = [[YYPersonItem alloc] init];
                adminItem.title = @"超级管理员";
                [self.personArr addObject:adminItem];
                [syArr addObject:@"管"];
                self.allPersons = 0;
                for (NSDictionary *dic in allData.administrators) {
                    YYPersonItem *personItem = [YYPersonItem mj_objectWithKeyValues:dic];
                    [adminItem.personArr addObject:personItem];
                    self.allPersons++;
                }
            }
   
            for (NSDictionary *dic in allData.members) {
                YYPersonItem *personItem = [YYPersonItem mj_objectWithKeyValues:dic];
                self.allPersons+=personItem.personArr.count;
                [self.personArr addObject:personItem];
                [syArr addObject:personItem.title];
            }
            if(self.personBlock){
                self.personBlock(self.personArr, syArr);
            }
            self.syArr = syArr;
            self.memberView.numL.text = [NSString stringWithFormat:@"%ld人",self.allPersons];
            self.memberView.dataArr = self.personArr;
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)outClick{
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/quit/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            weakSelf.teamModel.is_join = @"0";
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)changeVale:(UISwitch *)switchbutton{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (switchbutton.isOn) {
        [parm setObject:@"0" forKey:@"mass_remind"];
    }else{
        [parm setObject:@"1" forKey:@"mass_remind"];
    }
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/member/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            weakSelf.teamModel.mass_remind = switchbutton.isOn?@"0":@"1";
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)changeNameTap{
    __weak typeof(self) weakSelf = self;
    NoticeChangeTeamNickNameView * nameV = [[NoticeChangeTeamNickNameView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    nameV.titleL.text = @"我在本社的昵称";
    nameV.currentName = self.teamModel.mass_nick_name;
    nameV.closeBtn.hidden = NO;
    [nameV.sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    nameV.sureNameBlock = ^(NSString * _Nonnull name) {
        [weakSelf changeNameWithName:name];
    };
    [nameV showNameView];
}

- (void)changeNameWithName:(NSString *)name{
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:name forKey:@"nick_name"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/member/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            weakSelf.teamModel.mass_nick_name = name;
            weakSelf.nameL.text = name;
            [weakSelf changeNameUserId:[NoticeTools getuserId] name:name];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)changeNameUserId:(NSString *)userId name:(NSString *)name{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                person.mass_nick_name = name;
                if(self.personBlock){
                    self.personBlock(self.personArr, self.syArr);
                }
                break;
            }
        }
    }
    [self.memberView.movieTableView reloadData];
}
@end
