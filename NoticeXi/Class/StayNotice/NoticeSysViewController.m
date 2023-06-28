//
//  NoticeSysViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSysViewController.h"
#import "NoticeSysCell.h"
#import "NoticeNoDataView.h"
#import "NoticeImageViewController.h"
#import "AFHTTPSessionManager.h"
#import "VBAddStatusInputView.h"
#import "NoticeSysMeassageTostView.h"
#import "NoticeWhiteVoiceListModel.h"
#import "NoticeWebViewController.h"
#import "NoticeDanMuController.h"
#import "NoticeCarePeopleController.h"
#import "NoticePlayerVideoController.h"
@interface NoticeSysViewController ()<NewSendTextDelegate,NoticeRecordDelegate>
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeSysMeassageTostView *tostView;
@property (nonatomic, strong) NSString *topName;
@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic, strong) NSString *messageId;
@end

@implementation NoticeSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"push.ce9"];
    [self.tableView registerClass:[NoticeSysCell class] forCellReuseIdentifier:@"cell1"];

    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    

    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.footView =  [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMessage *message = self.dataArr[indexPath.row];
    self.messageId = message.msgId;
    ////1 图书，2播客,3话题，4活动，5声昔君说，6反馈，7版本更新
    if (message.category_id.intValue == 1) {
        if (!message.supply.intValue) {
            [self showToastWithText:@"去读书文章看吧~"];
            return;
        }
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.isFromListen = YES;
        NoticeWeb *web = [NoticeWeb new];
        web.html_id = message.supply;
        ctl.web = web;
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:self.navigationController.view];
        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [self.navigationController pushViewController:ctl animated:NO];
    }else if (message.category_id.intValue == 2){//播客
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",message.supply] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
                NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
                ctl.bokeModel = model;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else if (message.category_id.intValue == 3){//话题
       
        self.topName = message.supply;
        if (!self.topName) {
            return;
        }
        NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"sendv.m")];
        recodeView.hideCancel = YES;
        recodeView.isLongTime = YES;
        recodeView.delegate = self;
        //recodeView.needLongTap = YES;
        recodeView.isSend = YES;
        [recodeView show];
    }else if (message.category_id.intValue == 4){
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = message.supply;
        ctl.isFromShare = YES;
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:self.navigationController.view];
        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [self.navigationController pushViewController:ctl animated:NO];
    }else if (message.category_id.intValue == 5){
        self.tostView.message = message;
        [self.tostView showActiveView];
    }else if (message.category_id.intValue == 6){
        VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        inputView.num = 1000;
        inputView.delegate = self;
        inputView.isReply = NO;
        inputView.plaStr = [NoticeTools getLocalStrWith:@"xl.input"];
        inputView.titleL.text = [NoticeTools getLocalStrWith:@"xl.title"];
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:inputView];
        [inputView.contentView becomeFirstResponder];
    }else if (message.category_id.intValue == 7){
        NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
        [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            NSArray *results = responseObject[@"results"];
            if (results && results.count > 0) {
                NSDictionary *response = results.firstObject;
                NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
                if (trackViewUrl) {
                    NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }else if (message.category_id.intValue == 8){
        NoticePlayerVideoController *ctl = [[NoticePlayerVideoController alloc] init];
        ctl.videoUrl = message.supply;
        ctl.linkUrl = message.link_url;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else{
        self.tostView.message = message;
        [self.tostView showActiveView];
    }

}

//问题反馈的文字
- (void)sendTextDelegate:(NSString *)str{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.messageId forKey:@"sysmsgId"];
    [parm setObject:str forKey:@"describe"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/feedback",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"yl.yfk"]];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    self.locaPath = locaPath;
    self.timeLen = timeLength;
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.topName forKey:@"topicName"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
            [self updateVoice:topicId];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}


- (void)updateVoice:(NSString *)topicId{

    if (!self.locaPath) {
        [self hideHUD];
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
   
        return;
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"2" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];

    
    [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:self.locaPath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject: @"2" forKey:@"voiceType"];
            [parm setObject:@"1" forKey:@"contentType"];
            [parm setObject:self.timeLen forKey:@"contentLen"];
            [parm setObject:Message forKey:@"voiceContent"];
            [parm setObject:@"0" forKey:@"isPrivate"];

            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }else{
                [parm setObject:@"0" forKey:@"bucketId"];
            }
           
            [parm setObject:topicId forKey:@"topicId"];
      
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                   
                        return ;
                    }
                    NoticeWhiteVoiceListModel *whitem = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                    [self getWhiteCard:whitem.card_no];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    }];
}


- (void)getWhiteCard:(NSString *)cardId{
    if (!cardId) {
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"famousQuotesCards/%@",cardId] Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeWhiteVoiceListModel *carM = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            if (!carM.card_url) {
                return ;
            }
            NoticeTostWhtieVoiceView *tostView = [[NoticeTostWhtieVoiceView alloc] initWithShow:carM];
            [tostView showCardView];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMessage *model = self.dataArr[indexPath.row];
    return 44*2+20+45+model.contentHeight+15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.message = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
    
    __weak NoticeSysViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/1?lastId=%@",[[NoticeSaveModel getUserInfo]user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMessage *model = [NoticeMessage mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeMessage *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.msgId;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
    }];
}

- (NoticeSysMeassageTostView *)tostView{
    if (!_tostView) {
        _tostView = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _tostView;
}

@end
