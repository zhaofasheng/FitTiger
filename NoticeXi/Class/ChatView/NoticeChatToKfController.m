//
//  NoticeChatToKfController.m
//  NoticeXi
//
//  Created by li lei on 2020/8/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatToKfController.h"
#import "NoticrGroupInputView.h"
#import "DDHAttributedMode.h"
#import "AppDelegate.h"
#import "NoticeSCCell.h"
#import "NoticeNoticenterModel.h"
#import "NoticeDevoiceM.h"
#import "NoticeSendViewController.h"
#import "NoticrChatLike.h"
#import "NoticeXi-Swift.h"
#import "NoticeSetYuReplyController.h"
#import "NoticeWebViewController.h"
#import "NoticeYuSetModel.h"
#import "NoticeChatTitleView.h"
#import "NoticeAction.h"
#import "NoticeIntuputTextController.h"
#import "NoticeClipImage.h"
#import "NoticeHasCenterData.h"
#import "NoticeDefaultMessageView.h"
#import "LHEditTextView.h"
#import "AFHTTPSessionManager.h"
#import "NoticeNoReandView.h"
#import "NoticeScroEmtionView.h"

@interface NoticeChatToKfController ()<TZImagePickerControllerDelegate,NoticeReceveMessageSendMessageDelegate,NoticeSCDeledate,LCActionSheetDelegate,NoticeSendTextDelegate,NoticeSendDefaultClickDelegate,NoticeChatGroupDelegate>

@property (nonatomic, strong) NoticrGroupInputView *inputView;
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, assign) BOOL hasTips;
@property (nonatomic, assign) BOOL hasHobbys;
@property (nonatomic, strong) NoticeChats *tapChat;
@property (nonatomic, strong) NoticeChats *oldModel;
@property (nonatomic, strong) NoticeChats *currentModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger currentAutoIndex;
@property (nonatomic, assign) NSInteger currentAutoSection;
@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic, assign) BOOL isoffline;
@property (nonatomic, assign) NSInteger reSendTime;
@property (nonatomic, strong) NSString *autoId;
@property (nonatomic, assign) BOOL firstIn;
@property (nonatomic, assign) BOOL noAuto;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) NSInteger sendTimeNum;
@property (nonatomic, assign) BOOL isClickChongBo;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, strong) LCActionSheet *cellSheet;
@property (nonatomic, strong) LCActionSheet *yusSheet;
@property (nonatomic, strong) NSMutableArray *yuseArr;
@property (nonatomic, strong) NSMutableArray *yuseImgArr;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) NSMutableArray *yuseStrArr;
@property (nonatomic, strong) NSMutableArray *cacheArr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *chatTiemId;
@property (nonatomic, strong) NoticeChatTitleView *ttitleV;
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSString *yuseLastId;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, strong) NSMutableArray *largePhotoArr;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, strong) NoticeNoReandView *readView;
@property (nonatomic, assign) NSInteger messageNum;
@property (nonatomic, assign) CGFloat tableViewOrinY;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic, assign) BOOL moreOpen;//更多视图打开
@end

@implementation NoticeChatToKfController
- (NSMutableArray *)largePhotoArr{
    if (!_largePhotoArr) {
        _largePhotoArr = [NSMutableArray new];
    }
    return _largePhotoArr;
}
- (NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [NSMutableArray new];
    }
    return _photoArr;
}

- (NSMutableArray *)imgArr
{
    if (!_imgArr) {
        _imgArr = [NSMutableArray new];
    }
    return _imgArr;
}
- (NSMutableArray *)yuseImgArr{
    if (!_yuseImgArr) {
        _yuseImgArr = [NSMutableArray new];
    }
    return _yuseImgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canLoad = YES;
    [self request];
    [self requestYUse:NO];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        DRLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];
    
    self.firstIn = YES;
    self.oldSection = 10000;
    self.isFirst = YES;
    self.dataArr = [NSMutableArray new];
    self.nolmorLdataArr = [NSMutableArray new];
    self.localdataArr = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0,([self.toUserId isEqualToString:@"1"] ? 100 : 50)+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-NAVIGATION_BAR_HEIGHT-([self.toUserId isEqualToString:@"1"] ? 100 : 50));
    [self.tableView registerClass:[NoticeSCCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self createRefesh];

    _sendDic = [NSMutableDictionary new];
    [_sendDic setObject:self.toUser ? self.toUser : @"noNet" forKey:@"to"];
    [_sendDic setObject:@"singleChat" forKey:@"flag"];
    

    self.emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+BOTTOM_HEIGHT+15)];
    self.emotionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    __weak typeof(self) weakSelf = self;
    self.emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:@"0" forKey:@"voiceId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject: @"10" forKey:@"dialogContentLen"];
        [weakSelf.sendDic setObject:messageDic forKey:@"data"];
         AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:weakSelf.sendDic];
    };

    [self.view addSubview:self.emotionView];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.delegate = self;

    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30,100)];
    infoL.font = ELEVENTEXTFONTSIZE;
    infoL.numberOfLines = 0;
    infoL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    infoL.textColor = [UIColor colorWithHexString:@"#14151A"];
    self.infoL = infoL;
    [self.view addSubview:infoL];
    [self requestDevoice];
    
    self.tableViewOrinY = ([self.toUserId isEqualToString:@"1"] ? 72 : 0)+NAVIGATION_BAR_HEIGHT;
    self.tableView.frame = CGRectMake(0,100+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-NAVIGATION_BAR_HEIGHT-100);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestReplay) name:@"CHANGEYUSEREPLAY" object:nil];
    [self requestData];
    
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    

    self.navBarView.titleL.text = self.navigationItem.title;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];

    self.inputView = [[NoticrGroupInputView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH,50)];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    self.inputView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH,50);
}

