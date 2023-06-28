//
//  NoticeShopChatController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/13.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopChatController.h"
#import "NoticeSendChatView.h"
#import "NoticeSCCell.h"
#import "NoticeChocieImgListView.h"
#import "NoticeScroEmtionView.h"
#import "NoticeAction.h"
#import "NoticeShopjuBuView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NoticeShopJubaoView.h"
#import "NoticeMyShopModel.h"
@interface NoticeShopChatController ()<NoticeChatShopDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NoticeRecordDelegate,NoticeReceveMessageSendMessageDelegate,NoticeSCDeledate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NoticeSendChatView *sendView;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic, assign) BOOL imgOpen;//图片框架打开
@property (nonatomic, strong) NoticeChocieImgListView *imgListView;
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isClickChongBo;
@property (nonatomic, strong) NoticeChats *oldModel;
@property (nonatomic, strong) NSString *toChatUserId;
@property (nonatomic, assign) BOOL noAuto;
@property (nonatomic, strong) NoticeChats *currentModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger currentAutoIndex;
@property (nonatomic, assign) NSInteger currentAutoSection;
@property (nonatomic, strong) NoticeChats *tapChat;
@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic, assign) BOOL firstZd;
@property (nonatomic, assign) NSInteger chatTime;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UIView *timeV;
@property (nonatomic, strong) UILabel *labelL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *footL;
@property (nonatomic, assign) NSInteger redTime;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;

@end

