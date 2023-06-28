//
//  NoticeChatWithOtherViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatWithOtherViewController.h"
#import "NoticeChatsCell.h"
#import "NoticeBackVoiceViewController.h"
#import "AppDelegate.h"
#import "NoticeNoticenterModel.h"
#import "NoticeAction.h"
#import "NoticrChatLike.h"
#import "NoticeXi-Swift.h"
#import "NoticeZjListView.h"
#import "NoticeClipImage.h"
#import "NoticeStatus.h"
#import "NoticeChangeTextView.h"
#import "NoticeCustumeButton.h"
@interface NoticeChatWithOtherViewController ()<NoticeRecordDelegate,NewSendTextDelegate,NoticeReceveMessageSendMessageDelegate,LCActionSheetDelegate,NoticeVoiceListClickDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL moveToBottom;
@property (nonatomic, strong) NoticeChats *oldModel;
@property (nonatomic, strong) NoticeChats *currentModel;
@property (nonatomic, strong) NoticeChats *choiceModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic, assign) BOOL firstIn;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSString *autoId;
@property (nonatomic, assign) BOOL noAuto;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;

@property (nonatomic, assign) BOOL isShort;
@property (nonatomic, assign) BOOL isLong;
@property (nonatomic, assign) BOOL isClickChonbo;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, strong) LCActionSheet *juSheet;
@property (nonatomic, strong) LCActionSheet *selfSheet;
@property (nonatomic, strong) UITableView *headerTableView;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *chatTips;
@property (nonatomic, strong) NoticeCustumeButton *likeButton;
@property (nonatomic, strong) NoticeStatus *statusM;
@end

@implementation NoticeChatWithOtherViewController

{
    UILabel *_infoL;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.noVoiceM) {
        [self noDataRequest];  
    }
    
    self.isFirst = YES;
    self.firstIn = YES;
    self.localdataArr = [NSMutableArray new];
    
    self.moveToBottom = YES;
    self.dataArr = [NSMutableArray new];
    self.nolmorLdataArr = [NSMutableArray new];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = GETTEXTWITE(@"chat.title");
    [self.tableView registerClass:[NoticeChatsCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.rowHeight = 27+35;
    [self createRefesh];
    
    self.isDown = NO;
    [self requestData];
    [self refreshData];
    self.noPush = NO;

    if (self.noNeedGetVoiceM) {
        CGFloat heigth = 0;
        NoticeVoiceListModel *model = self.voiceM;
        heigth = [NoticeComTools voiceAllCellHeight:model needFavie:NO];
        self.headerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, heigth-50)];
        self.headerTableView.delegate = self;
        self.headerTableView.backgroundColor = GetColorWithName(VBackColor);
        self.headerTableView.dataSource = self;
        self.headerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.headerTableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.tableHeaderView = self.headerTableView;
        [self.headerTableView reloadData];
        [self.tableView reloadData];
    }else{
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.voiceM.voice_id] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                CGFloat heigth = [NoticeComTools voiceAllCellHeight:self.voiceM needFavie:NO];

                self.headerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, heigth-50)];
                self.headerTableView.delegate = self;
                self.headerTableView.backgroundColor = GetColorWithName(VBackColor);
                self.headerTableView.dataSource = self;
                self.headerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                [self.headerTableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"cell"];
                self.tableView.tableHeaderView = self.headerTableView;
                [self.headerTableView reloadData];
                [self.tableView reloadData];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }

    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-25-44);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15,CGRectGetMaxY(self.tableView.frame)+10,DR_SCREEN_WIDTH-30, 44);
    btn.backgroundColor = GetColorWithName(VMainThumeColor);
    btn.layer.cornerRadius = 42/2;
    btn.layer.masksToBounds = YES;
    [btn setTitle:[NSString stringWithFormat:@"  %@",GETTEXTWITE(@"chat.back")] forState:UIControlStateNormal];
    [btn setImage:UIImageNamed(@"reply_voice") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:WHITEBACKCOLOR] forState:UIControlStateNormal];
    btn.titleLabel.font = NINETEENTEXTFONTSIZE;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(replyS) forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.delegate = self;
    
    self.likeButton = [[NoticeCustumeButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-60, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-21)/2, 60, 21)];
    self.likeButton.layer.cornerRadius = 21/2;
    self.likeButton.layer.masksToBounds = YES;
    [self.view addSubview:self.likeButton];
    self.likeButton.hidden = YES;
    self.likeButton.titleLabel.font = TWOTEXTFONTSIZE;
    [self.likeButton addTarget:self action:@selector(likeOrNoLikeClcik) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    
    [self requestIfLike];
}