- (void)backToPageAction{
    BOOL hasFail = NO;
    for (NoticeChats *chat in self.localdataArr) {
        if (chat.isFailed) {
            hasFail = YES;
            break;
        }
    }
    if (hasFail) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"离开对话后，发送失败的语音将不会保存" message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)requestReplay{
    [self requestYUse:NO];
}

- (void)request{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            [NoticeSaveModel saveUserInfo:userIn];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)didReceiveMessage:(id)message{

    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [ NoticeChats mj_objectWithKeyValues:message[@"data"]];
    if ([chat.flag isEqualToString:@"1"]) {
        return;
    }
    
    DRLog(@"收到私信:%@",message);
    
    if ([ifDelegate.action isEqualToString:@"delete"]) {
        NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"%@私聊（%@和%@的私聊）",[NoticeTools getNowTime],[[NoticeSaveModel getUserInfo] user_id],self.toUserId] reason:[NSString stringWithFormat:@"%@ 收到对方删除私聊%@",[[NoticeSaveModel getUserInfo] user_id],[NoticeTools getNowTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
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
    
    if (![chat.chat_type isEqualToString:@"2"]) {
        NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"%@私聊（%@和%@的私聊）",[NoticeTools getNowTime],[[NoticeSaveModel getUserInfo] user_id],self.toUserId] reason:[NSString stringWithFormat:@"%@ 不是私聊类型%@",[[NoticeSaveModel getUserInfo] user_id],[NoticeTools getNowTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        return;
    }
    
    chat.read_at = @"0";
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//当发送人不是自己的时候，需要判断是否是当前会话人发来的消息，不然容易消息错误
        if (![chat.from_user_id isEqualToString:self.toUserId]) {//别人发来的消息，判断是否是当前对话人
   
            return;
        }
    }else{//发送人是自己的时候
        self.noAuto = NO;
    }
    
    if ([chat.resource_type isEqualToString:@"4"] || [chat.resource_type isEqualToString:@"1"]) {
        chat.dialog_content = chat.dialog_content.length?chat.dialog_content:@"转文字失败";
    }
    
    BOOL alerady = NO;
    for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
        if ([olM.dialog_id isEqualToString:chat.dialog_id]) {
            alerady = YES;
            break;
        }
    }
    
    if (!alerady) {
        self.chatId = chat.chat_id;
        for (int i = 0; i < self.localdataArr.count; i++) {//替代本地音频
            NoticeChats *localChat = self.localdataArr[i];
            if (localChat.isLocal && [localChat.dialog_content_uri isEqualToString:chat.dialog_content_uri]) {
                [self.localdataArr removeObjectAtIndex:i];
                break;
            }
        }
        if (chat.resource_type.intValue == 2) {
            NSArray *array3 = [chat.resource_url componentsSeparatedByString:@"?"];
            YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
            item2.smallUrlString = chat.resource_url;
            item2.largeImageURL     = [NSURL URLWithString:array3[0]];
            [self.largePhotoArr insertObject:item2 atIndex:0];
        }
        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
        
        if (!self.canLoad) {
            self.messageNum++;
            self.readView.frame = CGRectMake(DR_SCREEN_WIDTH-15-30,_inputView.frame.origin.y-5-30, 30, 30);
            self.readView.hidden = NO;
            self.readView.numL.text = [NSString stringWithFormat:@"%ld",self.messageNum];
        }
    }
    


    [self scroToBottom];
}
- (void)clickCanLoadTap{
    _readView.hidden = YES;
    self.messageNum = 0;
    self.canLoad = YES;
    [self scroToBottom];
}

- (NoticeNoReandView *)readView{
    if (!_readView) {
        _readView = [[NoticeNoReandView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-30,_inputView.frame.origin.y-5-30, 30, 30)];
        _readView.hidden = YES;
        _readView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCanLoadTap)];
        [_readView addGestureRecognizer:tap];
        [self.view addSubview:_readView];
    }
    return _readView;
}