@implementation NoticeShopChatController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [self.audioPlayer pause:YES];
    [self.audioPlayer stopPlaying];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
 
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    appdel.noPop = NO;
    appdel.isInShopChat = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = YES;
    appdel.isInShopChat = YES;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.needBackGroundView = NO;
    self.navBarView.hidden = NO;
    self.pageNo = 1;
    self.oldSection = 10000;
    self.dataArr = [NSMutableArray new];
    self.nolmorLdataArr = [NSMutableArray new];
    self.localdataArr = [NSMutableArray new];
        
    [self requestRedTime];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]) {
        self.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.orderM.user_id];
        self.toChatUserId = self.orderM.user_id;
    }else{
        self.toChatUserId = self.orderM.shop_user_id;
        self.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.orderM.shop_user_id];
    }
    
    _sendDic = [NSMutableDictionary new];
    [_sendDic setObject:self.toUserId forKey:@"to"];
    [_sendDic setObject:@"singleChat" forKey:@"flag"];
    
    self.navBarView.backgroundColor = self.view.backgroundColor;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.titleL.text = [self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]? self.orderM.user_nick_name : self.orderM.shop_name;
    self.navBarView.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [self.navBarView addSubview:self.navBarView.backButton];
    
    if (self.jubaoM) {//如果来自于举报
        self.navBarView.titleL.text = self.jubaoM.resource_type.intValue == 2 ? @"被举报的店铺":@"被举报的买家";
        [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    }else{
        [self.navBarView.backButton setTitle:@"结束" forState:UIControlStateNormal];
        [self.navBarView.backButton setTitleColor:[UIColor colorWithHexString:@"#DB6E6E"] forState:UIControlStateNormal];
        self.navBarView.backButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        self.navBarView.backButton.backgroundColor = [UIColor whiteColor];
        
        if ([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]) {
            [self.navBarView.backButton setTitle:@"" forState:UIControlStateNormal];
        }
        
        self.navBarView.rightButton.frame = CGRectMake(DR_SCREEN_WIDTH-5-50, STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [self.navBarView.rightButton setTitle:[NoticeTools getLocalStrWith:@"chat.jubao"] forState:UIControlStateNormal];
        [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.navBarView.rightButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.navBarView.rightButton addTarget:self action:@selector(jubaoChat) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.navBarView.backButton addTarget:self action:@selector(overChat) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.jubaoM) {
        _sendView = [[NoticeSendChatView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-(116-34), DR_SCREEN_WIDTH, 116-34)];
        _sendView.delegate = self;
        [self.view addSubview:_sendView];
        [_sendView.imgBtn addTarget:self action:@selector(sendImagClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendView.emtionBtn addTarget:self action:@selector(sendEmtionClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendView.carmBtn addTarget:self action:@selector(caremClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendView.sendBtn addTarget:self action:@selector(recoderClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPFINISHEDHOUTAI" object:nil];//后台告知结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasJubaoedOrder) name:@"SHOPHASJUBAOED" object:nil];//举报结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishOrder) name:@"SHOPFINISHED" object:nil];//买家结束
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+60, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-(116-34)-NAVIGATION_BAR_HEIGHT-60);
    [self.tableView registerClass:[NoticeSCCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
    bottomV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:bottomV];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.shopChatDelegate = self;
    self.isFirst = YES;
    [self createRefesh];
    [self requestData];
    
    if (!self.jubaoM) {
        //接单时候的时间戳
        //self.orderM.get_time;
        //服务时长
        //self.orderM.price.integerValue * 60;
        //服务截止时间
        //self.orderM.get_time.integerValue + self.orderM.price.integerValue*60;
        //当前时间戳
        //[NoticeTools getNowTimeStamp];
        //剩余服务时间=服务截止时间-当前时间戳
        self.chatTime = (self.orderM.get_time.integerValue+self.orderM.duration.integerValue*60) - [NoticeTools getNowTimeStamp].integerValue;
        if (self.chatTime < 0) {//已过服务时间
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已结束，即将离开此页面" message:nil cancleBtn:@"好的，知道了"];
            alerView.resultIndex = ^(NSInteger index) {
                [weakSelf.navigationController popViewControllerAnimated:YES]; 
            };
            [alerView showXLAlertView];
            
            [self complete];

        }else{
            self.timeV = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+10,DR_SCREEN_WIDTH-40, 50)];
            self.timeV.layer.cornerRadius = 8;
            self.timeV.layer.masksToBounds = YES;
            self.timeV.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
            self.timeV.layer.borderWidth = 1;
            [self.view addSubview:self.timeV];
            
            self.labelL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,200, 50)];
            self.labelL.font = SIXTEENTEXTFONTSIZE;
            self.labelL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            self.labelL.text = self.orderM.goods_name?self.orderM.goods_name: self.orderM.label;
            [self.timeV addSubview:self.labelL];
            
            self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.timeV.frame.size.width-80-10, 0, 80, 50)];
            self.timeL.font = XGEightBoldFontSize;
            self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
            self.timeL.textAlignment = NSTextAlignmentRight;
            [self.timeV addSubview:self.timeL];
            
            self.footL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
            self.footL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
            self.footL.textAlignment = NSTextAlignmentCenter;
            self.footL.text = @"订单即将结束";
            self.footL.font = FOURTHTEENTEXTFONTSIZE;
            
            self.firstZd = YES;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTime) name:@"REFRESHCHATLISTNOTICION" object:nil];
    }
   
    if (self.jubaoM) {//举报处理按钮
        [self jubaoButton];
    }
}

- (void)jubaoButton{
    NSArray *arr1 = @[@"忽略",@"停一天",@"停三天",@"关店"];
    NSArray *arr2 = @[@"忽略",@"禁1天",@"永久禁用",@""];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-100)/4+20)*i, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-40, (DR_SCREEN_WIDTH-100)/4, 40)];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn setTitle:self.jubaoM.resource_type.intValue==1?arr2[i]:arr1[i] forState:UIControlStateNormal];
        btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        btn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(chuliClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i==0) {
            self.button1 = btn;
        }else if (i==1){
            self.button2 = btn;
        }else if (i==2){
            self.button3 = btn;
        }else{
            self.button4 = btn;
        }
    }
    if (self.jubaoM.resource_type.intValue == 1) {
        self.button4.hidden = YES;
    }
    [self refreshM];
}