- (void)likeOrNoLikeClcik{
    if (self.statusM.friendStatus.status.intValue == 2) {//已是好友，不存在欣赏与否
        return;
    }
    if (!self.statusM.admired_id.intValue) {//已欣赏就取消欣赏
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"加欣赏，彼将知\n互欣赏，成学友" message:nil sureBtn:@"欣赏ta" cancleBtn:[NoticeTools getLocalStrWith:@"bz.dcl"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:self.userId forKey:@"toUserId"];
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        NoticeStatus *status = [NoticeStatus mj_objectWithKeyValues:dict[@"data"]];
                        weakSelf.statusM.admired_id = status.AdmiredId;
                        weakSelf.likeButton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#212137"];
                        [weakSelf.likeButton setTitleColor:[NoticeTools getWhiteColor:@"#999999" NightColor:@"#3D3D49"] forState:UIControlStateNormal];
                        [weakSelf.likeButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    }else{
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",self.statusM.admired_id] Accept:@"application/vnd.shengxi.v4.6.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.statusM.admired_id = @"0";
                self.likeButton.backgroundColor = GetColorWithName(VMainThumeColor);
                [self.likeButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
                [self.likeButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

//判断是否已经欣赏
- (void)requestIfLike{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/bottom",self.userId] Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.likeButton.hidden = NO;
            NoticeStatus *statusM = [NoticeStatus mj_objectWithKeyValues:dict[@"data"]];
            self.statusM = statusM;
            if (self.statusM.admired_id.intValue || self.statusM.friendStatus.status.intValue == 2) {
                self.likeButton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#212137"];
                [self.likeButton setTitleColor:[NoticeTools getWhiteColor:@"#999999" NightColor:@"#3D3D49"] forState:UIControlStateNormal];
                [self.likeButton setTitle:self.statusM.friendStatus.status.intValue == 2?@"学友":[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
            }else{
                self.likeButton.backgroundColor = GetColorWithName(VMainThumeColor);
                [self.likeButton setTitle:@"+欣赏" forState:UIControlStateNormal];
                [self.likeButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
}

- (void)noDataRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.voiceM.voice_id] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            self->_infoL.text = [NSString stringWithFormat:@"%@在%@的%@",self.voiceM.subUserModel.nick_name,self.voiceM.creatTime,GETTEXTWITE(@"my.my")];
            [self.tableView reloadData];
            [self.headerTableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)replyS{
    self.noAuto = YES;
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSection = 10032;
    self.oldSelectIndex = 4324;
    for (NoticeChats * chat in self.dataArr) {
        if (chat.isPlaying) {
            chat.isPlaying = NO;
            break;
        }
    }
    for (NoticeChats * chat in self.localdataArr) {
        if (chat.isPlaying) {
            chat.isPlaying = NO;
            break;
        }
    }
    [self.tableView reloadData];
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
    recodeView.isHS = YES;
    recodeView.needLongTap = YES;
    recodeView.hideCancel = NO;
    recodeView.isReply = YES;
    if (self.chatTips) {
        recodeView.chatTips = self.chatTips;
    }
    
    recodeView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId) {
        NSMutableDictionary *sendDic = [NSMutableDictionary new];
        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userId] forKey:@"to"];
        [sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
        [sendDic setObject:messageDic forKey:@"data"];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:sendDic];
    };
    
    recodeView.delegate = self;
    recodeView.isShort = self.isShort;
    recodeView.isLong = self.isLong;
    recodeView.isAuto = self.isAuto;
    recodeView.iconUrl = self.iconUrl;
    [recodeView show];
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.isReply = YES;
    inputView.delegate = self;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.toUserName];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.toUserName]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.toUserName], 0.9) path:pathMd5 text:str];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
  
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    [self showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:text forKey:@"dialogContentText"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [self hideHUD];
            
        }else{
            [self showToastWithText:errorMessage];
        }
    }];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [self hideHUD];
        }else{
            [self showToastWithText:Message];
            [self hideHUD];
        }
    }];
}