- (void)scroToBottom{
    if (!self.canLoad) {
        return;
    }
    _readView.hidden = YES;
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
     //[self.tableView scrollRectToVisible:CGRectMake(0,self.tableView.frame.size.height, 1,self.tableView.frame.size.height) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(y > h -50) {
        self.canLoad = YES;
        _readView.hidden = YES;
    }else{
        self.canLoad = NO;
    }
}

//发送失败点击重新发送
- (void)failReSend:(NSInteger)section row:(NSInteger)row chatM:(NoticeChats *)chat{
    [_sendDic setObject:chat.sendDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self->_sendDic];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waitMessage) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [NoticeTools setSHAKE:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NoticeTools setSHAKE:YES];
    self.noAuto = YES;
    [self.audioPlayer pause:YES];
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
}


//开始录音
- (void)onStartRecording{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (self.oldModel) {
        self.oldModel.isPlaying = NO;
        [self.tableView reloadData];
    }
    
    self.noAuto = YES;
    [self.audioPlayer pause:YES];
    self.isReplay = YES;
    self.oldSelectIndex = 1000000;
    self.oldSection = 1000000000;
    [self.audioPlayer stopPlaying];
}

- (void)onStopRecording{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)onCancelRecording{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
    }
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
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
    NoticeChats *chat =  indexPath.section == 1 ? self.localdataArr[indexPath.row] : self.dataArr[indexPath.row];

    if ([self.toUserId isEqualToString:@"1"]) {
        if ([[NoticeTimeTools needShowTimeMark] isEqualToString:@"开发者等下就来"] && !chat.needMarkAuto) {
            chat.needMarkAuto = NO;
        }else{
            chat.needMarkAuto = [NoticeTimeTools needShowTimeMark];
        }
    }
    
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
    
    if (chat.contentText && chat.contentText.length) {
        return 28+chat.textHeight+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    
    if (chat.isShowTime) {
      
        if ([chat.resource_type isEqualToString:@"4"] || [chat.resource_type isEqualToString:@"1"]) {
            return 35+28+16+(chat.needMarkAuto ? 30 : 0) + (chat.offline_prompt ? 55 : 0) + ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"] ? ((chat.dialog_content.length? (chat.contentHeight+15) : 0)) : 0);
            
        }
        return 28+(chat.imgCellHeight?chat.imgCellHeight: 138)+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    

    if ([chat.resource_type isEqualToString:@"4"] || [chat.resource_type isEqualToString:@"1"]) {
        return 35+28+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0) + ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"] ? ((chat.dialog_content.length? (chat.contentHeight+15) : 0)) : 0);//最后一个表示是客服的同时，存在语音转文字
    }
    return 28+ (chat.imgCellHeight?chat.imgCellHeight: 138) +(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isAuto && !self.dataArr.count && section == 0) {
        return 26;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isAuto && !self.dataArr.count && section == 0) {
        UILabel * _markL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,30)];
        _markL.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#B5B5B5"]:[UIColor colorWithHexString:@"#72727F"];
        _markL.textAlignment = NSTextAlignmentCenter;
        _markL.font = ELEVENTEXTFONTSIZE;
        _markL.text = [NoticeTools isSimpleLau]? @"对方可能不方便立刻回复":@"對方可能不方便立刻回復";
        _markL.numberOfLines = 0;
        return _markL;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentPath = indexPath;
    __weak typeof(self) weakSelf = self;
    cell.refreshHeightBlock = ^(NSIndexPath * _Nonnull indxPath) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        [weakSelf scroToBottom];
    };
    
    cell.needHelp = self.isNeedHelp;
    NoticeChats *chat = nil;
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
    cell.toUserId = self.toUserId;
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
    
    if (!chat.is_self.integerValue) {
        chat.identity_type = self.identType;
    }else{
        chat.identity_type = [[NoticeSaveModel getUserInfo] identity_type];
    }
    
    cell.chat = chat;
    cell.lagerPhotoArr = self.largePhotoArr;
    cell.playerView.timeLen = chat.resource_len;
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.playerView.slieView.progress = 0;
    [cell.playerView.playButton setImage:UIImageNamed(!chat.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    
    return cell;
}

- (void)setYuClick{

    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        if (buttonIndex == 1) {
            NoticeSetYuReplyController *ctl = [[NoticeSetYuReplyController alloc] init];
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else if (buttonIndex == 2){
            LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                if (buttonIndex1 == 0) {
                    return ;
                }
                if (buttonIndex1 == 1){
                    NSMutableDictionary *parm = [NSMutableDictionary new];
                    [parm setObject:self.toUserId forKey:@"toUserId"];
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"loginCheckCode/sms" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        if (success) {
                            [weakSelf showToastWithText:@"短信已发送"];
                        }
                    } fail:^(NSError * _Nullable error) {
                        
                    }];
                    
                }
            } otherButtonTitleArray:@[@"确定发送"]];
            [sheet1 show];

        }
    } otherButtonTitleArray:@[@"设置预设回复语",@"发送密码提示短信"]];
    [sheet show];
}