- (void)chuliClick:(UIButton *)btn{
    if (self.jubaoM.report_status.intValue > 1) {//已处理
        return;
    }
    
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定这样该项处理吗？" message:nil sureBtn:@"再想想" cancleBtn:@"确定" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            NSString *str = @"";
            if (btn.tag == 0) {
                str = @"7";
            }else if (btn.tag == 1){
                str = weakSelf.jubaoM.resource_type.intValue==1?@"5":@"2";
            }else if (btn.tag == 2){
                str = weakSelf.jubaoM.resource_type.intValue==1?@"6":@"3";
            }else{
                str = @"4";
            }
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:weakSelf.jubaoM.jubaiId forKey:@"id"];
            [parm setObject:str forKey:@"reportStatus"];
            [parm setObject:weakSelf.mangagerCode forKey:@"confirmPasswd"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/shopReportOrder" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    weakSelf.jubaoM.report_status = str;
                    [weakSelf refreshM];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)refreshM{
    if (self.jubaoM.report_status.intValue > 1) {
        self.button1.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button1 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.button2.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button2 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.button3.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button3 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.button4.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button4 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        
        if (self.jubaoM.report_status.intValue==7) {
            self.button1.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.jubaoM.report_status.intValue==2 || self.jubaoM.report_status.intValue==5){
            self.button2.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button2 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.jubaoM.report_status.intValue==3 || self.jubaoM.report_status.intValue==6){
            self.button3.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button3 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.jubaoM.report_status.intValue==4){
            self.button4.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button4 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
    }
}

- (void)refreshTime{

    self.chatTime = (self.orderM.get_time.integerValue+self.orderM.duration.integerValue*60) - [NoticeTools getNowTimeStamp].integerValue;
    if (self.chatTime < 0) {//已过服务时间
        [self.timer invalidate];
        self.timer = nil;
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已结束，即将离开此页面" message:nil cancleBtn:@"好的，知道了"];
        alerView.resultIndex = ^(NSInteger index) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [alerView showXLAlertView];

        [self complete];

        
    }else{
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
}

- (void)timeChange{
    
    if (self.chatTime > 0) {
        self.chatTime -- ;
    }else{
        [self.timer invalidate];
        self.timer = nil;
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已结束，即将离开此页面" message:nil cancleBtn:@"好的，知道了"];
        alerView.resultIndex = ^(NSInteger index) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
        [alerView showXLAlertView];
        
        [self complete];
        
    }
    
    if (self.chatTime > 0 && self.chatTime <= self.redTime) {
        self.labelL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.timeV.layer.borderColor = [UIColor colorWithHexString:@"#DB6E6E"].CGColor;
        self.timeL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.tableView.tableFooterView = self.footL;
        if (self.firstZd) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.firstZd = NO;
        }

    }
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.chatTime%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.chatTime%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    self.timeL.text = format_time;
}

- (void)createRefesh{
    
    __weak NoticeShopChatController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.pageNo++;
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}


- (void)requestData{
    if (!self.nolmorLdataArr.count) {
        self.pageNo = 1;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"chats/%@?pageNo=%ld",self.jubaoM?self.jubaoM.resource_id: self.orderM.orderId,self.pageNo] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
        
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
                if (model.globText && model.globText.length) {
                    model.contentText = model.globText;
                }
                if (model.content_type.intValue > 9) {
                    model.content_type = @"10";
                    model.contentText = @"请更新到最新版本";
                }
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
         
                    [self.nolmorLdataArr addObject:model];
                    [newArr addObject:model];
                    
                }
                
                if (self.jubaoM) {//举报消息列表
                    if ([model.from_user_id isEqualToString:self.jubaoM.from_user_id]) {//如果消息的来源是举报人来源，则消息在右边
                        model.isSelf = YES;
                        model.is_self = @"1";
                    }else{
                        model.isSelf = NO;
                    }
                }
            }
            if (self.nolmorLdataArr.count) {
                //2.倒序的数组
                NSArray *reversedArray = [[self.nolmorLdataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:reversedArray];
                NoticeChats *lastM = self.dataArr[0];
                self.chatId = lastM.chat_id;
                
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

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)scroToBottom{

    
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.sendView.contentView resignFirstResponder];
    [self backView];
}

