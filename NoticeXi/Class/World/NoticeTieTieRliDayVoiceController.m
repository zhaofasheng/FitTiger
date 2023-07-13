//
//  NoticeTieTieRliDayVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2023/7/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTieTieRliDayVoiceController.h"
#import "LXCalender.h"
#import "NoticeCalendarView.h"
#import "NoticeWhtieSelfVoiceCellCell.h"
#import "LXCalendarDayModel.h"
#import "NoticeVoiceViewController.h"
#import "LXCalendarMonthModel.h"
#import "NoticeSendEmilController.h"
#import "NewReplyVoiceView.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
#import "NoticeCurentLeaveController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
@interface NoticeTieTieRliDayVoiceController ()<NoticeWhiteSelfVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate>
@property(nonatomic,strong) NoticeCalendarView *calenderView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *currentL;
@property (nonatomic, strong) NoticeTieTieCaleModel *yearModel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UILabel *choiceDayL;
@property (nonatomic, strong) FSCustomButton *downBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *dateName;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL hasNewChoice;
@property (nonatomic, assign) BOOL changeUp;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) UIView *backView;
@end

@implementation NoticeTieTieRliDayVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NoticeWhtieSelfVoiceCellCell class] forCellReuseIdentifier:@"cell1"];
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    self.isDown = YES;
    self.pageNo = 1;
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
    self.tableView.backgroundColor = self.view.backgroundColor;
    if(!self.ismonthVoice){
        [self setDayVoiece];
    }else{
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-70);
    }
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRiliVoice:) name:@"REFRESHUSERINFORNOTICATIONrili" object:nil];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setDayVoiece{
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15,0, DR_SCREEN_WIDTH-30, DR_SCREEN_WIDTH-50)];
    [self.view addSubview:backV];
    self.backView = backV;
    backV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];

    self.calenderView =[[NoticeCalendarView alloc]initWithFrame:CGRectMake(5,0, DR_SCREEN_WIDTH - 40, DR_SCREEN_WIDTH-50)];
    self.calenderView.isCanTap = YES;
    self.calenderView.isFirstIn = YES;
    self.calenderView.calendarWeekView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    __weak typeof(self) weakSelf = self;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60)];
    self.choiceDayL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 50)];
    self.choiceDayL.font = XGEightBoldFontSize;
    self.choiceDayL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.headerView addSubview:self.choiceDayL];
    
    CGFloat downWdith = GET_STRWIDTH([NoticeTools chinese:@"下载音频" english:@"Download" japan:@"ダウンロード"], 14, 50)+20;
    self.downBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-downWdith,10,downWdith, 50)];
    self.downBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.downBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    [self.downBtn setImage:UIImageNamed(@"blackintoimg") forState:UIControlStateNormal];
    self.downBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
    [self.downBtn setTitle:[NoticeTools chinese:@"下载音频" english:@"Download" japan:@"ダウンロード"] forState:UIControlStateNormal];
    [self.headerView addSubview:self.downBtn];
    [self.downBtn addTarget:self action:@selector(downDayClick) forControlEvents:UIControlEventTouchUpInside];
    self.downBtn.hidden = YES;
    
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc] initWithDate:[NSDate date]];
    [self requestWithYear:[NSString stringWithFormat:@"%ld",monthModel.year] month:[NSString stringWithFormat:@"%ld",monthModel.month]];
    
    
    self.calenderView.choiceBlock = ^(LXCalendarDayModel * _Nonnull choiceModel) {
        [weakSelf refreshData:choiceModel];
    };
   
    [self.calenderView dealDataWith:[NSDate date] month:nil];
    
    self.calenderView.backgroundColor =[[UIColor whiteColor] colorWithAlphaComponent:0];
    
    [backV addSubview:self.calenderView];
    
    self.tableView.frame = CGRectMake(0,CGRectGetMaxY(backV.frame), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-self.backView.frame.size.height);
    self.tableView.tableHeaderView = self.headerView;
    [self.view bringSubviewToFront:self.tableView];
    
}

- (void)refreshData{
    [self.tableView.mj_header beginRefreshing];
}

