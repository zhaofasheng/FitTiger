//
//  NoticeVoiceGroundController.m
//  NoticeXi
//
//  Created by li lei on 2021/9/23.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceGroundController.h"
#import "NoticeNewSelfVoiceCell.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NoticeNewListCell.h"
#import "NewReplyVoiceView.h"
#import "NoticeTextVoiceController.h"
#import "NoticeRecoderController.h"
#import "NoticeDdcirHeaderView.h"

@interface NoticeVoiceGroundController ()<NoticeNewSelfVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate,NoticeNewVoiceListClickDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) UIView *footV;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isSendVoice;
@property (nonatomic, assign) BOOL canAutoLoad;
@property (nonatomic, assign) BOOL noData;
@property (nonatomic, strong) NoticeDdcirHeaderView *actHeaderView;

@end

@implementation NoticeVoiceGroundController

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    
    if (self.isActivity) {
        if (scrollView.contentOffset.y >= 76) {
            self.navigationItem.title = self.activityM.title;
        }else{
            self.navigationItem.title = @"";
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"JUSTREFRESHUSERINFORNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddChat:) name:@"ADDNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    
    self.canShowAssest = YES;
    
    if (!self.type) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }else{
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-(self.isOther?TAB_BAR_HEIGHT:0));
    }
    
    [self.tableView registerClass:[NoticeNewSelfVoiceCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[NoticeNewListCell class] forCellReuseIdentifier:@"cell1"];
    self.pageNo = 1;
    self.isDown = YES;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    if (!self.type && !self.isActivity && !self.isDate) {
        //声昔专属提示音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器模式
        [self.audioPlayer startPlayWithUrlandRecoding:[[NSBundle mainBundle] pathForResource:@"openvoice" ofType:@"mp3"] isLocalFile:YES];
        [self getTopDate];
//        
//        self.dataView = [[NoticeHeaderDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,55)];
//        self.tableView.tableHeaderView = self.dataView;
    }else{
        [self requestVoice];
    }
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    if (self.isActivity) {//活动心情
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.needBackGroundView = YES;
        
        UIButton *sendTcBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-68, DR_SCREEN_HEIGHT-40-68, 68, 68)];
        [sendTcBtn setBackgroundImage:UIImageNamed(@"Image_sendtcnew") forState:UIControlStateNormal];
        [self.view addSubview:sendTcBtn];
        [sendTcBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        
        NoticeDdcirHeaderView *actHeaderView = [[NoticeDdcirHeaderView alloc] init];
        actHeaderView.activityM = self.activityM;
        self.tableView.tableHeaderView = actHeaderView;
        self.actHeaderView = actHeaderView;
    }
    if (self.isDate) {
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.needBackGroundView = YES;
    }
    if (self.isPager) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
    }
    if (self.isUserCenter) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-44);
        if (self.isOther) {
          self.tableView.frame =  CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-(self.isOther?TAB_BAR_HEIGHT:0)-44);
        }
    }
}

- (void)sendClick{
    NoticeShareGroupView *sendView = [[NoticeShareGroupView alloc] initWithSendVoiceWith];
    __weak typeof(self) weakSelf = self;
    sendView.clickvoiceBtnBlock = ^(NSInteger voiceType) {
        if (voiceType == 1) {
            NoticeRecoderController *ctl = [[NoticeRecoderController alloc] init];
            ctl.topicId = self.activityM.topic_id;
            ctl.isFromActivity = YES;
            ctl.topicName = [self.activityM.title stringByReplacingOccurrencesOfString:@"#" withString:@""];
            CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                            withSubType:kCATransitionFromTop
                                                                               duration:0.3f
                                                                         timingFunction:kCAMediaTimingFunctionDefault
                                                                                   view:self.navigationController.view];
            [weakSelf.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
            [weakSelf.navigationController pushViewController:ctl animated:NO];
        }else{
            NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
            ctl.isFromActivity = YES;
            ctl.topicId = self.activityM.topic_id;
            ctl.topicName = [self.activityM.title stringByReplacingOccurrencesOfString:@"#" withString:@""];
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }
    };
    [sendView showShareView];
}