- (void)finishOrder{
    if ([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]) {//店主
        [self.navigationController popViewControllerAnimated:NO];
        [self.sendView.contentView resignFirstResponder];
        
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"订单已结束，收入%.2f鲸币",self.orderM.price.intValue*(self.orderM.ratio?(1-self.orderM.ratio.floatValue):0.8)] message:@"实收款为扣除服务费后的费用，需扣除20%的服务费(声昔20%)" cancleBtn:@"我知道了"];
        [alerView showXLAlertView];
    }
}

- (void)overFinish{
    [self.navigationController popViewControllerAnimated:YES];
    [self.sendView.contentView resignFirstResponder];
   
    if ([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"订单已结束，收入%.2f鲸币",self.orderM.price.intValue*(self.orderM.ratio?(1-self.orderM.ratio.floatValue):0.8)] message:@"实收款为扣除服务费后的费用，需扣除20%的服务费(声昔20%)" cancleBtn:@"我知道了"];
        [alerView showXLAlertView];
    }
}

- (void)hasJubaoedOrder{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"有举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
    [alerView showXLAlertView];
    [self.navigationController popViewControllerAnimated:YES];
    [self.sendView.contentView resignFirstResponder];
}

- (void)backView{
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_heiemo") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+60, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60));
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_heiimg") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+60, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60));
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }
}

//发图片
- (void)sendImagClick{
    [self.sendView.contentView resignFirstResponder];
    if (self.emotionOpen) {
        self.emotionOpen = NO;
       _emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, _emotionView.frame.size.height);
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_heiemo") forState:UIControlStateNormal];
    }
    
    if (self.imgOpen) {
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_heiimg") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,(NAVIGATION_BAR_HEIGHT+60), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60));
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }else{
        [self.imgListView refreshImage];
        [UIView animateWithDuration:0.5 animations:^{
            self.sendView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.sendView.frame.size.height-self.imgListView.frame.size.height, DR_SCREEN_WIDTH,self.sendView.frame.size.height);
            self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60)-self.imgListView.frame.size.height);
            self.imgListView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.imgListView.frame.size.height, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        }];
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_openimgpri") forState:UIControlStateNormal];
        [self scroToBottom];
    }
    self.imgOpen = !self.imgOpen;
}

//发送表情包
- (void)sendEmtionClick{
    [self.sendView.contentView resignFirstResponder];
    if (self.imgOpen) {
        self.imgOpen = NO;
        _imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, _imgListView.frame.size.height);
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_heiimg") forState:UIControlStateNormal];
    }

    if (self.emotionOpen) {
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_heiemo") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+60, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60));
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.sendView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.sendView.frame.size.height-self.emotionView.frame.size.height, DR_SCREEN_WIDTH,self.sendView.frame.size.height);
            self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60)-self.emotionView.frame.size.height);
            self.emotionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.emotionView.frame.size.height, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        }];
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
   
        [self scroToBottom];
    }
    self.emotionOpen = !self.emotionOpen;
}


//拍照
- (void)caremClick{
    [self backView];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        [self showToastWithText:@"您没有开启相机权限哦~，您可以在手机系统设置开启"];
    } else{
        //判断是否支持相机
          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
              [self presentViewController:self.imagePickerController animated:YES completion:nil];
          }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {

        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            __weak typeof(self) weakSelf = self;
            [[TZImageManager manager] savePhotoWithImage:photo location:nil completion:^(PHAsset *asset, NSError *error){
                if (!error) {
                    [weakSelf.photoArr addObject:asset];
                    [weakSelf sendImagePhoto];
                }
            }];
        }
    }
}

//录音
- (void)recoderClick{
    [self.sendView.contentView resignFirstResponder];
    [self backView];
    
    [self onStartRecording];
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.isSayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.noPushLeade = YES;
    recodeView.isReply = YES;
    recodeView.delegate = self;
    recodeView.startRecdingNeed = YES;
    [recodeView show];
}

//开始录音
- (void)onStartRecording{
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

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    [self sendTime:timeLength.integerValue path:locaPath];
}

