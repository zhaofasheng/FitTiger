//
//  NoticeTuYaChatWithOtherController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTuYaChatWithOtherController.h"
#import "NoticeTuYaChatCell.h"
#import "NoticeDrawShowListController.h"
#import "NoticeAction.h"
#import "NoticeSysMeassageTostView.h"
@interface NoticeTuYaChatWithOtherController ()<NoticeTuYaChatDelegate,NoticeReceveMessageSendMessageDelegate>
@property (nonatomic, strong) NSString *autoId;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL firstIn;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *titleHeadView;
@end

@implementation NoticeTuYaChatWithOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.localdataArr = [NSMutableArray new];
    self.dataArr = [NSMutableArray new];
    self.nolmorLdataArr = [NSMutableArray new];
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"hh.diatuyaduih"];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 100)];
    view.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
    self.headerView = view;
    [self.view addSubview:view];
    
    self.needBackGroundView = YES;
    
    if ([NoticeTools isFirstinclickTUYACenter]) {
        [view addSubview:self.titleHeadView];
        view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 100);
        self.tableView.frame = CGRectMake(0, 100+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-100-NAVIGATION_BAR_HEIGHT);
    }else{
        view.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 44);
        self.tableView.frame = CGRectMake(0, 44+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-44-NAVIGATION_BAR_HEIGHT);
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15-15-9, 44)];
    label.font = THRETEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VMainThumeColor);
    if (!self.drawId) {
        label.text = [NSString stringWithFormat:@"%@ 在 %@ 的作品",self.curentDraw.nick_name,self.curentDraw.createTime];
        if ([NoticeTools getLocalType] == 1) {
            label.text = [NSString stringWithFormat:@"%@ drawing on %@",self.curentDraw.nick_name,self.curentDraw.createTime];
        }
    }else{
        [self requestDetail];
    }
    [view addSubview:label];
    _infoL = label;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTo)];
    UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    tapV.userInteractionEnabled = YES;
    [tapV addGestureRecognizer:tap];
    [view addSubview:tapV];
    
    UIImageView * _subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-20, (44-20)/2, 20, 20)];
    _subImageV.image = UIImageNamed(@"sys_nextimg");
    [view addSubview:_subImageV];
        
    
    [self.tableView registerClass:[NoticeTuYaChatCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 142;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self createRefesh];
    [self requestWith];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.delegate = self;
    
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [webBtn setImage:UIImageNamed(@"Image_yiwenhao") forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:webBtn];
    [webBtn addTarget:self action:@selector(webClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backToPageAction{
    if (self.fromNomerl) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.backBlock) {
            self.backBlock(YES);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webClick{
    NoticeSysMeassageTostView *tostV = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    NoticeMessage *messM = [[NoticeMessage alloc] init];
    messM.type = @"19";
    messM.title = [NoticeTools getLocalStrWith:@"em.sx"];
    messM.content = [NoticeTools getLocalStrWith:@"em.content"];
    tostV.message = messM;
    [tostV showActiveView];
}
- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20,50, DR_SCREEN_WIDTH-40, 35)];
        _titleHeadView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 35)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"hh.markk"];
        label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        label.numberOfLines = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 35)];
        [button setImage:UIImageNamed(@"Image_sendXXtm") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    [NoticeTools setMarkclickTUYACenter];
    [self.titleHeadView removeFromSuperview];
    self.headerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 44);
    self.tableView.frame = CGRectMake(0, 44+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44);
}

- (void)didReceiveMessage:(id)message{

    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [NoticeChats mj_objectWithKeyValues:message[@"data"]];

    if ([ifDelegate.action isEqualToString:@"delete"]) {
        for (NoticeChats *chatAll in self.dataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialogId] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.dataArr removeObject:chatAll];
                break;
            }
        }
        
        for (NoticeChats *chatAll in self.localdataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialog_id] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.localdataArr removeObject:chatAll];
                break;
            }
        }
        
        for (NoticeChats *norChat in self.nolmorLdataArr) {
            if ([norChat.dialog_id isEqualToString:chat.dialog_id] || [norChat.dialog_id isEqualToString:chat.dialogId]) {
                [self.nolmorLdataArr removeObject:norChat];
                break;
            }
        }
        
        [self.tableView reloadData];
        return;
    }
 
    if (![chat.chat_type isEqualToString:@"3"]) {
        return;
    }
    if (![chat.resource_id isEqualToString:self.curentDraw.drawId]) {//不是同一幅画不接收
        return;
    }
    
    if (![chat.from_user_id isEqualToString:self.toUserId] && !chat.isSelf) {//发送人不是当前接收者不接收
        return;
    }
    
    BOOL alerady = NO;
    for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
        if ([olM.dialog_id isEqualToString:chat.dialog_id]) {
            alerady = YES;
            break;
        }
    }
    
    if (!alerady) {
        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
    }
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)createRefesh{
    
    __weak NoticeTuYaChatWithOtherController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestWith];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;

}

