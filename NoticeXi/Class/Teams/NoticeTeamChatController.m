//
//  NoticeTeamChatController.m
//  NoticeXi
//
//  Created by li lei on 2023/6/2.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamChatController.h"
#import "NoticeTeamChatInputView.h"
#import "NoticeTeamChatCell.h"
#import "NoticeNoReandView.h"
#import "UIView+CLSetRect.h"
#import "NoticeSendTeamMsgTools.h"
#import "NoticeJoinTeamRulView.h"
#import "NoticeChangeTeamNickNameView.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeTeamSetController.h"
@interface NoticeTeamChatController ()<NoticeReceveMessageSendMessageDelegate,NoticePlayTapDeledate>
@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, strong) NoticeTeamChatInputView *teamChatInputView;
@property (nonatomic, strong) NoticeTeamChatModel *oldModel;
@property (nonatomic, assign) BOOL noAuto;
@property (nonatomic, strong) NoticeTeamChatModel *currentModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, strong) NoticeSendTeamMsgTools *sendTools;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, strong) UIImageView *joinBtn;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) NSInteger newMsgNum;
@property (nonatomic, strong) UIView *newsessageView;
@property (nonatomic, strong) UILabel *newmessageL;
@property (nonatomic, strong) UIView *moreMessageView;
@property (nonatomic, strong) UILabel *messageL;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *photoArr;
@end

@implementation NoticeTeamChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canLoad = YES;
    self.newMsgNum = 0;
    
    self.navBarView.titleL.text = self.teamModel.title;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.hidden = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[NoticeTeamChatCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91-NAVIGATION_BAR_HEIGHT);

    [self.navBarView.rightButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.oldSection = 10000;
    self.isFirst = YES;
    self.dataArr = [[NSMutableArray alloc] init];
    self.nolmorLdataArr = [[NSMutableArray alloc] init];
    
    self.teamChatInputView = [[NoticeTeamChatInputView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91, DR_SCREEN_WIDTH, 91)];
    self.teamChatInputView.teamModel = self.teamModel;
    [self.view addSubview:self.teamChatInputView];
    [self.teamChatInputView requestPerson];
    
    __weak typeof(self) weakSelf = self;
    self.teamChatInputView.startRecoderOrPzStopPlayBlock = ^(BOOL stopPlay) {
        [weakSelf.audioPlayer stopPlaying];
        weakSelf.isReplay = YES;
        
        if (weakSelf.oldModel) {
            weakSelf.oldModel.isPlaying = NO;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.noAuto = YES;
        [weakSelf.audioPlayer pause:YES];
        weakSelf.isReplay = YES;
        weakSelf.oldSelectIndex = 1000000;
        weakSelf.oldSection = 1000000000;
        [weakSelf.audioPlayer stopPlaying];
        
        for (NoticeTeamChatModel * chat in weakSelf.dataArr) {
            if (chat.isPlaying) {
                chat.isPlaying = NO;
                break;
            }
        }
        for (NoticeTeamChatModel * chat in weakSelf.localdataArr) {
            if (chat.isPlaying) {
                chat.isPlaying = NO;
                break;
            }
        }
        [weakSelf.tableView reloadData];
    };
    
    //发送音频
    self.teamChatInputView.uploadVoiceBlock = ^(NSString * _Nonnull localPath, NSString * _Nonnull timeLength, NSString * _Nonnull upSuccessPath, BOOL upSuccess,NSString *bucketId) {
     
     
        if(upSuccess){
            [weakSelf sendVocieWith:localPath time:timeLength upSuccessPath:upSuccessPath success:upSuccess bucketid:bucketId];
        }else{
            [weakSelf saveVoice:timeLength path:localPath];
        }
        
    };
    //发送图片
    self.teamChatInputView.uploadimgBlock = ^(NSData * _Nonnull imgData, NSString * _Nonnull upSuccessPath, BOOL upSuccess, NSString * _Nonnull bucketId) {
        if(upSuccess){
            [weakSelf sendImgWithPath:upSuccessPath success:upSuccess bucketid:bucketId imgData:imgData];
        }else{
            [weakSelf saveImg:imgData str:nil path:nil];
        }
        
    };
    
    //发送表情包
    self.teamChatInputView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        [weakSelf sendemtionWithPath:url bucketid:buckId pictureId:pictureId isHot:isHot];
    };
    
    //发送文字
    self.teamChatInputView.sendTextBlock = ^(NSString * _Nonnull sendText, NoticeTeamChatModel * _Nonnull replyMsgModel, NSString * _Nullable atPersons) {
        [weakSelf.sendTools sendTextWith:sendText withUse:replyMsgModel atpersons:atPersons];
    };

    self.sendTools.sendTextSuccessBlock = ^(BOOL fail, NSString * _Nonnull content) {
        if(fail){
            [weakSelf saveText:content];
        }
    };
    
    self.teamChatInputView.orignYBlock = ^(CGFloat y) {
        weakSelf.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, y-NAVIGATION_BAR_HEIGHT);
        weakSelf.canLoad = YES;
        [weakSelf scroToBottom];
    };
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
    bottomV.backgroundColor = self.teamChatInputView.backgroundColor;
    [self.view addSubview:bottomV];
    

    self.teamChatInputView.saveKey = [NSString stringWithFormat:@"teamChat%@%@",[NoticeTools getuserId],self.teamModel.teamId];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.groupDelegate = self;
    
    
    if (self.chatM) {
        if(self.chatM.status.intValue > 1){
            self.chatM.status = @"1";
            self.chatM.hasManage = YES;
        }
        [self.chatM refreshCallChatHeight];
        [self.dataArr addObject:self.chatM];
        
        [self.teamChatInputView removeFromSuperview];
        [self.tableView reloadData];
        self.identity = @"3";
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.navBarView.titleL.text = @"被举报的社团聊天";
        self.tableView.tableFooterView = self.footView;
    }else{
        [self getInChatView];
        [self createRefesh];
        [self.tableView.mj_header beginRefreshing];
        [self refreshTeam];
    }
  
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 80)];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-222)/2+126*i, 40, 96, 40)];
            button.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.tag = i;
            button.layer.cornerRadius = 20;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
            [_footView addSubview:button];
            if(i == 0){
                self.deleteButton = button;
                self.deleteButton.backgroundColor = [UIColor colorWithHexString:self.chatM.hasManage?@"#A1A7B3":@"#0099E6"];
                [self.deleteButton setTitle:self.chatM.hasManage?@"已删除":@"删除消息" forState:UIControlStateNormal];
            }else{
                button.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
                [button setTitle:@"查看社团" forState:UIControlStateNormal];
            }
        }
    }
    return _footView;
}