//发送音频
- (void)sendTime:(NSInteger)time path:(NSString *)path{

    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];

        return;
    }
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
            

            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            sendChat.dialog_content_uri = Message;
            [messageDic setObject:self.orderM.orderId forKey:@"orderId"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",(long)time] forKey:@"dialogContentLen"];
            [self->_sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:self->_sendDic];
            
            sendChat.sendDic = messageDic;
            [self.localdataArr addObject:sendChat];
            [self.tableView reloadData];
 
            [self hideHUD];
        } else{
            [self hideHUD];
 
            [self showToastWithText:Message];
        }
    }];
}

//发送文字
- (void)sendContent:(NSString *)content{
    if (!content.length) {
        return;
    }
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:self.orderM.orderId forKey:@"orderId"];
    [messageDic setObject:@"2" forKey:@"dialogContentType"];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"https//" forKey:@"dialogContentUri"];
    [messageDic setObject:content forKey:@"dialogContentText"];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",content.length] forKey:@"dialogContentLen"];

    [self.sendDic setObject:messageDic forKey:@"data"];
     AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self->_sendDic];
}


//键盘弹出
- (void)refreshTableViewWithFrame:(CGRect)frame keyBordyHight:(CGFloat)keybordHeight{
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_heiemo") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
    }
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_heiimg") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
    }
    
    self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60)-keybordHeight);
}

- (void)refreshTableViewWithHideFrame:(CGRect)frame{
    self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-(NAVIGATION_BAR_HEIGHT+60));
}

- (NoticeScroEmtionView *)emotionView{
    if (!_emotionView) {
         _emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+BOTTOM_HEIGHT+15)];
        __weak typeof(self) weakSelf = self;
        _emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:weakSelf.orderM.orderId forKey:@"orderId"];
            [messageDic setObject:@"3" forKey:@"dialogContentType"];
            [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
            [messageDic setObject:url forKey:@"dialogContentUri"];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject: @"10" forKey:@"dialogContentLen"];
            [weakSelf.sendDic setObject:messageDic forKey:@"data"];
             AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:weakSelf.sendDic];
        };

        [self.view addSubview:_emotionView];
    }
    return _emotionView;
}

- (NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [NSMutableArray new];
    }
    return _photoArr;
}


- (NoticeChocieImgListView *)imgListView{
    if (!_imgListView) {
        __weak typeof(self) weakSelf = self;
        _imgListView = [[NoticeChocieImgListView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+BOTTOM_HEIGHT+15)];
        _imgListView.didSelectPhotosMBlock = ^(NSMutableArray * _Nonnull photoArr) {
            [weakSelf sendImagClick];
            weakSelf.photoArr = [NSMutableArray arrayWithArray:photoArr];
            [weakSelf sendImagePhoto];
        };
        [self.view addSubview:_imgListView];
    }
    return _imgListView;
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
            if (!self.photoArr.count) {
                [self showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
            NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
            [self upLoadHeader:UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.6) path:pathMd5];
            ;
        }];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path{
    if (!path) {
        path = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    NSInteger length = [image length]/1024;
    [[XGUploadDateManager sharedManager] uploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
 
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.orderM.orderId forKey:@"orderId"];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject:@"3" forKey:@"dialogContentType"];
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


- (UIImagePickerController *)imagePickerController{
    if (_imagePickerController==nil) {
        _imagePickerController=[[UIImagePickerController alloc]init];
        _imagePickerController.delegate=self;
        _imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];

        _imagePickerController.mediaTypes= mediaTypes;
        
    }
    return _imagePickerController;
}


- (void)overChat{
    if (self.jubaoM) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]) {
        return;
    }
    [self.sendView.contentView resignFirstResponder];
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"鲸币不会退回，确定结束订单吗？" message:nil sureBtn:@"再想想" cancleBtn:@"结束" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf complete];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