- (void)refreshTableViewWithFrame:(CGRect)frame keyBordyHight:(CGFloat)keybordHeight{
    
}

- (void)sendImageDelegate{
    [self sendImageView];
}

- (void)sendContent:(NSString *__nullable)content{
    [self sendTextDelegate:content];
}

- (void)sendVoiceDelegate{
    
}
- (void)refreshTableViewWithHideFrame:(CGRect)frame{
    
}

- (void)sendEmotionOpen{
    
}

- (void)sendEmotionClose{
    
}

//发送预设语音
- (void)sendDefault{
    NoticeDefaultMessageView *defautView = [[NoticeDefaultMessageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    defautView.delegate = self;
    defautView.dataArr = self.yuseArr;
    defautView.imgArr = self.yuseImgArr;
    [defautView.tableView reloadData];
    [defautView show];
}

- (void)sendMessageWithDefault:(NoticeYuSetModel *)model{
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:model.bucket_id?model.bucket_id:@"0" forKey:@"bucketId"];
    [messageDic setObject:model.resource_type forKey:@"dialogContentType"];
    [messageDic setObject:model.resource_uri forKey:@"dialogContentUri"];
    [messageDic setObject:model.resource_len forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

//发送音频
- (void)sendTime:(NSInteger)time path:(NSString *)path{
    NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"%@私聊步骤1（%@和%@的私聊）",[NoticeTools getNowTime],[[NoticeSaveModel getUserInfo] user_id],self.toUserId] reason:[NSString stringWithFormat:@"%@音频文件发送%@",[[NoticeSaveModel getUserInfo] user_id],[NoticeTools getNowTime]] userInfo:nil];//数据上报
    [Bugly reportException:exception];
    
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"%@私聊（%@和%@的私聊）",[NoticeTools getNowTime],[[NoticeSaveModel getUserInfo] user_id],self.toUserId] reason:[NSString stringWithFormat:@"%@音频文件不存在%@",[[NoticeSaveModel getUserInfo] user_id],[NoticeTools getNowTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        return;
    }
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSection = 10032;
    self.oldSelectIndex = 4324;
    for (NoticeChats * chat in self.dataArr) {
        chat.isPlaying = NO;
        [self.tableView reloadData];
    }
    for (NoticeChats * chat in self.localdataArr) {
        chat.isPlaying = NO;
        [self.tableView reloadData];
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,path]],[path pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"4" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    
    //本地数据缓存以防发送失败
    NoticeChats *sendChat = [[NoticeChats alloc] init];
    sendChat.isLocal = YES;
    sendChat.is_self = @"1";
    sendChat.chat_type = @"2";
    sendChat.dialog_content_len = [NSString stringWithFormat:@"%ld",(long)time];
    sendChat.dialog_content_type = @"1";
    sendChat.from_user_id = [NoticeTools getuserId];
    sendChat.user_avatar_url = [[NoticeSaveModel getUserInfo] avatar_url];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:path parm:parm1 progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId,BOOL sussess) {
        if (sussess) {
            self.reSendTime = 0;
            self.sendTimeNum = 0;
            [self.timer invalidate];
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            sendChat.dialog_content_uri = Message;
            if (self.isNeedHelp) {
                [messageDic setObject:@"1" forKey:@"topicType"];
            }
            [messageDic setObject:[NSString stringWithFormat:@"%ld",(long)time] forKey:@"dialogContentLen"];
            [self->_sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:self->_sendDic];
            
            sendChat.sendDic = messageDic;
            [self.localdataArr addObject:sendChat];
            [self.tableView reloadData];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitMessage) userInfo:nil repeats:YES];
            NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"%@私聊步骤2（%@和%@的私聊）",[NoticeTools getNowTime],[[NoticeSaveModel getUserInfo] user_id],self.toUserId] reason:[NSString stringWithFormat:@"%@音频文件发送成功%@",[[NoticeSaveModel getUserInfo] user_id],[NoticeTools getNowTime]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [self hideHUD];
        } else{
            [self hideHUD];
            if (self.reSendTime < 2) {
                self.reSendTime++;
                [self sendTime:time path:path];
            }
            NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"%@私聊（%@和%@的私聊）",[NoticeTools getNowTime],[[NoticeSaveModel getUserInfo] user_id],self.toUserId] reason:[NSString stringWithFormat:@"%@音频文件上传失败%@-%@",[[NoticeSaveModel getUserInfo] user_id],[NoticeTools getNowTime],error.description] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [self showToastWithText:Message];
        }
    }];
}