- (void)manageClick:(UIButton *)button{
    if(button.tag == 0){
        if(self.chatM.hasManage){
            return;
        }
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *revokeDic = [[NSMutableDictionary alloc] init];
        [revokeDic setObject:@"massChat" forKey:@"flag"];
        [revokeDic setObject:@"delete" forKey:@"action"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:self.chatM.logId forKey:@"chatLogId"];
        [revokeDic setObject:data forKey:@"data"];
        [appdel.socketManager sendMessage:revokeDic];
        self.chatM.hasManage = YES;
        self.deleteButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.deleteButton setTitle:@"已删除" forState:UIControlStateNormal];
    }else{
        NoticeTeamChatController *ctl = [[NoticeTeamChatController alloc] init];
        ctl.teamModel = self.teamModel;
        ctl.identity = self.identity;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)createRefesh{
    
    __weak NoticeTeamChatController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)getInChatView{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.teamModel.teamId forKey:@"massId"];
    [parm setObject:@"1" forKey:@"type"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"mass/chats/tourist" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
      
        if (success) {
            DRLog(@"进入聊天界面");
        }
    } fail:^(NSError * _Nullable error) {
     
    }];
}


- (void)requestData{
    NSString *url = nil;
    
    if (!self.isFirst && !self.teamModel) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    if (self.isFirst) {
        url = [NSString stringWithFormat:@"mass/chats/%@",self.teamModel.teamId];
    }else{
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"mass/chats/%@",self.teamModel.teamId];
        }else{
            if (self.lastId) {
                url = [NSString stringWithFormat:@"mass/chats/%@?lastId=%@",self.teamModel.teamId,self.lastId];
            }else{
                self.isDown = NO;
                url = [NSString stringWithFormat:@"mass/chats/%@",self.teamModel.teamId];
            }
        }
    }
    
    [self requestWith:url isLocation:NO isUnReadNum:NO chatId:nil];
}

- (NSMutableArray *)photoArr{
    if(!_photoArr){
        _photoArr = [[NSMutableArray alloc] init];
    }
    return _photoArr;
}