//订单完成接口
- (void)complete{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/complete/%@/0",self.orderM.orderId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)jubaoChat{
    
    __weak typeof(self) weakSelf = self;
    if ([self.orderM.user_id isEqualToString:[NoticeTools getuserId]]) {//用户举报店铺
        NoticeShopJubaoView *jubaoView = [[NoticeShopJubaoView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [jubaoView showJuBao];
        jubaoView.shopjubaoBlock = ^(NSInteger tag) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:[NoticeTools getuserId] forKey:@"userId"];
            [parm setObject:weakSelf.toChatUserId forKey:@"toUserId"];
            [parm setObject:weakSelf.orderM.orderId forKey:@"orderId"];
            [parm setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"typeId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/report" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                
            } fail:^(NSError * _Nullable error) {
                
            }];
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"已举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
            [alerView showXLAlertView];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }else{//店铺举报用户
        NoticeShopjuBuView *jubaoView = [[NoticeShopjuBuView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [jubaoView showJuBao];
        jubaoView.shopjubaoBlock = ^(NSInteger tag) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:[NoticeTools getuserId] forKey:@"userId"];
            [parm setObject:weakSelf.toChatUserId forKey:@"toUserId"];
            [parm setObject:weakSelf.orderM.orderId forKey:@"orderId"];
            [parm setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"typeId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/report" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            } fail:^(NSError * _Nullable error) {
            }];
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"已举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
            [alerView showXLAlertView];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
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
        
    if (chat.contentText && chat.contentText.length) {//显示文案
        
        if (chat.content_type.intValue == 9 && chat.toUserInfo) {//声昔卫士提醒送发电值
            return 28+chat.textHeight+58+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
        }
        
        return 28+chat.textHeight+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    
    if (chat.content_type.intValue == 5) {//显示分享链接
        return 28+53+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.content_type.intValue == 6){//显示分享的心情
        if (chat.shareVoiceM.show_status.intValue > 1 ) {
            return 28+98+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
        }
        
        if (chat.shareVoiceM.voiceM.img_list.count) {
            if (chat.shareVoiceM.voiceM.img_list.count == 3) {
                return 28+166+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
            }else if (chat.shareVoiceM.voiceM.img_list.count == 2){
                return 28+186+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
            }else{
                return 28+226+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
            }
        }else{
            return 28+98+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
        }
    }
    if (chat.content_type.intValue == 4) {//显示白噪声卡
        return 28+260+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.content_type.intValue == 7) {//显示配音
        return 28+120+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.content_type.intValue == 8) {//显示台词
        return 28+117+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.isShowTime) {
      
        if (chat.content_type.intValue == 1) {
            return 35+28+16+(chat.needMarkAuto ? 30 : 0) + (chat.offline_prompt ? 55 : 0) + ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"] ? ((chat.dialog_content.length? (chat.contentHeight+15) : 0)) : 0);
            
        }
        return 28+(chat.imgCellHeight?chat.imgCellHeight: 138)+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    

    if (chat.content_type.intValue == 1) {
        return 35+28+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0) + ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"] ? ((chat.dialog_content.length? (chat.contentHeight+15) : 0)) : 0);//最后一个表示是客服的同时，存在语音转文字
    }
    return 28+ (chat.imgCellHeight?chat.imgCellHeight: 138) +(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentPath = indexPath;
    __weak typeof(self) weakSelf = self;
    cell.refreshHeightBlock = ^(NSIndexPath * _Nonnull indxPath) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        [weakSelf scroToBottom];
    };
    cell.mangagerCode = self.mangagerCode;
    cell.noLongTap = YES;
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
    cell.isServeChat = YES;
    cell.delegate = self;
    cell.chat = chat;
    
    cell.playerView.timeLen = chat.resource_len;
    cell.index = indexPath.row;
    cell.section = indexPath.section;
    cell.playerView.slieView.progress = 0;
    [cell.playerView.playButton setImage:UIImageNamed(!chat.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    
    return cell;
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
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:model.isSaveCace?YES: NO];
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

- (void)didReceiveMessage:(id)message{
  
    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [ NoticeChats mj_objectWithKeyValues:message[@"data"]];
    if (chat.globText && chat.globText.length) {
        chat.contentText = chat.globText;
    }
    if (chat.dialog_content_type.intValue > 9) {
        chat.dialog_content_type = @"10";
        chat.contentText = @"请更新到最新版本";
    }
    
    if ([chat.flag isEqualToString:@"1"]) {
        return;
    }

    if ([ifDelegate.action isEqualToString:@"delete"]) {

        self.noAuto = YES;//收到对方删除的时候，停止自动播放语音
        [self.audioPlayer stopPlaying];
        for (NoticeChats *chatAll in self.dataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialogId] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.dataArr removeObject:chatAll];
                break;
            }
        }
        
        for (NoticeChats *norChat in self.localdataArr) {
            if ([norChat.dialog_id isEqualToString:chat.dialog_id] || [norChat.dialog_id isEqualToString:chat.dialogId]) {
                [self.localdataArr removeObject:norChat];
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
    
    chat.read_at = @"0";
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//当发送人不是自己的时候，需要判断是否是当前会话人发来的消息，不然容易消息错误
        if (![chat.from_user_id isEqualToString:self.toChatUserId]) {//别人发来的消息，判断是否是当前对话人
   
            return;
        }
    }else{//发送人是自己的时候
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
        self.chatId = chat.chat_id;
        for (int i = 0; i < self.localdataArr.count; i++) {//替代本地音频
            NoticeChats *localChat = self.localdataArr[i];
            if (localChat.isLocal && [localChat.dialog_content_uri isEqualToString:chat.dialog_content_uri]) {
                [self.localdataArr removeObjectAtIndex:i];
                break;
            }
        }

        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
        
    }
    
    [self scroToBottom];
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


//长按删除
- (void)longTapCancelWithSection:(NSInteger)section tag:(NSInteger)tag{
    __weak typeof(self) weakSelf = self;
   
    NoticeChats *chat = nil;
    
    if (section == 0) {
        if (self.dataArr.count-1 >= tag) {
            chat = self.dataArr[tag];
        }
    }else{
        if (self.localdataArr.count-1 >= tag) {
            chat = self.localdataArr[tag];
        }
    }
    
    if (!chat) {
        return;
    }
    if (!chat.isSelf) {
        return;
    }
    self.tapChat = chat;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (self.tapChat.content_type.intValue != 1) {
            if (buttonIndex == 1) {
                buttonIndex = 2;
            }
        }
        if (buttonIndex == 2 && chat.is_self.integerValue) {//撤回
           
            NSMutableDictionary * dsendDic = [NSMutableDictionary new];
            [dsendDic setObject:weakSelf.toUserId forKey:@"to"];
            [dsendDic setObject:@"singleChat" forKey:@"flag"];
            [dsendDic setObject:@"delete" forKey:@"action"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"2" forKey:@"chatType"];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject:@"shopOrder" forKey:@"chatId"];
            [messageDic setObject:chat.dialog_id forKey:@"dialogId"];
            [dsendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:dsendDic];
            
            for (NoticeChats *norChat in weakSelf.nolmorLdataArr) {
                if ([norChat.dialog_id isEqualToString:chat.dialog_id]) {
                    [weakSelf.nolmorLdataArr removeObject:norChat];
                    break;
                }
            }
            if ([weakSelf.currentModel.dialog_id isEqualToString:chat.dialog_id]) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.noAuto = YES;
            if (section == 0) {
                if (tag <= weakSelf.dataArr.count-1) {
                    [weakSelf.dataArr removeObjectAtIndex:tag];
                }
            }else{
                if (tag <= weakSelf.localdataArr.count-1) {
                    [weakSelf.localdataArr removeObjectAtIndex:tag];
                }
            }
            [weakSelf.tableView reloadData];
        }

    } otherButtonTitleArray:@[@"撤回"]];
    [sheet show];
}

- (void)requestRedTime{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"adminConfig/1" Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            NoticeMyShopModel *model = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            self.redTime = model.order_over_time.intValue?model.order_over_time.intValue:10;
        }
    } fail:^(NSError * _Nullable error) {
     
    }];
}

@end