- (void)requestDetail{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"artworks/%@",self.drawId] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dict[@"data"]];
            if ([model.user_id isEqualToString:[NoticeTools getuserId]]) {
                NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
                model.avatar_url = userInfo.avatar_url;
                model.nick_name = userInfo.nick_name;
                model.identity_type = userInfo.identity_type;
                model.levelName = userInfo.levelName;
                model.levelImgName = userInfo.levelImgName;
                model.levelImgIconName = userInfo.levelImgIconName;
            }else{
                if (model.user_info) {
                    NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.user_info];
                    model.avatar_url = userM.avatar_url;
                    model.nick_name = userM.nick_name;
                    model.identity_type = userM.identity_type;
                    model.levelName = userM.levelName;
                    model.levelImgName = userM.levelImgName;
                    model.levelImgIconName = userM.levelImgIconName;
                }
            }
            self.curentDraw = model;
            self->_infoL.text = [NSString stringWithFormat:@"%@ 在 %@ 的作品",self.curentDraw.nick_name,self.curentDraw.createTime];
            if ([NoticeTools getLocalType] == 1) {
                self->_infoL.text = [NSString stringWithFormat:@"%@ drawing on %@",self.curentDraw.nick_name,self.curentDraw.createTime];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)requestWith{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"chats/3/%@/%@",self.toUserId,self.curentDraw?self.curentDraw.drawId:self.drawId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"chats/3/%@/%@?lastId=%@",self.toUserId,self.curentDraw?self.curentDraw.drawId:self.drawId,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"chats/3/%@/%@",self.toUserId,self.curentDraw?self.curentDraw.drawId:self.drawId];
        }
    }
    if (self.fromManager) {
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@",self.chatId,self.managerCode];
        }else{
            if (self.lastId) {
                url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@&lastId=%@",self.chatId,self.managerCode,self.lastId];
            }else{
                url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@",self.chatId,self.managerCode];
            }
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.fromManager?nil: @"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
                model.dialog_id = model.tuyaDiaLogId;
                BOOL alerady = NO;
                for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
                    if ([olM.dialog_id isEqualToString:model.dialog_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    [self.nolmorLdataArr addObject:model];
                    [newArr addObject:model];
                }
            }
            if (self.nolmorLdataArr.count) {
                //2.倒序的数组
                NSArray *reversedArray = [[self.nolmorLdataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:reversedArray];
                NoticeChats *lastM = self.dataArr[0];
                self.lastId = lastM.dialog_id;
            }
            
            [self.tableView reloadData];
            if (self.isDown && !self.isFirst) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEBDGEVLAUEPUSH" object:nil];
                if (newArr.count) {
                      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            
            if (self.dataArr.count && self.isFirst) {
                self.isFirst = NO;
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                if (self.localdataArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.localdataArr.count;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTuYaChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.noSend = self.fromManager;
    cell.section = indexPath.section;
    cell.currentPath = indexPath;
    cell.delegate = self;
    cell.drawId = self.curentDraw? self.curentDraw.drawId:self.drawId;
    cell.chatModel = indexPath.section == 0? self.dataArr[indexPath.row]:self.localdataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.refreshHeightBlock = ^(NSIndexPath * _Nonnull indxPath) {
       [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
    };
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tapTo{
    if (!self.curentDraw) {
        return;
    }
    NoticeDrawShowListController *ctl = [[NoticeDrawShowListController alloc] init];
    ctl.listType = 6;
    ctl.artId = self.curentDraw.drawId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)deleteWithIndex:(NSInteger)tag section:(NSInteger)section{
    NoticeChats *deleteModel = nil;
    if (section == 0) {
        if (tag > self.dataArr.count-1) {
            return;
        }
        deleteModel = self.dataArr[tag];
    }else{
        if (tag > self.localdataArr.count-1) {
            return;
        }
        deleteModel = self.localdataArr[tag];
    }
    //判断有无，以免对方已经删除
    BOOL hasModel = NO;
    for (NoticeChats *allm in self.dataArr) {
        if ([allm.dialog_id isEqualToString:deleteModel.dialog_id]) {
            hasModel = YES;
            break;
        }
    }
    
    for (NoticeChats *allm in self.localdataArr) {
        if ([allm.dialog_id isEqualToString:deleteModel.dialog_id]) {
            hasModel = YES;
            break;
        }
    }
    
    if (!hasModel) {
        return ;
    }
    
    NSMutableDictionary * dsendDic = [NSMutableDictionary new];
    [dsendDic setObject: [NSString stringWithFormat:@"%@%@",socketADD,self.toUserId] forKey:@"to"];
    [dsendDic setObject:@"singleChat" forKey:@"flag"];
    [dsendDic setObject:@"delete" forKey:@"action"];
    [dsendDic setValue:self.curentDraw?self.curentDraw.drawId:self.drawId forKey:@"resourceId"];
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"3" forKey:@"chatType"];
    [messageDic setObject:deleteModel.chat_id forKey:@"chatId"];
    [messageDic setObject:deleteModel.dialog_id forKey:@"dialogId"];
    [dsendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:dsendDic];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGETHEROOTSELECTARTTY" object:self userInfo:@{@"drawId":self.curentDraw?self.curentDraw.drawId:self.drawId,@"add":@"0"}];
    
    for (NoticeChats *chatAll in self.dataArr) {
        if ([chatAll.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.dataArr removeObject:chatAll];
            break;
        }
    }
    
    for (NoticeChats *chatAll in self.localdataArr) {
        if ([chatAll.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.localdataArr removeObject:chatAll];
            break;
        }
    }
    
    for (NoticeChats *norChat in self.nolmorLdataArr) {
        if ([norChat.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.nolmorLdataArr removeObject:norChat];
            break;
        }
    }
    
    [self.tableView reloadData];
    [self.tableView reloadData];
}
@end