- (void)didReceiveMessage:(id)message{

    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [NoticeChats mj_objectWithKeyValues:message[@"data"]];

    if ([ifDelegate.action isEqualToString:@"delete"]) {
        self.noAuto = YES;//收到对方删除的时候，停止自动播放语音
        [self.audioPlayer stopPlaying];
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
    
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
        if (![chat.from_user_id isEqualToString:self.userId] || ![self.voiceM.voice_id isEqualToString:chat.voice_id]) {
            return;
        }
    }
    
    if (![chat.chat_type isEqualToString:@"1"]) {
        return;
    }
    
    chat.read_at = @"0";
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//当发送人不是自己的时候，需要判断是否是当前会话人发来的消息，不然容易消息错误
        if (![chat.from_user_id isEqualToString:self.userId]) {//别人发来的消息，判断是否是当前对话人
            return;
        }
    }else{
        self.noAuto = NO;
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
    self.chatId = chat.chat_id;

    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NoticeTools setSHAKE:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NoticeTools setSHAKE:YES];
    self.noAuto = YES;
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.headerTableView) {
        NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.isNeedAllContent = YES;
        cell.worldM = self.voiceM;
        cell.index = indexPath.row;
        cell.playerView.tag = indexPath.row;
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed(self.voiceM.isPlaying ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        cell.delegate = self;
        cell.playerView.timeLen = self.voiceM.voice_len;
        cell.buttonView.hidden = YES;
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        return cell;
    }else{
        NoticeChatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.backgroundColor = GetColorWithName(VBackColor);
        NoticeChats *chat = indexPath.section == 0 ? self.dataArr[indexPath.row]:self.localdataArr[indexPath.row];
        
        if (indexPath.section == 0) {//第一组
            if (indexPath.row == 0) {//第一个要显示时间
                chat.isShowTime = YES;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.dataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }else{
            if (!self.dataArr.count) {//如果不存在第一组数据
                if (indexPath.row == 0) {//第一个要显示时间
                    chat.isShowTime = YES;
                }else{
                    if (indexPath.row > 0) {//第二个开始做前一个比较
                        NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                        chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                    }
                }
            }else{//存在第一组数据
                if (indexPath.row == 0) {
                    NoticeChats *firdtChat = self.dataArr[0];
                    chat.isShowTime = (chat.created_at.integerValue - firdtChat.created_at.integerValue)>60 ? YES : NO;
                }else{
                    if (indexPath.row > 0) {//第二个开始做前一个比较
                        NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                        chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                    }
                }
            }
        }
        
        if (chat.is_self.integerValue) {
            chat.identity_type = [[NoticeSaveModel getUserInfo] identity_type];
        }else{
            chat.identity_type = self.identType;
        }
        cell.chat = chat;
        cell.index = indexPath.row;
        cell.section = indexPath.section;
        
        NoticeChats *chat1 = indexPath.section == 0 ? self.dataArr[indexPath.row]:self.localdataArr[indexPath.row];
        chat1.isPlaying ? [cell.playerView.playButton.imageView  startAnimating] : [cell.playerView.playButton.imageView  stopAnimating];
        cell.playerView.timeLen = chat1.resource_len;
        cell.playerView.slieView.progress = 0;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.headerTableView) {
        return 1;
    }
    if (section == 1) {
        return self.localdataArr.count;
    }
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.headerTableView) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.headerTableView) {
        return self.headerTableView.frame.size.height;
    }
    NoticeChats *chat = indexPath.section == 0 ? self.dataArr[indexPath.row]:self.localdataArr[indexPath.row];

    if (chat.needMarkAuto) {
        return 35+44+26+(chat.resource_type.intValue == 2?103:0);
    }
    return 35+44+(chat.resource_type.intValue == 2?103:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView && section == 0) {
        return DR_SCREEN_WIDTH*44/375;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView && section == 0) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*44/375)];
        imageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"konw_img_b":@"konw_img_y");
        return imageV;
    }
    return [UIView new];
}

- (void)hasKnowClick{
    [NoticeComTools saveHasKnow];
    [self.tableView reloadData];
}