- (void)refreshList{
    if (self.type) {
        self.isDown = YES;
        [self requestVoice];
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (void)getAddChat:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.dialog_num = [NSString stringWithFormat:@"%d",voiceM.dialog_num.intValue+1];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)getDeleteChat:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.dialog_num = [NSString stringWithFormat:@"%d",voiceM.dialog_num.intValue-1];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}


- (void)selfChatNumView{
    if (self.playVoice) {
        self.playVoice(YES);
    }
    NewReplyVoiceView *replyView = [[NewReplyVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    replyView.voiceM = self.hsVoiceM;
    [replyView show];
}


- (void)clickHS:(NoticeVoiceListModel *)hsVoiceModel{
    self.hsVoiceM = hsVoiceModel;
    [self reSetPlayerData];
    if ([self.hsVoiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]){//自己的
        if (self.hsVoiceM.chat_num.intValue) {
            [self selfChatNumView];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"movie.nohs"]];
        }
        return;
    }
    if (self.playVoice) {
        self.playVoice(YES);
    }
    NoticeNewChatVoiceView *chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = self.hsVoiceM;
    chatView.userId = self.hsVoiceM.subUserModel.userId;
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId];
    chatView.chatId = self.hsVoiceM.chat_id;
    __weak typeof(self) weakSelf = self;
    chatView.hsBlock = ^(BOOL hs) {
        [weakSelf hs];
    };
    
    chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        NSMutableDictionary *sendDic = [NSMutableDictionary new];
        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,weakSelf.hsVoiceM.subUserModel.userId] forKey:@"to"];
        [sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:weakSelf.hsVoiceM.voice_id forKey:@"voiceId"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
        [sendDic setObject:messageDic forKey:@"data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:weakSelf userInfo:@{@"voiceId":weakSelf.hsVoiceM.voice_id}];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:sendDic];
        [weakSelf.tableView reloadData];
    };
    
    chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    [chatView show];
}

- (void)reRecoderLocalVoice{
    [self hs];
}

- (void)hs{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
    recodeView.isHS = YES;
    recodeView.needLongTap = YES;
    recodeView.hideCancel = NO;
    recodeView.delegate = self;
    recodeView.isReply = YES;
    recodeView.startRecdingNeed = YES;
    [recodeView show];
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.hsVoiceM.subUserModel.nick_name];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.hsVoiceM.subUserModel.nick_name]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.hsVoiceM.subUserModel.nick_name], 0.9) path:pathMd5 text:str];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [messageDic setObject:text forKey:@"dialogContentText"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
            [self.tableView reloadData];
        }
    }];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    if (self.isSendVoice) {

        return;
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [self showHUD];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [weakSelf hideHUD];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
            [self.tableView reloadData];
        }else{
            [weakSelf showToastWithText:Message];
            [weakSelf hideHUD];
        }
    }];
}


- (void)createRefesh{
    
    __weak NoticeVoiceGroundController *ctl = self;
    if (!self.type) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ctl.isDown = YES;
            ctl.pageNo = 1;
            if (!ctl.type && !ctl.isActivity && !ctl.isDate) {
                [ctl getTopDate];
            }else{
                [ctl requestVoice];
            }
            
        }];
        // 设置颜色
        header.stateLabel.textColor = GetColorWithName(VMainTextColor);
        header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
        self.tableView.mj_header = header;
    }
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestVoice];
    }];
}

- (void)getTopDate{
    if (!self.dataView.dataArr.count) {
        [self.dataView request];
    }
    
    [self reSetPlayerData];
    self.canNotLoadNewData = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/top" Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (self.isDown == YES) {
            [self.dataArr removeAllObjects];
            self.isDown = NO;
        }
  
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                model.topAt = @"4567890";
                model.isTop = YES;
                self.lastId = model.voice_id;
                [self.dataArr addObject:model];
            }
        }
        if (!self.dataArr.count) {
            self.isDown = YES;
        }
        [self requestVoice];
    } fail:^(NSError * _Nullable error) {
        if (self.isDown == YES) {
            self.isPushMoreToPlayer = NO;
            [self.dataArr removeAllObjects];
            self.isDown = NO;
        }
        if (!self.dataArr.count) {
            self.isDown = YES;
        }
        [self requestVoice];
    }];
}