//等待时间超过五秒标记为失败
- (void)waitMessage{
    self.sendTimeNum++;
    if (self.sendTimeNum == 5) {
        for (NoticeChats *chat in self.localdataArr) {
            if (chat.isLocal) {
                chat.isFailed = YES;
            }
        }
        [self.tableView reloadData];
        self.sendTimeNum = 0;
        [self.timer invalidate];
    }
}


- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.navigationItem.title]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.navigationItem.title], 0.9) path:pathMd5 text:str];
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
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:text forKey:@"dialogContentText"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [self->_sendDic setObject:messageDic forKey:@"data"];
             AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:self->_sendDic];
            [self hideHUD];
            
        }else{
            [self showToastWithText:errorMessage];
        }
    }];
}

//发送图片
- (void)sendImageView{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    self.photoArr = [NSMutableArray arrayWithArray:assets];
    self.imgArr = [NSMutableArray arrayWithArray:photos];
    [self sendImagePhoto];
}

- (void)sendImagePhoto{
    if (!self.photoArr.count) {
        return;
    }
    PHAsset *asset = self.photoArr[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [self showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999999996];
            [self upLoadHeader:imageData path:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]]];
        }];
    }else{
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!self.imgArr.count) {
                [self showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
            NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
            [self upLoadHeader:UIImageJPEGRepresentation(self.imgArr[0], 0.7) path:pathMd5];
        }];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path{

    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    NSInteger length = [image length]/1024;
    [[XGUploadDateManager sharedManager] uploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:length? [NSString stringWithFormat:@"%ld",(long)length] : @"10" forKey:@"dialogContentLen"];
            [self->_sendDic setObject:messageDic forKey:@"data"];
             AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:self->_sendDic];
            if (self.photoArr.count) {
                [self.photoArr removeObjectAtIndex:0];
                if (self.imgArr.count) {
                    [self.imgArr removeObjectAtIndex:0];
                }
                if (self.photoArr.count) {
                    [self sendImagePhoto];
                }
            }
            [self hideHUD];
            
        }else{
            [self showToastWithText:errorMessage];
        }
    }];
}

- (void)requestData{
    NSString *url = nil;
    
    if (!self.isFirst && !self.toUserId) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (self.isFirst) {
        url = [NSString stringWithFormat:@"chats/2/%@/0",self.toUserId];
    }else{
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"chats/2/%@/0",self.toUserId];
        }else{
            if (self.lastId) {
                url = [NSString stringWithFormat:@"chats/2/%@/0?lastId=%@",self.toUserId,self.lastId];
            }else{
                self.isDown = NO;
                url = [NSString stringWithFormat:@"chats/2/%@/0",self.toUserId];
            }
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting/autoReply",self.toUserId] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            NoticeNoticenterModel*noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.isAuto = noticeM.auto_reply.integerValue;
        }
        [self requestWith:url];
    } fail:^(NSError *error) {
        [self requestWith:url];
    }];

}