- (void)requestData{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
       
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.iconUrl = userIn.avatar_url;
        }
    } fail:^(NSError *error) {

    }];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting/autoReply",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            NoticeNoticenterModel*noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.isAuto = noticeM.auto_reply.integerValue;
        }
    } fail:^(NSError *error) {
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting/chatHobby",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict[@"data"][@"chat_hobby"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticrChatLike *model = [NoticrChatLike mj_objectWithKeyValues:dict[@"data"][@"chat_hobby"]];
            if ([model.likeId isEqualToString:@"1"]) {
                self.isShort = YES;
            }else if ([model.likeId isEqualToString:@"2"]){
                self.isLong = YES;
            }
        
        }
    } fail:^(NSError *error) {
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting/chatTips",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeNoticenterModel *model = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.chat_tips.count) {
                NSString *str1 = @"";
                for (NSDictionary *dic in model.chat_tips) {
                    NoticrChatLike *likeM = [NoticrChatLike mj_objectWithKeyValues:dic];
                    str1 = [NSString stringWithFormat:@"%@,%@",likeM.name,str1];
                }
                if (model.chat_tips.count == 2) {
                    str1 = @"NO联系方式·NO查户口";
                }
                self.chatTips = str1;
                if ([[self.chatTips substringFromIndex:self.chatTips.length-1] isEqualToString:@","]) {
                    self.chatTips = [self.chatTips substringToIndex:self.chatTips.length-1];
                }
            }
        }
    } fail:^(NSError *error) {
    }];
}



- (void)createRefesh{
    
    __weak NoticeChatWithOtherViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl refreshData];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;

}

- (void)refreshData{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"chats/1/%@/%@",self.userId,self.voiceM.voice_id];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"chats/1/%@/%@?lastId=%@",self.userId,self.voiceM.voice_id,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"chats/1/%@/%@",self.userId,self.voiceM.voice_id];
        }
    }
    [self requestWith:url];
}