- (void)requestVoice{

    NSString *url = nil;
    NSString *userId = self.isOther?self.userId: [NoticeTools getuserId];
    if (self.isDown) {
        self.oldModel.isPlaying = NO;
        self.oldModel.nowPro = 0;
        [self reSetPlayerData];
        url = [NSString stringWithFormat:@"users/%@/voices?pageNo=1&contentType=%d",userId,self.type==1?1:2];
        
        if (!self.type) {
            url = @"voices/list?pageNo=1";
        }
        
        if (self.isDate) {//按日历查心情
            url = [NSString stringWithFormat:@"users/voices/calendar/%@?pageNo=1",self.date];
        }
        
        if (self.istietie) {
            url = [NSString stringWithFormat:@"users/collection/voices/calendar/%@?pageNo=1",self.date];
        }
        
    }else{
        
        if (!self.canAutoLoad && self.pageNo != 1) {//接口正在加载中，无需重复请求
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        
        if (!self.type) {
            url = [NSString stringWithFormat:@"voices/list?pageNo=%ld",self.pageNo];
        }else{
            url = [NSString stringWithFormat:@"users/%@/voices?pageNo=%ld&contentType=%d",userId,self.pageNo,self.type==1?1:2];
        }
        
        if (self.isDate) {//按日历查贴贴心情
            url = [NSString stringWithFormat:@"users/voices/calendar/%@?pageNo=%ld",self.date,self.pageNo];
        }
        
        if (self.istietie) {
            url = [NSString stringWithFormat:@"users/collection/voices/calendar/%@?pageNo=%ld",self.date,self.pageNo];
        }
        self.canAutoLoad = NO;
    }
    
    if (self.isDown && self.isActivity) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"getActivityVoiceCount/%@",self.activityM.topic_id] Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeTopicModel *numM = [NoticeTopicModel mj_objectWithKeyValues:dict[@"data"]];
                self.actHeaderView.numL.text = [NSString stringWithFormat:@"%@%@",numM.num,[NoticeTools getLocalStrWith:@"py.ofnum"]];
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
    
    self.canNotLoadNewData = YES;
    
    NSString *accept = nil;
    if (self.isActivity) {
        accept = @"application/vnd.shengxi.v5.3.2+json";
    }else if (self.type){
        accept = @"application/vnd.shengxi.v5.5.1+json";
    }else if(self.isDate){
        accept = @"application/vnd.shengxi.v5.4.5+json";
    }else{
        accept = @"application/vnd.shengxi.v5.2.0+json";
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isActivity?[NSString stringWithFormat:@"activity/%@?pageNo=%ld",self.activityM.topic_id,self.pageNo]: url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        self.canNotLoadNewData = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.canAutoLoad = YES;
            if (self.isDown == YES) {
                self.isReplay = YES;
                self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            BOOL hasNewData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
         
                [self.dataArr addObject:model];
                hasNewData = YES;
            }
            
            if (!hasNewData) {
                self.noData = YES;
            }else{
                self.noData = NO;
                
            }

            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                self.tableView.tableFooterView = nil;
            }else{
                if (!self.isDate) {
                    self.tableView.tableFooterView = self.footV;
                }
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([NoticeComTools pareseError:error]){
            [self.noNetWorkView show];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.type) {
        if (indexPath.row <= self.dataArr.count-1) {
            NoticeVoiceListModel *model = self.dataArr[indexPath.row];
            return [NoticeComTools voiceCellHeight:model]-5;
        }
        return 0;
    }
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.is_private.boolValue && !model.statusM  && !model.topicName) {
        return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]]-54+10; 
    }
    return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArr.count >= 10) {
        if (indexPath.row == self.dataArr.count-3 && self.canAutoLoad && !self.noData) {
            self.pageNo++;
            self.isDown = NO;
            [self requestVoice];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.type) {
        NoticeNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (indexPath.row <= self.dataArr.count-1) {
            cell.isShareVoice = YES;
            cell.isHotLove = YES;
            cell.voiceM = self.dataArr[indexPath.row];
            cell.index = indexPath.row;
            [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
            cell.delegate = self;
        }
        return cell;
    }
    
    NoticeNewSelfVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isShareVoice = YES;
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

//共享或者取消共享成功
- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NoticeShopListController *ctl = [[NoticeShopListController alloc] init];
//    [self.navigationController pushViewController:ctl animated:YES];
//    return;

    if (!self.dataArr.count) {
        return;
    }
    
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.noPushToUserCenter = YES;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }else{
        NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.noPushToUserCenter = YES;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }
}