- (void)requestWith:(NSString *)url isLocation:(BOOL)isLocation isUnReadNum:(BOOL)isUnReadNum chatId:(NSString *)chatId{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
        
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTeamChatModel *model = [NoticeTeamChatModel mj_objectWithKeyValues:dic];
      
                if (model.content_type.intValue > 3) {
                    model.content_type = @"1";
                    model.content = @"请更新到最新版本";
                }
                [model refreshCallChatHeight];
                 
                BOOL alerady = NO;
                for (NoticeTeamChatModel *olM in self.localdataArr) {//判断是否有重复数据
                    if ([olM.logId isEqualToString:model.logId]) {
                        alerady = YES;
                        break;
                    }
                }
                
                if (!alerady) {
                    if(model.content_type.intValue == 2){
                        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                        item.smallUrlString = model.resource_url;
                        item.largeImageURL     = [NSURL URLWithString:model.resource_url];
                        [self.photoArr insertObject:item atIndex:0];
                    }
                    [self.nolmorLdataArr addObject:model];
         
                    [newArr addObject:model];
                }
            }
            if (self.nolmorLdataArr.count) {
                //2.倒序的数组
                NSArray *reversedArray = [[self.nolmorLdataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:reversedArray];
                NoticeTeamChatModel *lastM = self.dataArr[0];
                self.lastId = lastM.logId;
            }
            
            if(isLocation){//定位消息位置
                if (newArr.count && self.dataArr.count < 400) {//如果还能请求到数据并且数据在四百个以内
                    [self gotoToZhePoint:chatId];
                }
                return;
            }else if (isUnReadNum && self.dataArr.count){
                if(!newArr.count){//获取不到消息了就不再获取
                    [self.tableView reloadData];
                    if (self.dataArr.count >= self.teamModel.unread_num.intValue) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArr.count-self.teamModel.unread_num.intValue) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        self.teamModel.unread_num = @"0";
                    }else{
                    
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                    return;
                }
                if(self.dataArr.count > self.teamModel.unread_num.intValue){//获取到的数量大于等于未读数量的时候，停止
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArr.count-self.teamModel.unread_num.intValue) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    self.teamModel.unread_num = @"0";
      
                }else{
                    [self unReadTap];
                }
                return;
            }
            
            //缓存的发送失败的数据
            if (self.isFirst) {
                [self getsaveArr];
            }

            [self.tableView reloadData];
            if (self.isDown && !self.isFirst) {
                if (newArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            
            if (self.dataArr.count && self.isFirst) {
                self.isFirst = NO;
                [self scroToBottom];
                
                if(self.teamModel.call_id.intValue && self.teamModel.unread_num.intValue > 10){
                    self.moreMessageView.hidden = NO;
                    self.messageL.text = @"有人@我";
                }else if (self.teamModel.unread_num.intValue > 10){
                    self.moreMessageView.hidden = NO;
                    self.messageL.text = self.teamModel.unread_num.intValue > 99?@"99+新消息":[NSString stringWithFormat:@"%@新消息",self.teamModel.unread_num];
                }
            }
        }
    } fail:^(NSError *error) {
        if ([NoticeComTools pareseError:[NSError new]]) {
            if (self.isFirst) {
                self.isFirst = NO;
                [self getsaveArr];
            }
        }

        [self hideHUD];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (void)getsaveArr{
    if(self.teamModel.is_join.boolValue){
        NSMutableArray *localArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
        if ([localArr count]) {
            for (NoticeTeamChatModel *chatM in localArr) {
                BOOL alerady = NO;
                for (NoticeTeamChatModel *olM in self.localdataArr) {//判断是否有重复数据
                    if(olM.isSaveCace){
                        if ([olM.saveId isEqualToString:chatM.saveId]) {
                            alerady = YES;
                            break;
                        }
                    }
                }
                if (!alerady) {
                    chatM.isSelf = YES;
                    chatM.content = chatM.resource_url;
                    [chatM refreshCallChatHeight];
                    [self.localdataArr addObject:chatM];
                }
            }
            [self.tableView reloadData];
            [self scroToBottom];
        }
    }
}

//缓存发送失败的图片
- (void)saveImg:(NSData *)imgData str:(NSString *)text path:(NSString *)path{
    if (!path) {
        path = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    }
    NSMutableArray *alreadyArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
    NSString *pathName = [NSString stringWithFormat:@"/%@",path];
    NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:pathName];
    BOOL result = [imgData writeToFile:Pathimg atomically:YES];
    if (!result) {
        [self showToastWithText:@"消息缓存失败"];
        return;
    }
    
    NoticeTeamChatModel *saveM = [[NoticeTeamChatModel alloc] init];
    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
    NSDictionary *dic = @{@"mass_nick_name":self.teamModel.mass_nick_name,@"userId":selfUser.user_id,@"avatar_url":selfUser.avatar_url};
    saveM.from_user = dic;
    saveM.imagePath = pathName;
    saveM.saveId = [NSString stringWithFormat:@"%@2-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
    saveM.imgUpPath = Pathimg;
    saveM.resource_url = saveM.imgUpPath;
    saveM.content_type = @"2";
    saveM.isSaveCace = @"1";
    saveM.isSelf = YES;
    [alreadyArr addObject:saveM];
    [NoticeTools saveTeamChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
    
    NoticeTeamChatModel *locaChat = [NoticeTeamChatModel mj_objectWithKeyValues:saveM.mj_keyValues];
    locaChat.isSelf = YES;
    [locaChat refreshCallChatHeight];
    [self.localdataArr addObject:locaChat];
    [self.tableView reloadData];
    [self scroToBottom];
}

//缓存音频
- (void)saveVoice:(NSString *)time path:(NSString *)path{

    NSString *pathName = [NSString stringWithFormat:@"%ld",(long)arc4random()%999999999];
    NSString *voicePath = [NSString stringWithFormat:@"%@.%@",pathName,[path pathExtension]];
    NSMutableArray *alreadyArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
    if ([NoticeSaveVoiceTools copyItemAtPath:path toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voicePath]]) {

        NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
        NoticeTeamChatModel *saveM = [[NoticeTeamChatModel alloc] init];
        NSDictionary *dic = @{@"mass_nick_name":self.teamModel.mass_nick_name,@"userId":selfUser.user_id,@"avatar_url":selfUser.avatar_url};
        saveM.from_user = dic;
        saveM.pathName = [NSString stringWithFormat:@"%@.%@",pathName,[path pathExtension]];
        saveM.saveId = [NSString stringWithFormat:@"%@3-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
        saveM.resource_url = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:saveM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        saveM.voice_len = time;
        saveM.content_type = @"3";
        saveM.isSelf = YES;
        saveM.isSaveCace = @"1";
        [saveM refreshCallChatHeight];
        [alreadyArr addObject:saveM];
        [NoticeTools saveTeamChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
        
        NoticeTeamChatModel *locaChat = [NoticeTeamChatModel mj_objectWithKeyValues:saveM.mj_keyValues];
        locaChat.isSelf = YES;
        [locaChat refreshCallChatHeight];
        [self.localdataArr addObject:locaChat];
        [self.tableView reloadData];
        [self scroToBottom];
    }
}

//缓存文字
- (void)saveText:(NSString *)text{
    NSMutableArray *alreadyArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
    NoticeTeamChatModel *saveM = [[NoticeTeamChatModel alloc] init];
    NSDictionary *dic = @{@"mass_nick_name":self.teamModel.mass_nick_name,@"userId":selfUser.user_id,@"avatar_url":selfUser.avatar_url};
    saveM.from_user = dic;
    saveM.pathName = @"sfsd.aac";
    saveM.saveId = [NSString stringWithFormat:@"%@3-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
    saveM.resource_url = text;
    saveM.voice_len = @"10";
    saveM.content_type = @"1";
    saveM.isSelf = YES;
    saveM.isSaveCace = @"1";
    [alreadyArr addObject:saveM];
    [NoticeTools saveTeamChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
    
    NoticeTeamChatModel *locaChat = [NoticeTeamChatModel mj_objectWithKeyValues:saveM.mj_keyValues];
    locaChat.isSelf = YES;
    locaChat.content = saveM.resource_url;
    [locaChat refreshCallChatHeight];
    [self.localdataArr addObject:locaChat];
    [self.tableView reloadData];
    [self scroToBottom];

    
}

- (void)dealloc{
    if (!self.teamModel.teamId) {
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.teamModel.teamId forKey:@"massId"];
    [parm setObject:@"2" forKey:@"type"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"mass/chats/tourist" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
      
        if (success) {
            DRLog(@"离开聊天界面");
        }
    } fail:^(NSError * _Nullable error) {
     
    }];
}

- (void)didReceiveGroupMainPageMessage:(NoticeOneToOne *)message{
    if(!message.data){
        return;
    }
    NoticeTeamChatModel *chat = [NoticeTeamChatModel mj_objectWithKeyValues:message.data];
    if(![chat.mass_id isEqualToString:self.teamModel.teamId]){//不是这个社团的，不接收
        return;
    }
    if([message.action isEqualToString:@"memberUpdateNickname"]){//修改昵称
        if(chat.nick_name && chat.to_user_id){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGETEAMMASSNICKNAMENotification" object:self userInfo:@{@"userId":chat.to_user_id,@"nickName":chat.nick_name}];
        }
        
        return;
    }
    if ([message.action isEqualToString:@"revoke"] || [message.action isEqualToString:@"delete"]) {//撤回消息
        if(self.chatM){
            return;
        }
  
        for (NoticeTeamChatModel *locaChat in self.localdataArr) {
            if([locaChat.logId isEqualToString:chat.chat_log_id]){
                locaChat.status = [message.action isEqualToString:@"revoke"]? @"4":@"3";
                locaChat.del_user = chat.del_user;
                [locaChat refreshCallChatHeight];
                
                if(locaChat.content_type.intValue == 2){
                    for (YYPhotoGroupItem*item in self.photoArr) {
                        if ([locaChat.resource_url isEqualToString:item.smallUrlString]) {//删除图片
                            [self.photoArr removeObject:item];
                            break;
                        }
                    }
                }
        
            }
            if(locaChat.userMsg){
                if([locaChat.userMsg.logId isEqualToString:chat.chat_log_id]){
                    locaChat.userMsg.status = [message.action isEqualToString:@"revoke"]? @"4":@"3";
                    [locaChat refreshCallChatHeight];
                }
            }
        }
        for (NoticeTeamChatModel *locaChat in self.dataArr) {
            if([locaChat.logId isEqualToString:chat.chat_log_id]){
                locaChat.status = [message.action isEqualToString:@"revoke"]? @"4":@"3";
                locaChat.del_user = chat.del_user;
                [locaChat refreshCallChatHeight];
                
                if(locaChat.content_type.intValue == 2){
                    for (YYPhotoGroupItem*item in self.photoArr) {
                        if ([locaChat.resource_url isEqualToString:item.smallUrlString]) {//删除图片
                            [self.photoArr removeObject:item];
                            break;
                        }
                    }
                }
            }
            if(locaChat.userMsg){
                if([locaChat.userMsg.logId isEqualToString:chat.chat_log_id]){
                    locaChat.userMsg.status = [message.action isEqualToString:@"revoke"]? @"4":@"3";
                    [locaChat refreshCallChatHeight];
                }
            }
        }
        if ([chat.chat_log_id isEqualToString:self.oldModel.logId]) {//如果撤回的是当前播放的语音消息
            [self.audioPlayer stopPlaying];
            self.isReplay = YES;
            self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            self.oldSection = 1000000;
        }
        [self.tableView reloadData];
        return;
    }
    
    if([message.action isEqualToString:@"memberRemove"] || [message.action isEqualToString:@"memberQuit"]){//移出社团成员
        self.teamModel.member_num = [NSString stringWithFormat:@"%d",self.teamModel.member_num.intValue-1];
        
        if([chat.to_user_id isEqualToString:[NoticeTools getuserId]]){//被移出的人是自己
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"你已被移出社团" message:nil cancleBtn:@"知道了"];
            [alerView showXLAlertView];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.teamChatInputView remvokUserId:chat.to_user_id];
            for (NoticeTeamChatModel *olM in self.localdataArr) {//判断是否有重复数据
                if ([olM.fromUserM.userId isEqualToString:chat.to_user_id]) {
                    olM.fromUserM.member_status = @"2";
                }
            }
            for (NoticeTeamChatModel *olM in self.dataArr) {//判断是否有重复数据
                if ([olM.fromUserM.userId isEqualToString:chat.to_user_id]) {
                    olM.fromUserM.member_status = @"2";
                }
            }
        }
    }
    
    if([message.action isEqualToString:@"memberJoin"]){
        self.teamModel.member_num = [NSString stringWithFormat:@"%d",self.teamModel.member_num.intValue+1];
        [self.teamChatInputView requestPerson];
    }
    
    if ([message.action isEqualToString:@"managerRemove"]) {//管理员身份被取消
        if([chat.to_user_id isEqualToString:[NoticeTools getuserId]]){
            self.identity = @"1";
        }
        for (NoticeTeamChatModel *locaChat in self.localdataArr) {
            if([locaChat.logId isEqualToString:chat.to_user_id]){
                locaChat.fromUserM.identity = @"1";
            }
        }
        for (NoticeTeamChatModel *locaChat in self.dataArr) {
            if([locaChat.logId isEqualToString:chat.to_user_id]){
                locaChat.fromUserM.identity = @"1";
            }
        }
        [self.tableView reloadData];
        [self.teamChatInputView refreshManageUserId:chat.to_user_id];
        return;
    }
    
    if(!chat.contentType){//不是消息类型，不接收
        return;
    }
    
    if (chat.contentType > 3) {
        chat.content_type = @"1";
        chat.content = @"请更新到最新版本";
    }
    [chat refreshCallChatHeight];
    BOOL alerady = NO;
    for (NoticeTeamChatModel *olM in self.localdataArr) {//判断是否有重复数据
        if ([olM.logId isEqualToString:chat.logId]) {
            alerady = YES;
            break;
        }
    }
    
    if (!alerady) {
        if(chat.content_type.intValue == 2){
            YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
            item2.smallUrlString = chat.resource_url;
            item2.largeImageURL     = [NSURL URLWithString:chat.resource_url];
            [self.photoArr addObject:item2];
        }
        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
        
        
        if(!self.canLoad){
            self.newMsgNum++;
            self.newsessageView.hidden = NO;
            self.newmessageL.text = [NSString stringWithFormat:@"新消息 +%ld",self.newMsgNum > 99?99:self.newMsgNum];
        }
    }
    
    [self scroToBottom];
}

//刷新社团状态，是否加入了社团等
- (void)refreshTeam{
    if(self.teamModel.is_forbid.boolValue){
        [self clearSaveMsg];
        [self.teamChatInputView removeFromSuperview];
        [self.joinBtn removeFromSuperview];
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }else{
        if(self.teamModel.is_join.boolValue){
            self.teamChatInputView.hidden = NO;
            _joinBtn.hidden = YES;
        }else{
            self.teamChatInputView.hidden = YES;
            self.joinBtn.hidden = NO;
            [self clearSaveMsg];
        }
    }

    [self.navBarView.rightButton setImage:UIImageNamed(self.teamModel.is_join.boolValue? @"helpdetailImg":@"nojointeamimg") forState:UIControlStateNormal];
}

//清除缓存消息
- (void)clearSaveMsg{
    NSMutableArray *alreadyArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
    if(alreadyArr.count){
        [alreadyArr removeAllObjects];
        [NoticeTools saveTeamChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];
        for (NoticeTeamChatModel *saveM in self.localdataArr) {
            if(saveM.isSaveCace){
                [self.localdataArr removeObject:saveM];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)clearSaveModelWith:(NoticeTeamChatModel *)model{
    NSMutableArray *alreadyArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];

    for (NoticeTeamChatModel *saveM in self.localdataArr) {
        if(saveM.isSaveCace && [model.saveId isEqualToString:saveM.saveId]){
            [self.localdataArr removeObject:saveM];
            break;
        }
    }
    for (NoticeTeamChatModel *saveM in alreadyArr) {
        if([model.saveId isEqualToString:saveM.saveId]){
            [alreadyArr removeObject:saveM];
            break;
        }
    }
    [NoticeTools saveTeamChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@-%@",self.teamModel.teamId,[NoticeTools getuserId]]];

    [self.tableView reloadData];
}

- (void)reSendOrBack:(NoticeTeamChatModel *)chatModel{
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if(buttonIndex == 1){
            if(chatModel.content_type.intValue == 1){
                [weakSelf clearSaveModelWith:chatModel];
                [weakSelf.sendTools sendTextWith:chatModel.content withUse:nil atpersons:nil];
            }else if (chatModel.content_type.intValue == 2){
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:chatModel.resource_url];
                NSData *data = [fileHandle readDataToEndOfFile];
                [fileHandle closeFile];
                UIImage *image  = [[UIImage alloc] initWithData:data];
                if (!image) {
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.noimg"]];
                    return;
                }
                //UIImage转换为NSData
                NSData *imageData = UIImageJPEGRepresentation(image,0.8);//第二个参数为压缩倍数
                [weakSelf clearSaveModelWith:chatModel];
                [weakSelf.teamChatInputView upLoadHeader:imageData path:nil];
            }else if (chatModel.content_type.intValue == 3){
                [weakSelf clearSaveModelWith:chatModel];
                [weakSelf.teamChatInputView sendTime:chatModel.voice_len path:chatModel.resource_url];
            }
        }else if (buttonIndex == 2){
            [weakSelf clearSaveModelWith:chatModel];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"msg.resend"],[NoticeTools getLocalStrWith:@"msg.back"]]];
    [sheet show];
}

//加入社团
- (void)joinClick{

    __weak typeof(self) weakSelf = self;
    NoticeJoinTeamRulView *ruleView = [[NoticeJoinTeamRulView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    ruleView.contentL.attributedText = [NoticeTools getStringWithLineHight:4 string:self.teamModel.rule];
    [ruleView showrulView];
    ruleView.knowBlock = ^(BOOL know) {
        [weakSelf sureJoin];
    };
}

- (void)sureJoin{
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/join/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            weakSelf.teamModel.is_join = @"1";
            [weakSelf refreshTeam];
            [weakSelf changeTeamNickName];
            [weakSelf.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
    
}

//设置社团昵称
- (void)changeTeamNickName{
    __weak typeof(self) weakSelf = self;
    NoticeChangeTeamNickNameView * nameV = [[NoticeChangeTeamNickNameView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    nameV.sureNameBlock = ^(NSString * _Nonnull name) {
        if(name){
            [weakSelf changeNameWithName:name];
        }
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
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)sendVocieWith:(NSString *)localPath time:(NSString *)timeLength upSuccessPath:(NSString *)upSuccessPath success:(BOOL)success bucketid:(NSString *)bucketId{
    [self.sendTools sendVocieWith:localPath time:timeLength upSuccessPath:upSuccessPath success:success bucketid:bucketId withUse:nil];
}

- (void)sendImgWithPath:(NSString *)path success:(BOOL)success bucketid:(NSString *)bucketId imgData:(NSData *)imgData{
    [self.sendTools sendImgWithPath:path success:success bucketid:bucketId imgData:imgData withUse:nil];
}

- (void)sendemtionWithPath:(NSString *)path bucketid:(NSString *)bucketId pictureId:(NSString *)pictureId isHot:(BOOL)isHot{
    [self.sendTools sendemtionWithPath:path bucketid:bucketId pictureId:pictureId isHot:isHot withUse:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.localdataArr.count;
    }
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTeamChatModel *chat = indexPath.section == 1 ? self.localdataArr[indexPath.row] : self.dataArr[indexPath.row];
    if (chat.status.intValue == 1) {
        chat.isShowTime = [self.sendTools neeShowTime:indexPath chatModel:self.dataArr localArr:self.localdataArr withChat:chat];
    }else{
        chat.isShowTime = NO;
    }
    return chat.cellHeight+(chat.isShowTime?30:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTeamChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.photoArr = self.photoArr;
    cell.isjoin = self.teamModel.is_join;
    cell.index = indexPath.row;
    cell.section = indexPath.section;
    __weak typeof(self) weakSelf = self;
    cell.clickHeaderBlock = ^(BOOL hideKeyBord) {
        [weakSelf.teamChatInputView regFirst];
    };
    NoticeTeamChatModel *chat = nil;
    if (indexPath.section == 0) {
        if ((indexPath.row <= self.dataArr.count-1) && self.dataArr.count) {
            chat = self.dataArr[indexPath.row];
        }
        
    }else{
        if ((indexPath.row <= self.localdataArr.count-1) && self.localdataArr.count) {
            chat = self.localdataArr[indexPath.row];
        }
    }
    
    if (!chat) {
        return cell;
    }
    cell.identity = self.identity;
    chat.isShowTime = [self.sendTools neeShowTime:indexPath chatModel:self.dataArr localArr:self.localdataArr withChat:chat];
    cell.chatModel = chat;
    cell.replyMsgBlock = ^(NoticeTeamChatModel * _Nonnull useMsgModel) {
        weakSelf.teamChatInputView.replyMsgModel = useMsgModel;
        [weakSelf.teamChatInputView replyMsg];
    };
    cell.locationUseBlock = ^(NoticeTeamChatModel * _Nonnull locationgMsg) {
        if(locationgMsg.userMsg.status.intValue != 1){
            [weakSelf showToastWithText:@"内容已不存在"];
            return;
        }
        [weakSelf gotoPointWithChatId:locationgMsg.userMsg.logId];
    };
    cell.reSendMsgBlock = ^(NoticeTeamChatModel * _Nonnull MsgModel) {
        [weakSelf reSendOrBack:MsgModel];
    };
    cell.delegate = self;
    return cell;
}

- (void)unReadTap{
    if(self.teamModel.call_id.intValue){
        [self gotoPointWithChatId:[NSString stringWithFormat:@"%d",self.teamModel.call_id.intValue]];
    }else if (self.teamModel.unread_num.intValue){
        if(self.dataArr.count){
            [self showHUD];
            NSString *url = [NSString stringWithFormat:@"mass/chats/%@?lastId=%@&pageSize=100",self.teamModel.teamId,self.lastId];
            [self requestWith:url isLocation:NO isUnReadNum:YES chatId:nil];
        }
    }
    self.moreMessageView.hidden = YES;
}

//定位到指定消息位置
- (void)gotoPointWithChatId:(NSString *)chatId{
    if (!chatId) {
        return;
    }
    for (int i = 0; i < self.localdataArr.count;i++) {
        NoticeTeamChatModel *pointM = self.localdataArr[i];
        if ([pointM.logId isEqualToString:chatId]) {//如果在当前数据找到了
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            return;
        }
    }
    //如果上面没有找到，则进行请求更多数据进行查找
    [self gotoToZhePoint:chatId];
    
}

- (void)gotoToZhePoint:(NSString *)chatId{
    for (int i = 0; i < self.dataArr.count;i++) {
        NoticeTeamChatModel *pointM = self.dataArr[i];
        if ([pointM.logId isEqualToString:chatId]) {//如果在当前数据找到了
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            return;
        }
    }
    if(self.lastId){
        [self getMorerequestWith:chatId];
    }
}

- (void)getMorerequestWith:(NSString *)chatId{
    
    [self showHUD];
    NSString *url = [NSString stringWithFormat:@"mass/chats/%@?lastId=%@&pageSize=100",self.teamModel.teamId,self.lastId];
    [self requestWith:url isLocation:YES isUnReadNum:NO chatId:chatId];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(y > h -50) {
        self.newMsgNum = 0;
        self.canLoad = YES;
        _newsessageView.hidden = YES;
    }else{
        self.canLoad = NO;
    }
}


- (void)newReadTap{
    _newsessageView.hidden = YES;
    self.canLoad = YES;
    [self scroToBottom];
}

- (void)scroToBottom{
    if (!self.canLoad) {
        return;
    }
    self.newMsgNum = 0;
    _newsessageView.hidden = YES;
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.teamChatInputView regFirst];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91-NAVIGATION_BAR_HEIGHT);
}

- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{
    [self.tableView reloadData];
    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)palyWithModel:(NoticeTeamChatModel *)model{
    
    if (self.oldModel) {
        self.oldModel.isPlaying = NO;
        [self.tableView reloadData];
    }
    
    self.oldModel = model;
    
    if ((self.currentIndex != self.oldSelectIndex) || (self.currentSection!= self.oldSection)) {//判断点击的是否是当前视图
        self.oldSelectIndex = self.currentIndex;
        self.oldSection = self.currentSection;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }

    
    if (self.isReplay || model.voice_len.integerValue == 1) {
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:model.isSaveCace.boolValue?YES: NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }

    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.voice_len;
        [weakSelf.tableView reloadData];
    };

    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:weakSelf.currentSection];
        
        NoticeTeamChatCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            cell.playerView.slieView.progress = 0;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.oldSection = 1000000;
            if ((model.voice_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf.tableView reloadData];
            }
            model.nowPro = 0;
            model.nowTime = model.voice_len;
        }
     
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.voice_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;
    };
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.teamChatInputView regFirst];
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.teamModel.call_id = @"0";
    self.teamModel.unread_num = @"0";
}

- (NoticeSendTeamMsgTools *)sendTools{
    if(!_sendTools){
        _sendTools = [[NoticeSendTeamMsgTools alloc] init];
        _sendTools.teamModel = self.teamModel;
    }
    return _sendTools;
}


- (NSMutableArray *)localdataArr{
    if(!_localdataArr){
        _localdataArr = [[NSMutableArray alloc] init];
    }
    return _localdataArr;
}


- (UIImageView *)joinBtn{
    if(!_joinBtn){
        _joinBtn = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-355)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-88-20, 355, 88)];
        [self.view addSubview:_joinBtn];
        _joinBtn.userInteractionEnabled = YES;
        _joinBtn.image = UIImageNamed(@"Image_jointeam");
        UIButton *joinB = [[UIButton alloc] initWithFrame:CGRectMake(355/3*2, 10, 355/3, 88-20)];
        [joinB addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
        [_joinBtn addSubview:joinB];
    }
    return _joinBtn;
}