- (void)requestWith:(NSString *)url{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
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
                self.chatId = lastM.chat_id;
                self.lastId = lastM.dialog_id;
                
                if (self.isAuto) {//判断对方是否在线
                    if (self.firstIn) {//第一次进来获取第一个id
                        NoticeChats *newM = self.dataArr[self.dataArr.count-1];
                        newM.needMarkAuto = YES;
                        self.autoId = newM.dialog_id;
                        self.firstIn = NO;
                    }else{
                        for (NoticeChats *allM in self.dataArr) {
                            if ([allM.dialog_id isEqualToString:self.autoId]) {
                                allM.needMarkAuto = YES;
                                break;
                            }
                        }
                    }
                }else{
                    for (NoticeChats *allM in self.dataArr) {
                        allM.needMarkAuto = NO;
                    }
                }
            }
            
            [self.tableView reloadData];
            
            if (self.isDown && !self.isFirst) {
                if (newArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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

- (void)beginDrag:(NSInteger)tag{
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    __weak typeof(self) weakSelf = self;
    [self.audioPlayer pause:NO];
    [self.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            weakSelf.progross = 0;
        }
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    
    self.draFlot = dratNum;
}
#pragma Mark - 音频播放模块
- (void)startRePlayer:(NSInteger)tag{//重新播放
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}
//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
    if (!(self.currentSection == 3)) {
        self.currentSection = 3;
        self.isReplay = YES;
        [self.audioPlayer stopPlaying];
        for (NoticeChats *chat in self.dataArr) {
            chat.isPlaying = NO;
            chat.nowPro = 0;
            chat.nowPro = 0;
            chat.nowTime = chat.resource_len;
        }
        for (NoticeChats *chat in self.localdataArr) {
            chat.isPlaying = NO;
            chat.nowPro = 0;
            chat.nowPro = 0;
            chat.nowTime = chat.resource_len;
        }
        [self.tableView reloadData];
    }
    if (!self.voiceM.voice_url) {
        return;
    }

    
    NoticeVoiceListModel *model = self.voiceM;
 
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        [self.headerTableView reloadData];
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.headerTableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            
            [weakSelf.headerTableView reloadData];
        }
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        [weakSelf.headerTableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeVoiceListCell *cell = [weakSelf.headerTableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1) || (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            [weakSelf.headerTableView reloadData];
            weakSelf.audioPlayer.playComplete = ^{
                
                cell.playerView.timeLen = model.voice_len;
                cell.playerView.slieView.progress = 0;
                model.nowPro = 0;
                model.nowTime = model.voice_len;
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.headerTableView reloadData];
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress =weakSelf.progross>0?weakSelf.progross: currentTime/model.voice_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;
  
        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

- (void)palyWithModel:(NoticeChats *)model{
    if (self.currentSection == 3 || !self.oldModel) {
        if (self.voiceM.content_type.intValue != 2) {
            [self.audioPlayer stopPlaying];
            self.voiceM.isPlaying = NO;
            self.voiceM.nowPro = 0;
            self.voiceM.nowTime = self.voiceM.voice_len;
            [self.headerTableView reloadData];
        }

        self.isReplay = YES;
    }
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
        [self.headerTableView reloadData];
        if (!model.read_at.integerValue && !model.is_self.integerValue) {
            [self setAleryRead:model];
        }
    }else{
        DRLog(@"点击的是当前视图");
    }
  
    if (self.isReplay || model.resource_len.integerValue == 1) {
        if (!model.read_at.integerValue && !model.is_self.integerValue) {
            [self setAleryRead:model];
        }
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:NO];
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:weakSelf.currentSection];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    self.audioPlayer.playComplete = ^{
        if (weakSelf.currentSection == 3) {
            return ;
        }
        if (!weakSelf.isTap) {
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            model.nowPro = 0;
            model.nowTime = model.resource_len;
            if (!weakSelf.isClickChonbo) {
                if (!model.is_self.integerValue) {
                    [weakSelf audioNextPlayer];
                }
            }else{
                weakSelf.isClickChonbo = NO;
            }
        }
         weakSelf.isTap = NO;
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:weakSelf.currentSection];
        NoticeChatsCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            cell.playerView.slieView.progress = 0;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.oldSection = 1000000;
            model.nowPro = 0;
            if ((model.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf.tableView reloadData];
            }
            model.nowTime = model.resource_len;
           // [weakSelf.tableView reloadData];
        }
        weakSelf.isTap = NO;
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)audioNextPlayer{
    if (self.currentSection == 3) {
        return;
    }
    if (self.noAuto) {
        self.noAuto = NO;
        return;
    }
    if (self.currentSection == 0) {//在第一组的时候
        
        if (self.dataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.dataArr[self.currentIndex+1];//获取最后一条信息
            if (!model.read_at.integerValue && !model.is_self.integerValue && model.resource_type.intValue == 1) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
                //[self palyNextWithModel:self.currentModel];
            }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self audioNextPlayer];
            }
        }else{//到了最后一条的时候，查询第二组是否存在未读消息
            if (self.localdataArr.count) {//如果第二组存在
                self.currentIndex = 0;
                self.currentSection = 1;
                NoticeChats *model = self.localdataArr[0];//获取第二组第一条信息
                if (!model.read_at.integerValue && !model.is_self.integerValue && model.resource_type.intValue == 1) {//判断是否是音频消息并且未读则继续自动播放
                    self.currentModel = model;
                    [self palyWithModel:self.currentModel];
                    //[self palyNextWithModel:self.currentModel];
                }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                    self.currentIndex ++;
                    self.currentSection = 1;
                    self.currentModel = model;
                    [self audioNextPlayer];
                }
            }
        }
    }else{//直接在第二组
        if (self.localdataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.localdataArr[self.currentIndex+1];//获取最后一条信息
            if (!model.read_at.integerValue && !model.is_self.integerValue && model.resource_type.intValue == 1) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
              //  [self palyNextWithModel:self.currentModel];
            }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self audioNextPlayer];
            }
        }
    }
}