- (void)deleteRiliVoice:(NSNotification*)notification{
    if (self.dataArr.count) {
        for (NoticeVoiceListModel *voiceM in self.dataArr) {
            NSDictionary *nameDictionary = [notification userInfo];
            NSString *voiceId = nameDictionary[@"voiceId"];
            if ([voiceM.voice_id isEqualToString:voiceId]) {
                [self.dataArr removeObject:voiceM];
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(!self.ismonthVoice){
        CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
        if(vel.y < 0){
            if(!self.changeUp && !self.isUp){
                self.changeUp = YES;
                [UIView animateWithDuration:0.6 animations:^{
                    self.tableView.frame = CGRectMake(0,self.calenderView.lx_width/7+40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-40-self.calenderView.lx_width/7);
                    if(self.calenderView.choiceDay.hNum > 0){
                        self.calenderView.collectionView.frame = CGRectMake(0, self.calenderView.calendarWeekView.lx_bottom-(self.calenderView.choiceDay.hNum*(self.calenderView.lx_width/7)), self.calenderView.lx_width, 6 * (self.calenderView.lx_width/7));
                    }
                    self.calenderView.calendarWeekView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
                    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                } completion:^(BOOL finished) {
                    self.isUp = YES;
                    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
                }];
            }
            
        }else{
            [self openTap];
        }
    }
}

- (void)openTap{
    if(self.changeUp && self.isUp){
        self.changeUp = NO;
        [UIView animateWithDuration:0.6 animations:^{
            self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.backView.frame), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-self.backView.frame.size.height);
            self.calenderView.collectionView.frame = CGRectMake(0, self.calenderView.calendarWeekView.lx_bottom, self.calenderView.lx_width, 6 * (self.calenderView.lx_width/7));
            self.calenderView.calendarWeekView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
            self.tableView.backgroundColor = self.view.backgroundColor;
        } completion:^(BOOL finished) {
            self.isUp = NO;
        }];
    }
}

- (void)requestWithYear:(NSString *)year month:(NSString *)month{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/voices/calendar?year=%@&month=%d",year,month.intValue] Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.yearModel = [NoticeTieTieCaleModel mj_objectWithKeyValues:dict[@"data"]];
            if (!self.calenderView.currentMonthMondel) {
                return;
            }
            if (!self.yearModel) {
                return;
            }
            
            if (self.yearModel.year.intValue == self.calenderView.currentMonthMondel.year) {
                for (NoticeTieTieCaleModel *monthModel in self.yearModel.monthModels) {
                    if (monthModel.month.intValue == self.calenderView.currentMonthMondel.month) {
                        self.calenderView.netDataArr = monthModel.dayModels;
                        break;
                    }
                }
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)refreshCal:(id)month date:(NSDate *)date{
    self.dateName = nil;
    self.downBtn.hidden = YES;
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
    self.choiceDayL.text = @"";
    self.calenderView.isFirstIn = YES;
    [self.calenderView dealDataWith:date month:month];
}

- (void)refreshData:(LXCalendarDayModel *)choiceDay{
    self.dateName = [NSString stringWithFormat:@"%ld%02ld%02ld",self.calenderView.choiceDay.year,self.calenderView.choiceDay.month,self.calenderView.choiceDay.day];
    self.pageNo = 1;
    self.isDown = YES;
    self.choiceDayL.text = [NSString stringWithFormat:@"%02ld月%02ld日",self.calenderView.choiceDay.month,self.calenderView.choiceDay.day];
    [self request];
}

- (void)downDayClick{
    NoticeSendEmilController *ctl = [[NoticeSendEmilController alloc] init];
    ctl.year = [NSString stringWithFormat:@"%ld",self.calenderView.choiceDay.year];;
    ctl.month = [NSString stringWithFormat:@"%02ld",self.calenderView.choiceDay.month];
    ctl.day = [NSString stringWithFormat:@"%02ld",self.calenderView.choiceDay.day];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)selfChatNumView{

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

    NoticeNewChatVoiceView *chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = self.hsVoiceM;
    chatView.userId = self.hsVoiceM.subUserModel.userId;
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
    inputView.saveKey =  [NSString stringWithFormat:@"qqchat%@%@",[NoticeTools getuserId],self.hsVoiceM.voice_id];
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
    //__weak typeof(self) weakSelf = self;
   // [_topController showHUD];
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
        }else{
           // [self->_topController hideHUD];
           // [self->_topController showToastWithText:errorMessage];
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
    
    [self showHUD];
    __weak typeof(self) weakSelf = self;
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
    
    __weak NoticeTieTieRliDayVoiceController *ctl = self;
    if (self.ismonthVoice) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ctl.isDown = YES;
            ctl.pageNo = 1;
            [ctl request];
            
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
        [ctl request];
    }];
}

- (void)request{
    if(!self.ismonthVoice){
        if(!self.dateName){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }

    NSString *url = nil;

    if (self.isDown) {
        [self reSetPlayerData];
        url = [NSString stringWithFormat:@"users/voices/calendar/%@?pageNo=1",self.dateName];
     
    }else{
        url = [NSString stringWithFormat:@"users/voices/calendar/%@?pageNo=%ld",self.dateName,self.pageNo];
    
    }
    if(self.ismonthVoice){
        url = [NSString stringWithFormat:@"users/voices/%@/%@/%@?pageNo=%ld",self.year,self.month,self.visibility,self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.ismonthVoice?@"application/vnd.shengxi.v5.5.3+json": @"application/vnd.shengxi.v5.4.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
                self.isPushMoreToPlayer = NO;
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
            
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
                self.downBtn.hidden = NO;
            }else{
                self.downBtn.hidden = YES;
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.is_private.boolValue && !model.statusM  && !model.topicName) {
        return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]]-54+10;
    }
    return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWhtieSelfVoiceCellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];

    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.noPushToUserCenter = YES;

        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        ctl.reEditBlock = ^(NoticeVoiceListModel * _Nonnull voiceM) {
            NoticeVoiceListModel * choicemodel =weakSelf.dataArr[indexPath.row];
            choicemodel = voiceM;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }else{
        NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.noPushToUserCenter = YES;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        ctl.reEditBlock = ^(NoticeVoiceListModel * _Nonnull voiceM) {
            NoticeVoiceListModel * choicemodel =weakSelf.dataArr[indexPath.row];
            choicemodel = voiceM;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }
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
        }
    }
}

//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{

    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图%ld",tag);
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
        NoticeWhtieSelfVoiceCellCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        
        if (weakSelf.canReoadData) {
            cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
            model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            model.nowPro = currentTime/model.voice_len.floatValue;
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

- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
}

@end