- (void)moreClick{
    if(!self.teamModel.is_join.boolValue){
        NoticeJoinTeamRulView *ruleView = [[NoticeJoinTeamRulView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        ruleView.contentL.attributedText = [NoticeTools getStringWithLineHight:4 string:self.teamModel.rule];
        [ruleView showrulView];
        return;
    }
    NoticeTeamSetController *ctl = [[NoticeTeamSetController alloc] init];
    ctl.teamModel = self.teamModel;
    ctl.identity = self.identity;
    __weak typeof(self) weakSelf = self;
    ctl.personBlock = ^(NSMutableArray * _Nonnull personArr, NSMutableArray * _Nonnull syArr) {
        weakSelf.teamChatInputView.personArr = personArr;
        weakSelf.teamChatInputView.atPersonView.syArr = syArr;
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UIView *)moreMessageView{
    if (!_moreMessageView) {
        _moreMessageView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-104, NAVIGATION_BAR_HEIGHT+125, 104, 48)];
        [self.view addSubview:_moreMessageView];
        _moreMessageView.hidden = YES;
        _moreMessageView.userInteractionEnabled = YES;
        [_moreMessageView setCornerOnLeft:24];
        
        _messageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,104, 48)];
        _messageL.font = THRETEENTEXTFONTSIZE;
        _messageL.textAlignment = NSTextAlignmentCenter;
        [_moreMessageView addSubview:_messageL];
        _messageL.textColor = [UIColor whiteColor];
        
        if(self.teamModel.call_id.intValue){
            _moreMessageView.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        }else{
            _moreMessageView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unReadTap)];
        [_moreMessageView addGestureRecognizer:tap];
    }
    return _moreMessageView;
}



- (UIView *)newsessageView{
    if (!_newsessageView) {
        _newsessageView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-104, DR_SCREEN_HEIGHT-self.teamChatInputView.frame.size.height-BOTTOM_HEIGHT-20-48, 104, 48)];
        [self.view addSubview:_newsessageView];
        _newsessageView.hidden = YES;
        _newsessageView.userInteractionEnabled = YES;
        [_newsessageView setCornerOnLeft:24];
        
        _newmessageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,104, 48)];
        _newmessageL.font = THRETEENTEXTFONTSIZE;
        _newmessageL.textAlignment = NSTextAlignmentCenter;
        [_newsessageView addSubview:_newmessageL];
        _newmessageL.textColor = [UIColor whiteColor];
        
        _newsessageView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newReadTap)];
        [_newsessageView addGestureRecognizer:tap];
    }
    return _newsessageView;
}

@end