- (void)beginDrag:(NSInteger)tag section:(NSInteger)section{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag section:(NSInteger)section{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag section:(NSInteger)section{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}
#pragma Mark - 音频播放模块
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{
    self.isTap = YES;
    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section{
    self.isClickChonbo = YES;
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 10040000;//设置个很大 数值以免冲突
    self.oldSection = 10004000;
    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}


- (void)deleteWithIndex:(NSInteger)tag section:(NSInteger)section{
    __weak typeof(self) weakSelf = self;
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
    self.choiceModel = deleteModel;
    if (deleteModel.is_self.integerValue) {
        if (deleteModel.resource_type.intValue == 2) {
            LCActionSheet *sheetd = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndexd) {
                if (buttonIndexd == 1) {
                    [weakSelf backMessage:tag tag:section deleteM:deleteModel];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"group.back"]]];
            sheetd.delegate = self;
            self.selfSheet = sheetd;
            [sheetd show];
            return;
        }
        LCActionSheet *sheetd = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndexd) {
            if (buttonIndexd == 2) {
                [weakSelf backMessage:tag tag:section deleteM:deleteModel];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"yl.schuisheng"],[NoticeTools getLocalStrWith:@"group.back"],@"语音转文字"]];
        sheetd.delegate = self;
        self.selfSheet = sheetd;
        [sheetd show];
        
        
    }else{
        if (self.choiceModel.resource_type.intValue == 1) {
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"yl.schuisheng"],[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"],@"语音转文字"]];
            sheet.delegate = self;
            self.juSheet = sheet;
            [sheet show];
        }else{
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
            } otherButtonTitleArray:@[[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"]]];
            sheet.delegate = self;
            self.juSheet = sheet;
            [sheet show];
        }
        
    }
    
}

- (void)changeToText:(NSString *)diologId{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dialogs/%@/recognitionContent",diologId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeChats *textM = [NoticeChats mj_objectWithKeyValues:dict[@"data"]];
            NoticeChangeTextView *changeView = [[NoticeChangeTextView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            changeView.voiceContent = (textM.recognition_content&&textM.recognition_content.length)?textM.recognition_content:@"转文字失败";
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)backMessage:(NSInteger)section tag:(NSInteger)tag deleteM:(NoticeChats *)deleteModel{
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
    [dsendDic setObject: [NSString stringWithFormat:@"%@%@",socketADD,self.userId] forKey:@"to"];
    [dsendDic setObject:@"singleChat" forKey:@"flag"];
    [dsendDic setObject:@"delete" forKey:@"action"];
    
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:self.voiceM.voice_id forKey:@"voiceId"];
    [messageDic setObject:deleteModel.chat_id forKey:@"chatId"];
    [messageDic setObject:deleteModel.dialog_id forKey:@"dialogId"];
    [messageDic setObject:@"1" forKey:@"chatType"];
    [dsendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:dsendDic];
    
    for (NoticeChats *norChat in self.nolmorLdataArr) {
        if ([norChat.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.nolmorLdataArr removeObject:norChat];
            break;
        }
    }
    if ([self.currentModel.dialog_id isEqualToString:deleteModel.dialog_id]) {
        [self.audioPlayer stopPlaying];
    }
    self.noAuto = YES;
    
    for (NoticeChats *allM in self.dataArr) {
        if ([allM.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.dataArr removeObject:allM];
            [self.tableView reloadData];
            break;
        }
    }
    for (NoticeChats *allM in self.localdataArr) {
        if ([allM.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.localdataArr removeObject:allM];
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 3) {
        [self changeToText:self.choiceModel.dialog_id];
    }
    if (self.choiceModel.resource_type.intValue == 2 && buttonIndex == 1) {
        if (self.choiceModel.isSelf) {
            return;
        }else{
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self.choiceModel.dialog_id;
            juBaoView.reouceType = @"3";
            [juBaoView showView];
        }
        return;
    }
    if (actionSheet == self.juSheet && buttonIndex == 2) {
        NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
        juBaoView.reouceId = self.choiceModel.dialog_id;
        juBaoView.reouceType = @"3";
        [juBaoView showView];
    }
    if (buttonIndex == 1) {
        [self collectionHS];
    }
}

- (void)collectionHS{
    NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT) isLimit:YES];
    _listView.dialogId = self.choiceModel.dialog_id;
    [_listView show];
}

- (void)setAleryRead:(NoticeChats *)chat{
    chat.read_at = [NoticeTools getNowTimeTimestamp];
    [self.tableView reloadData];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:[NoticeTools getNowTimeTimestamp] forKey:@"readAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",chat.chat_id,chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            DRLog([NoticeTools getLocalStrWith:@"lisnte.readed"]);
        }
    } fail:^(NSError *error) {
    }];
}


@end