- (void)requestWith:(NSString *)url{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
                if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && [[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
                    model.dialog_content = model.dialog_content.length ? model.dialog_content : @"转文字失败";
                }
                
                BOOL alerady = NO;
                for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
                    if ([olM.dialog_id isEqualToString:model.dialog_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    if (model.resource_type.intValue == 2) {
                         NSArray *array3 = [model.resource_url componentsSeparatedByString:@"?"];
                         YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
                         item2.smallUrlString = model.resource_url;
                         item2.largeImageURL     = [NSURL URLWithString:array3[0]];
                         [self.largePhotoArr insertObject:item2 atIndex:0];
                     }
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
                [self scroToBottom];
            }
     
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//获取设备信息
- (void)requestDevoice{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/statistics",self.toUserId] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeHasCenterData *model = [NoticeHasCenterData mj_objectWithKeyValues:dict[@"data"]];
            NSString *sex = nil;
            if ([model.gender isEqualToString:@"1"]) {
                sex = @"男";
            }else if ([model.gender isEqualToString:@"2"]){
                sex = @"女";
            }
            if (sex) {
                self.infoL.text = [NSString stringWithFormat:@"对方类型:%@%@ %@/%@\n\n学号:%@ 来了%@天 共%@个好友 心情:%@条,共%@\n\n书:%@   影:%@  音:%@  画:%@  配音:%@  台词:%@\n\n最近三天共享心情:%@条",model.personality_no,sex,model.last_login_device,model.app_version,model.frequency_no,model.comeHereTime,model.friend_num,model.voice_num,model.voice_total_len,model.voice_book_num,model.voice_movie_num,model.voice_song_num,model.artwork_num,model.dubbing_num,model.line_num,model.voice_three_days_share];
            }else{
                self.infoL.text = [NSString stringWithFormat:@"对方类型: %@/%@\n\n学号:%@ 来了%@天 共%@个好友 心情:%@条,共%@\n\n书:%@   影:%@  音:%@  画:%@  配音:%@  台词:%@\n\n最近三天共享心情:%@条",model.last_login_device,model.app_version,model.frequency_no,model.comeHereTime,model.friend_num,model.voice_num,model.voice_total_len,model.voice_book_num,model.voice_movie_num,model.voice_song_num,model.artwork_num,model.dubbing_num,model.line_num,model.voice_three_days_share];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)createRefesh{
    
    __weak NoticeChatToKfController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)palyWithModel:(NoticeChats *)model{
    
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
    if (!model.read_at.integerValue && !model.is_self.integerValue) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:self.currentSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self setAleryRead:model];
    }
    
    if (self.isReplay || model.resource_len.integerValue == 1) {
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
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    
    self.audioPlayer.playComplete = ^{
        if (!weakSelf.isTap) {
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            model.nowPro = 0;
            model.nowTime = model.resource_len;
            if (!model.is_self.integerValue) {
                if (!weakSelf.isClickChongBo) {
                    [weakSelf audioNextPlayer];
                }else{
                    weakSelf.isClickChongBo = NO;
                }
            }
        }
        weakSelf.isTap = NO;
        [weakSelf.tableView reloadData];
    };

    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:weakSelf.currentSection];
        
        NoticeSCCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            cell.playerView.slieView.progress = 0;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.oldSection = 1000000;
            if ((model.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf.tableView reloadData];
            }
            model.nowPro = 0;
            model.nowTime = model.resource_len;
        }
        weakSelf.isTap = NO;
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)audioNextPlayer{
    
    if (self.noAuto) {
        self.noAuto = NO;
        return;
    }
    
    if (self.currentSection == 0) {//在第一组的时候
        if (self.dataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.dataArr[self.currentIndex+1];//获取最后一条信息
            if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && !model.read_at.integerValue && !model.is_self.integerValue) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
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
                if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && !model.read_at.integerValue && !model.is_self.integerValue) {//判断是否是音频消息并且未读则继续自动播放
                    self.currentModel = model;
                    [self palyWithModel:self.currentModel];
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
            if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && !model.read_at.integerValue && !model.is_self.integerValue) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
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
    [self.tableView reloadData];
    self.currentIndex = tag;
    self.currentSection = section;
    self.isTap = YES;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section{
    self.isClickChongBo = YES;
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 10040000;//设置个很大 数值以免冲突
    self.oldSection = 10004000;
    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)actionClick{
    if (self.isKeFu) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[@"删除交流记录(对方记录也会删除)"]];
        sheet.delegate = self;
        [sheet show];
    }else{
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.hide"],@"删除交流记录(对方记录也会删除)",[NoticeTools getLocalStrWith:@"chat.jubao"]]];
        sheet.delegate = self;
        [sheet show];
    }
}

