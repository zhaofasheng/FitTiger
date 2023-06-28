//
//  NoticeSuperMangerClickPersongController.m
//  NoticeXi
//
//  Created by li lei on 2023/6/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSuperMangerClickPersongController.h"
#import "UIView+CLSetRect.h"
#import "NoticeTeamManageButtonArrCell.h"
#import "NoticeSCViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeJuBaoBoKeTosatView.h"
@interface NoticeSuperMangerClickPersongController ()
@property (nonatomic, strong) NSArray *buttonArr;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@end

@implementation NoticeSuperMangerClickPersongController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarView.hidden = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    //头像
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88)/2,NAVIGATION_BAR_HEIGHT+40,88, 88)];
    [_iconImageView setAllCorner:44];
    [self.view addSubview:_iconImageView];

    self.markL = [[UILabel alloc] init];
    self.markL.font = ELEVENTEXTFONTSIZE;
    self.markL.textAlignment = NSTextAlignmentCenter;
    self.markL.textColor = [UIColor whiteColor];
    self.markL.layer.cornerRadius = 2;
    self.markL.layer.masksToBounds = YES;
    [self.view addSubview:self.markL];
    
    //昵称
    _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame)+15,DR_SCREEN_WIDTH, 25)];
    _nickNameL.font = EIGHTEENTEXTFONTSIZE;
    _nickNameL.textAlignment = NSTextAlignmentCenter;

    _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.view addSubview:_nickNameL];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:NoticeTeamManageButtonArrCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.scrollEnabled = NO;
    self.tableView.frame =  CGRectMake(0, CGRectGetMaxY(self.nickNameL.frame)+10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-CGRectGetMaxY(self.nickNameL.frame)-10);
    [self requestUserInfo];
    
    if(self.chatModel){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_chatModel.fromUserM.avatar_url]];
        self.nickNameL.text = _chatModel.fromUserM.mass_nick_name;
        if(_chatModel.fromUserM.identity.intValue > 1){
            self.markL.hidden = NO;
            self.markL.text = _chatModel.fromUserM.identity.intValue==2?@"管理员":@"超级管理员";
            CGFloat width = GET_STRWIDTH(self.markL.text, 11, 16)+5;
            self.markL.frame = CGRectMake((DR_SCREEN_WIDTH-width)/2, CGRectGetMaxY(_iconImageView.frame)-16, width, 16);
            self.markL.backgroundColor = [UIColor colorWithHexString:_chatModel.fromUserM.identity.intValue==2? @"#45C2EB":@"#F8D30D"];
        }else{
            self.markL.hidden = YES;
        }
    }
    if(self.person){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_person.avatar_url]];
        self.nickNameL.text = _person.name;
        if(_person.identity.intValue > 1){
            self.markL.hidden = NO;
            self.markL.text = _person.identity.intValue==2?@"管理员":@"超级管理员";
            CGFloat width = GET_STRWIDTH(self.markL.text, 11, 16)+5;
            self.markL.frame = CGRectMake((DR_SCREEN_WIDTH-width)/2, CGRectGetMaxY(_iconImageView.frame)-16, width, 16);
            self.markL.backgroundColor = [UIColor colorWithHexString:_person.identity.intValue==2? @"#45C2EB":@"#F8D30D"];
        }else{
            self.markL.hidden = YES;
        }
    }
    [self.tableView reloadData];
}

- (void)setChatModel:(NoticeTeamChatModel *)chatModel{
    _chatModel = chatModel;
    if(![chatModel.fromUserM.userId isEqualToString:[NoticeTools getuserId]]){
        if(chatModel.fromUserM.identity.intValue > 1){
            self.buttonArr = @[@"查看Ta的个人主页",@"交流",@"移出本社团",@"移出并禁止加入本社团",@"取消管理权限"];
        }else{
            self.buttonArr = @[@"查看Ta的个人主页",@"交流",@"移出本社团",@"移出并禁止加入本社团"];
        }
    }
}

- (void)setPerson:(YYPersonItem *)person{
    _person = person;
    if(![person.userId isEqualToString:[NoticeTools getuserId]]){
        if(person.identity.intValue > 1){
            self.buttonArr = @[@"查看Ta的个人主页",@"交流",@"移出本社团",@"移出并禁止加入本社团",@"取消管理权限"];
        }else{
            self.buttonArr = @[@"查看Ta的个人主页",@"交流",@"移出本社团",@"移出并禁止加入本社团"];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.chatModel?self.chatModel.fromUserM.userId:self.person.userId;
        ctl.isOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }else if (indexPath.row == 1){
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.chatModel?self.chatModel.fromUserM.userId:self.person.userId];
        vc.toUserId = self.chatModel?self.chatModel.fromUserM.userId:self.person.userId;
        vc.lelve = self.userM.levelImgName;
        vc.navigationItem.title = self.userM.nick_name;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (indexPath.row == 4){
        NoticeJuBaoBoKeTosatView *jubaoV = [[NoticeJuBaoBoKeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        jubaoV.titleL.text = @"填写理由";
        jubaoV.plaStr = @"请输入取消管理员权限的理由";
        jubaoV.plaL.text = jubaoV.plaStr;
        [jubaoV showView];
        __weak typeof(self) weakSelf = self;
        jubaoV.jubaoBlock = ^(NSString * _Nonnull content) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.chatModel?self.chatModel.fromUserM.userId:self.person.userId forKey:@"userId"];

            [parm setObject:content forKey:@"reason"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"mass/manager/remove" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [weakSelf showToastWithText:@"已取消对方管理员权限"];
                    weakSelf.buttonArr = @[@"查看Ta的个人主页",@"交流",@"移出本社团",@"移出并禁止加入本社团"];
                    [weakSelf.tableView reloadData];
                    if(weakSelf.cancelManageBlock){
                        weakSelf.cancelManageBlock(self.chatModel?self.chatModel.fromUserM.userId:self.person.userId);
                    }
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        };
    }
    if(self.clickButtonTagBlock){
        self.clickButtonTagBlock(self.buttonArr[indexPath.row]);
    }
}


- (void)requestUserInfo{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.chatModel?self.chatModel.fromUserM.userId:self.person.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.userM = userIn;
        }
        [self hideHUD];
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}


- (void)setButtonArr:(NSArray *)buttonArr{
    _buttonArr = buttonArr;
    CGFloat buttonHeight = 74*buttonArr.count-24;
    self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, (self.tableView.frame.size.height-buttonHeight)/2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTeamManageButtonArrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleL.text = self.buttonArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buttonArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == (self.buttonArr.count-1)){
        return 50;
    }
    return 74;
}


@end