- (UIView *)footV{
    if (!_footV) {
        _footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-40)*180/335)];
        
        UIImageView *iamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)*180/335)];
        iamgeV.image = UIImageNamed(@"Image_noshare");
        [_footV addSubview:iamgeV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-40, iamgeV.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.7];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.text = [NoticeTools chinese:@"哦豁 什么都没有" english:@"Post something to create a stream" japan:@"何かを投稿してストリームを作成する"];
      
        [iamgeV addSubview:label];
    }
    return _footV;
}

#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{
  [self.tableView reloadData];
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    __weak typeof(self) weakSelf = self;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer pause:NO];
    [appdel.floatView.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
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
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer stopPlaying];
    self.isReplay = YES;
    [appdel.floatView.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}


- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{
    if (self.playVoice) {
        self.playVoice(YES);
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.dataArr.count && (self.floatView.currentTag <= self.dataArr.count-1) && appdel.floatView.currentTag == self.oldSelectIndex) {
        NoticeVoiceListModel *model = self.dataArr[self.floatView.currentTag];
        if (model.content_type.intValue != 1) {
            return;
        }
        if (playing) {
            self.isPasue = !pause;
            model.isPlaying = !pause;
            [self.tableView reloadData];
            if (!self.isPasue) {
                if (self.playVoice) {
                    self.playVoice(YES);
                }
            }
        }
    }
}

//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
   
    if (tag > self.dataArr.count-1) {
        return;
    }
    
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
        NoticeVoiceListModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        self.canReoadData = YES;
        appdel.floatView.voiceArr = self.dataArr.mutableCopy;
        appdel.floatView.currentTag = tag;
        appdel.floatView.currentModel = model;
        self.isReplay = NO;
        self.isPasue = NO;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;
        [appdel.floatView playClick];
        if (self.playVoice) {
            self.playVoice(YES);
        }
        [self addPlayNum:model];
    }else{
        [appdel.floatView playClick];
    }
    
    __weak typeof(self) weakSelf = self;
    appdel.floatView.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            if (self.canReoadData) {
                model.isPlaying = YES;
                [weakSelf.tableView reloadData];
            }
        }
    };
    
    appdel.floatView.playComplete = ^{
        weakSelf.canReoadData = NO;
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.voice_len;
        [weakSelf.tableView reloadData];
    };
    
    appdel.floatView.playNext = ^{
        weakSelf.canReoadData = NO;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        NoticeNewListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if (weakSelf.canReoadData) {
            if (!weakSelf.type) {
                cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
                cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
                model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
                model.nowPro = currentTime/model.voice_len.floatValue;
            }else{
                NoticeNewSelfVoiceCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
                cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
                model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
                model.nowPro = currentTime/model.voice_len.floatValue;
            }
        }else{
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    };
}

//屏蔽成功回调
- (void)otherPinbSuccess{
    [self.tableView.mj_header beginRefreshing];
}

//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        [appdel.floatView.audioPlayer stopPlaying];
    }
    
    if (!self.dataArr.count) {
        return;
    }
    
    if (self.dataArr.count-1 >= self.choicemoreTag) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
        [self.tableView reloadData];
    }
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    
    if (tag > self.dataArr.count-1) {
        return;
    }
    
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    [self.clickMore voiceClickMoreWith:model];
}

- (void)closeClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                    withSubType:kCATransitionFromBottom
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController popViewControllerAnimated:NO];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}
//

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeSkin];
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)changeSkin{
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.tableView.backgroundColor = self.view.backgroundColor;
}

@end