- (void)jubao{
    NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithLeaderJuBaoView];
    [pinV showTostView];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.yusSheet) {
        return;
    }
    if (actionSheet == self.cellSheet) {
        if (!([self.tapChat.resource_type isEqualToString:@"4"] || [self.tapChat.resource_type isEqualToString:@"1"])) {
            if (buttonIndex == 1) {
                buttonIndex = 2;
            }
        }
       if (buttonIndex == 2 && !self.tapChat.is_self.integerValue){//举报
           NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
           juBaoView.reouceId = self.tapChat.dialog_id;
           juBaoView.reouceType = @"3";
           [juBaoView showView];
        }
        if (buttonIndex == 1) {
            [self collectionChat];
        }
        if (buttonIndex == 3 && self.tapChat.is_self.intValue) {
            [LHEditTextView showWithController:self andRequestDataBlock:^(NSString *message) {
                if (self.tapChat.resource_type.intValue == 1) {
                    [self showHUD];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tapChat.resource_url]];
                    //返回一个下载任务对象
                   __block NSString *name;
                    NSURLSessionDownloadTask *loadTask = [manager downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                        name = [NSString stringWithFormat:@"%@=%@",[[NoticeSaveModel getUserInfo] user_id],response.suggestedFilename];
                        NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];

                        //这个block 需要返回一个目标 地址 存储下载的文件
                        return  [NSURL fileURLWithPath:fullPath];
                    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                        NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,filePath]]];//音频本地路径转换为md5字符串
                        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                        [parm setObject:@"19" forKey:@"resourceType"];
                        [parm setObject:pathMd5 forKey:@"resourceContent"];
                        
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSString *document= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                        NSArray *fileList ;
                        fileList =[fileManager contentsOfDirectoryAtPath:document error:NULL];
                        NSString *pathAll = nil;
                        for (NSString *file in fileList) {
                            NSString *path =[document stringByAppendingPathComponent:file];
                            if ([[path lastPathComponent] isEqualToString:name]) {
                                DRLog(@"得到的路径=%@\n%@",path,[path lastPathComponent]);
                                pathAll = path;
                                break;
                            }
                        }
                        if (!pathAll) {
                            return ;
                        }
                        [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:pathAll parm:parm progressHandler:^(CGFloat progress) {
                            
                        } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
                            if (sussess) {
                                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                                [parm setObject:@"1" forKey:@"resourceType"];
                                [parm setObject:Message forKey:@"resourceUri"];
                                [parm setObject:self.tapChat.resource_len forKey:@"resourceLen"];
                                [parm setObject:message forKey:@"replyRemark"];
                                if (bucketId) {
                                    [parm setObject:bucketId forKey:@"bucketId"];
                                }
                                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                                    [self hideHUD];
                                    if (success) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
                                    }
                                } fail:^(NSError *error) {
                                    [self hideHUD];
                                }];
                                
                            }else{
                                [self showToastWithText:Message];
                                [self hideHUD];
                            }
                        }];
                      
                    }];
                    
                    //启动下载任务--开始下载
                    [loadTask resume];
                }else{
                   [self upLoadHeader:self.tapChat.downImage path:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999] withDate:message];
                }
                
            }];
        }
        return;
    }
    
    if (self.isKeFu) {
        if (buttonIndex == 1) {
            [self clearMemory];
        }
    }else{
        if (buttonIndex == 2) {
            [self clearMemory];
        }else if (buttonIndex == 1){
            [self lahei];
        }else if (buttonIndex == 3){
            [self jubao];
        }
    }
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"19" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"resourceType"];
            [parm setObject:Message forKey:@"resourceUri"];
            [parm setObject:@"567" forKey:@"resourceLen"];
            [parm setObject:date forKey:@""];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [parm setObject:date forKey:@"replyRemark"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    [self showToastWithText:@"已设置为预设回复"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:Message];
        }
    }];
}

- (void)collectionChat{
    if ([self.tapChat.resource_type isEqualToString:@"4"] || [self.tapChat.resource_type isEqualToString:@"1"]) {
        if (self.tapChat.dialog_id) {
            NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT) isLimit:YES];
            _listView.dialogId = self.tapChat.dialog_id;
            [_listView show];
        }
    }else{
        [self showToastWithText:@"只能收藏语音哦"];
    }

}


//长按删除
- (void)longTapCancelWithSection:(NSInteger)section tag:(NSInteger)tag{
    __weak typeof(self) weakSelf = self;
   
    NoticeChats *chat = nil;
    if (section == 0) {
        chat = self.dataArr[tag];
    }else{
        chat = self.localdataArr[tag];
    }
    self.tapChat = chat;
    NSArray *arr = ([self.tapChat.resource_type isEqualToString:@"4"] || [self.tapChat.resource_type isEqualToString:@"1"])?@[[NoticeTools getLocalStrWith:@"yl.sctodui"],chat.is_self.integerValue?[NoticeTools getLocalStrWith:@"group.back"]:[NoticeTools getLocalStrWith:@"chat.jubao"]]:@[chat.is_self.integerValue?[NoticeTools getLocalStrWith:@"group.back"]:[NoticeTools getLocalStrWith:@"chat.jubao"]];
    if (chat.isSelf) {
        arr = @[[NoticeTools getLocalStrWith:@"yl.sctodui"],[NoticeTools getLocalStrWith:@"group.back"],@"设置为预设回复"];
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

        if (buttonIndex == 2 && chat.is_self.integerValue) {//撤回
           
            NSMutableDictionary * dsendDic = [NSMutableDictionary new];
            [dsendDic setObject:weakSelf.toUser ? weakSelf.toUser : @"noNet" forKey:@"to"];
            [dsendDic setObject:@"singleChat" forKey:@"flag"];
            [dsendDic setObject:@"delete" forKey:@"action"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"2" forKey:@"chatType"];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject:chat.chat_id forKey:@"chatId"];
            [messageDic setObject:chat.dialog_id forKey:@"dialogId"];
            [dsendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:dsendDic];
            
            for (NoticeChats *norChat in self.nolmorLdataArr) {
                if ([norChat.dialog_id isEqualToString:chat.dialog_id]) {
                    [self.nolmorLdataArr removeObject:norChat];
                    break;
                }
            }
            
            if ([self.currentModel.dialog_id isEqualToString:chat.dialog_id]) {
                [self.audioPlayer stopPlaying];
            }
            
            self.noAuto = YES;
            if (section == 0) {
                if (tag <= self.dataArr.count-1) {
                    [weakSelf.dataArr removeObjectAtIndex:tag];
                }
            }else{
                if (tag <= weakSelf.localdataArr.count-1) {
                    [weakSelf.localdataArr removeObjectAtIndex:tag];
                }
            }
            [weakSelf.tableView reloadData];
        }
    } otherButtonTitleArray:arr];
    self.cellSheet = sheet;
    sheet.delegate = self;
    [sheet show];
}

- (void)failReSendchatM:(nonnull NoticeChats *)chat {
    
}

- (void)clearMemory{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"songList.suredele"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"chats/%@",weakSelf.chatId] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)lahei{
    __weak typeof(self) weakSelf = self;
    NoticePinBiView *pinView = [[NoticePinBiView alloc] initWithPinBiView];
    pinView.ChoiceType = ^(NSInteger type) {
        [weakSelf showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.toUserId forKey:@"toUserId"];
        [parm setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"reasonType"];
        [parm setObject:@"4" forKey:@"resourceType"];
        [parm setObject:self.toUserId forKey:@"resourceId"];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/shield",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [weakSelf hideHUD];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"intro.yibp"]];
                NoticePinBiView *pinTostView = [[NoticePinBiView alloc] initWithTostViewType:type];
                pinTostView.ChoiceType = ^(NSInteger types) {
                    if (types == 5) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                };
                [pinTostView showTostView];
            }
        } fail:^(NSError *error) {
            [weakSelf hideHUD];
        }];
        
    };
    [pinView showPinbView];
}

- (void)setAleryRead:(NoticeChats *)chat{
    
    chat.read_at = [NoticeTools getNowTimeTimestamp];
    [self.tableView reloadData];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:chat.read_at forKey:@"readAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",chat.chat_id,chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
    } fail:^(NSError *error) {
        
    }];
}

// 将JSON串转化为字典或者数组
-(id)toArrayOrNSDictionary:(NSString *)JSONString{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSArray class]]){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

//加载预设数据
- (void)requestYUse:(BOOL)neeShow{
    if (![[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
        return;
    }
    if (neeShow) {
        [self showHUD];
    }
    self.yuseArr = [NSMutableArray new];
    self.yuseStrArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.yuseImgArr removeAllObjects];
            [self.yuseArr removeAllObjects];
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]){
                NoticeYuSetModel *model = [NoticeYuSetModel mj_objectWithKeyValues:dic];
                model.isTrueStr = YES;
                if (model.resource_type.intValue == 1) {
                    [self.yuseArr addObject:model];
                }else{
                    [self.yuseImgArr addObject:model];
                }
                [self.yuseStrArr addObject:model];
                hasData = YES;
            }
            
            if (self.yuseStrArr.count) {
                NoticeYuSetModel *lastM = self.yuseStrArr[self.yuseStrArr.count-1];
                self.yuseLastId = lastM.reply_sort;
            }
            if (hasData) {
                [self getMore];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}
- (void)getMore{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/defaultReply?lastSort=%@",[[NoticeSaveModel getUserInfo] user_id],self.yuseLastId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]){
                NoticeYuSetModel *model = [NoticeYuSetModel mj_objectWithKeyValues:dic];
                model.isTrueStr = YES;
                [self.yuseStrArr addObject:model];
                if (model.resource_type.intValue == 1) {
                    [self.yuseArr addObject:model];
                }else{
                    [self.yuseImgArr addObject:model];
                }
                hasData = YES;
            }
            
            if (self.yuseStrArr.count) {
                NoticeYuSetModel *lastM = self.yuseStrArr[self.yuseStrArr.count-1];
                self.yuseLastId = lastM.reply_sort;
            }
            if (hasData) {
                [self getMore];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}
- (NSMutableArray *)cacheArr{
    if (!_cacheArr) {
        _cacheArr = [NSMutableArray new];
    }
    return _cacheArr;
}



@end
