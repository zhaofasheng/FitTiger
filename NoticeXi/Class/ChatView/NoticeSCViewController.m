//
//  NoticeSCViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSCViewController.h"
#import "NoticeSendView.h"
#import "NoticeSCCell.h"
#import "NoticeNoticenterModel.h"
#import "NoticeAction.h"
#import "NoticeDevoiceM.h"
#import "NoticeSendViewController.h"
#import "NoticrChatLike.h"
#import "NoticeXi-Swift.h"
#import "NoticeSetYuReplyController.h"
#import "NoticeWebViewController.h"
#import "NoticeYuSetModel.h"
#import "NoticeChatTitleView.h"
#import "NoticeAction.h"
#import "NoticeClipImage.h"
#import "NoticeStatus.h"
#import "NoticeCustumeButton.h"
#import "NoticeNoReandView.h"
#import "NoticeScroEmtionView.h"
#import "NoticeLelveImageView.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeChocieImgListView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NoticeWhiteVoiceController.h"
#import "NoticeHasCenterData.h"
@interface NoticeSCViewController ()<NoticeSendDelegate,TZImagePickerControllerDelegate,NoticeReceveMessageSendMessageDelegate,NoticeSCDeledate,LCActionSheetDelegate,NewSendTextDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) NoticeSendView *sendView;
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, assign) BOOL hasTips;
@property (nonatomic, assign) BOOL hasHobbys;
@property (nonatomic, strong) NoticeChats *tapChat;
@property (nonatomic, strong) NoticeChats *oldModel;
@property (nonatomic, assign) BOOL noAuto;
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
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) NSInteger sendTimeNum;
@property (nonatomic, assign) BOOL isClickChongBo;
@property (nonatomic, strong) UILabel *deveceinfoL;
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, strong) LCActionSheet *cellSheet;
@property (nonatomic, strong) LCActionSheet *failSheet;
@property (nonatomic, strong) LCActionSheet *yusSheet;
@property (nonatomic, strong) NSMutableArray *yuseArr;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) NSMutableArray *yuseStrArr;
@property (nonatomic, strong) NSMutableArray *cacheArr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *chatTiemId;
@property (nonatomic, strong) NoticeChatTitleView *ttitleV;
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NoticeCustumeButton *likeButton;
@property (nonatomic, strong) NoticeStatus *statusM;

@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, strong) NoticeNoReandView *readView;
@property (nonatomic, assign) NSInteger messageNum;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic, assign) BOOL imgOpen;//图片框架打开
@property (nonatomic, strong) NoticeChocieImgListView *imgListView;
@property (nonatomic, assign) BOOL httpOpen;//链接框架打开
@property (nonatomic, assign) CGFloat tableViewOrinY;
@property (nonatomic, strong) NoticeChats *reSendChat;
@property (nonatomic, assign) BOOL isLinkUrl;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIView *orderView;

@end

@implementation NoticeSCViewController

- (NoticeNoReandView *)readView{
    if (!_readView) {
        _readView = [[NoticeNoReandView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-30,_sendView.frame.origin.y-5-30, 30, 30)];
        _readView.hidden = YES;
        _readView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCanLoadTap)];
        [_readView addGestureRecognizer:tap];
        [self.view addSubview:_readView];
    }
    return _readView;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tableView reloadData];
    [NoticeTools setSHAKE:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [NoticeTools setSHAKE:YES];
    self.noAuto = YES;
    [self.audioPlayer pause:YES];
    [self.audioPlayer stopPlaying];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self backView];
    if (![[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
    }
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.canLoad = YES;
    [self request];
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        DRLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];
    
    self.firstIn = YES;
    self.oldSection = 10000;
    self.isFirst = YES;
    self.dataArr = [NSMutableArray new];
    self.nolmorLdataArr = [NSMutableArray new];
    self.localdataArr = [NSMutableArray new];
    
    self.tableViewOrinY = ([self.toUserId isEqualToString:@"1"] ? 72 : 0)+NAVIGATION_BAR_HEIGHT;
    
    self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-(116-34)-self.tableViewOrinY);
    [self.tableView registerClass:[NoticeSCCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self createRefesh];

    _sendDic = [NSMutableDictionary new];
    [_sendDic setObject:self.toUser ? self.toUser : @"noNet" forKey:@"to"];
    [_sendDic setObject:@"singleChat" forKey:@"flag"];
    
    _sendView = [[NoticeSendView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 116-34)];
    _sendView.needHelp = self.isNeedHelp;
    _sendView.delegate = self;
    [_sendView.imgBtn addTarget:self action:@selector(sendImagClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.emtionBtn addTarget:self action:@selector(sendEmtionClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.httpBtn addTarget:self action:@selector(httpClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.carmBtn addTarget:self action:@selector(caremClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.whiteBtn addTarget:self action:@selector(whiteClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.sendBtn addTarget:self action:@selector(sendLinkUrlClick) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    [self.view addSubview:_sendView];
    _sendView.isLead = self.isLead;
    
    _sendView.overGuidelock = ^(BOOL isGiveUp) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
    };
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.isLead) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-129)/2-60, self.sendView.frame.origin.y-129-50, 129, 122)];
        [self.view addSubview:imageV];
        imageV.image = UIImageNamed(@"Image_jlzhiyin3");
        imageV.userInteractionEnabled = YES;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"36" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            imageV.frame = CGRectMake((DR_SCREEN_WIDTH-129)/2-60, self.sendView.frame.origin.y-129, 129, 122);
        } completion:nil];
    
        appdel.noPop = YES;
    }else{
        appdel.noPop = NO;
    }
    
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sendView.frame), DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
    backImgV.image = UIImageNamed(@"mohudupng");
    [self.view addSubview:backImgV];
    
    if (self.chatDetailId) {
        [_sendView removeFromSuperview];
    }
    
    appdel.socketManager.chatDelegate = self;
    
    if ([self.toUserId isEqualToString:@"1"]) {//如果是客服，则不显示举报按钮
        self.navigationItem.title = @"声昔小二";
    }
    
    if (self.chatDetailId) {//如果自己是声昔小二  自己内测使用
        [self requestData];
    }else{
        if (self.toUserId) {
            [self.tableView.mj_header beginRefreshing];
        }
        if (![self.toUserId isEqualToString:@"1"] && !self.isLead) {//如果是客服，则不显示举报按钮
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-30,STATUS_BAR_HEIGHT, 30,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
            [moreBtn setImage: [UIImage imageNamed:@"img_scb_b"]  forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:moreBtn];
            
        }else{
            self.isKeFu = YES;
            UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 72)];
            iamgeView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
            iamgeView.layer.cornerRadius = 8;
            iamgeView.layer.masksToBounds = YES;
            [self.view addSubview:iamgeView];
            
            NSString *strtITLE = self.isNeedHelp ? @"密码忘记了吗？需要帮助请给开发者留言\n休息时间若不能及时回复还请耐心等待":[NoticeTools getLocalStrWith:@"sxxe.tit"];
            UILabel *labei = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-40, 72)];
            labei.font = TWOTEXTFONTSIZE;
            labei.textColor = [UIColor colorWithHexString:@"#B8BECC"];
            labei.numberOfLines = 0;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strtITLE];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strtITLE length])];
            labei.attributedText = attributedString;
            labei.textAlignment = NSTextAlignmentCenter;
            [iamgeView addSubview:labei];
        }
    }
    
    if (self.isLead) {
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closBtn];
    }else{
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(5, STATUS_BAR_HEIGHT, 42, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
        [self.view addSubview:backButton];
    }

    
    NoticeChatTitleView *titleView = [[NoticeChatTitleView alloc] initWithFrame:CGRectMake(105,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-210, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.ttitleV = titleView;
    titleView.mainL.text = self.navigationItem.title;
    if (self.lelve) {
        titleView.mainL.frame = CGRectMake((titleView.frame.size.width-GET_STRWIDTH(self.navigationItem.title, 18, 21)-2-16)/2, 0, GET_STRWIDTH(self.navigationItem.title, 18, 21), titleView.frame.size.height);
        self.lelveImageView.image = UIImageNamed([self.lelve stringByReplacingOccurrencesOfString:@"Image_leave" withString:@"Image_smalleave"]);
    }else{
        titleView.mainL.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);
    }
    
    titleView.mainL.font = XGEightBoldFontSize;
    [self.view addSubview:titleView];
    
    if (!self.isNeedHelp) {
        self.needBackGroundView = YES;
    }
    
    if([[NoticeTools getuserId] isEqualToString:@"1"]){
        UILabel *deveceinfoL = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30,100)];
        deveceinfoL.font = ELEVENTEXTFONTSIZE;
        deveceinfoL.numberOfLines = 0;
        deveceinfoL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        deveceinfoL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.deveceinfoL = deveceinfoL;
        self.tableView.tableHeaderView = deveceinfoL;
        [self requestDevoice];
    }

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
                self.deveceinfoL.text = [NSString stringWithFormat:@"对方类型:%@%@ %@/%@\n\n学号:%@ 来了%@天 共%@个好友 心情:%@条,共%@\n\n书:%@   影:%@  音:%@  画:%@  配音:%@  台词:%@\n\n最近三天共享心情:%@条",model.personality_no,sex,model.last_login_device,model.app_version,model.frequency_no,model.comeHereTime,model.friend_num,model.voice_num,model.voice_total_len,model.voice_book_num,model.voice_movie_num,model.voice_song_num,model.artwork_num,model.dubbing_num,model.line_num,model.voice_three_days_share];
            }else{
                self.deveceinfoL.text = [NSString stringWithFormat:@"对方类型: %@/%@\n\n学号:%@ 来了%@天 共%@个好友 心情:%@条,共%@\n\n书:%@   影:%@  音:%@  画:%@  配音:%@  台词:%@\n\n最近三天共享心情:%@条",model.last_login_device,model.app_version,model.frequency_no,model.comeHereTime,model.friend_num,model.voice_num,model.voice_total_len,model.voice_book_num,model.voice_movie_num,model.voice_song_num,model.artwork_num,model.dubbing_num,model.line_num,model.voice_three_days_share];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (NoticeScroEmtionView *)emotionView{
    if (!_emotionView) {
         _emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+BOTTOM_HEIGHT+15)];
        __weak typeof(self) weakSelf = self;
        _emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
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

        [self.view addSubview:_emotionView];
    }
    return _emotionView;
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


- (NoticeLelveImageView *)lelveImageView{
    if (!_lelveImageView) {
        _lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ttitleV.mainL.frame)+2, (self.ttitleV.frame.size.height-16)/2, 16, 16)];
        [self.ttitleV addSubview:_lelveImageView];
    }
    return _lelveImageView;
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

- (void)clickCanLoadTap{
    _readView.hidden = YES;
    self.messageNum = 0;
    self.canLoad = YES;
    [self scroToBottom];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self backView];
}

- (void)backView{
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_whiteem") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_newsendimgpri") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }
    if (self.httpOpen) {
        self.isLinkUrl = YES;
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_httpimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.httpOpen = NO;
        self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        [self.sendView.topicField resignFirstResponder];
    }
}

//发送表情包
- (void)sendEmtionClick{
    if (self.imgOpen) {
        self.imgOpen = NO;
        _imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, _imgListView.frame.size.height);
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_newsendimgpri") forState:UIControlStateNormal];
    }
    if (self.httpOpen) {
        self.isLinkUrl = YES;
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_httpimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.httpOpen = NO;
        self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        [self.sendView.topicField resignFirstResponder];
    }
    if (self.emotionOpen) {
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_whiteem") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.sendView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.sendView.frame.size.height-self.emotionView.frame.size.height, DR_SCREEN_WIDTH,self.sendView.frame.size.height);
            self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY-self.emotionView.frame.size.height);
            self.emotionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.emotionView.frame.size.height, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        }];
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
        self.canLoad = YES;
        [self scroToBottom];
    }
    self.emotionOpen = !self.emotionOpen;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.sendView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.sendView.frame.size.height-keyboardF.size.height, DR_SCREEN_WIDTH,self.sendView.frame.size.height);
    self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY-keyboardF.size.height);
    self.canLoad = YES;
    [self scroToBottom];
}

- (void)keyboardDiddisss{
    self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
    self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
    [self backView];
}


//发链接
- (void)httpClick{
    if (self.imgOpen) {
        self.imgOpen = NO;
        _imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, _imgListView.frame.size.height);
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_newsendimgpri") forState:UIControlStateNormal];
    }
    
    if (self.emotionOpen) {
        self.emotionOpen = NO;
       _emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, _emotionView.frame.size.height);
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_whiteem") forState:UIControlStateNormal];
    }
    self.isLinkUrl = YES;
    if (self.httpOpen) {
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_httpimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.sendView.topicField.text = @"";
        [self.sendView.topicField resignFirstResponder];
    }else{
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_linkurl") forState:UIControlStateNormal];
        
        self.sendView.recordButton.hidden = YES;
        self.sendView.textView.hidden = NO;
        [self.sendView.topicField becomeFirstResponder];
    }
    self.httpOpen = !self.httpOpen;
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

//送白噪声
- (void)whiteClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeWhiteVoiceController *ctl = [[NoticeWhiteVoiceController alloc] init];
    ctl.isSendChat = YES;
    __weak typeof(self) weakSelf = self;
    ctl.choiceArrBlock = ^(NSMutableArray<NoticeWhiteVoiceListModel *> * _Nonnull whiteArr) {
        NSString *cardId = @"";
        
        if (whiteArr.count == 1) {
            cardId = [NSString stringWithFormat:@"[%@]",[whiteArr[0] card_no]];
        }else if (whiteArr.count == 2){
            cardId = [NSString stringWithFormat:@"[%@,%@]",[whiteArr[0] card_no],[whiteArr[1] card_no]];
        }else if (whiteArr.count == 3){
            cardId = [NSString stringWithFormat:@"[%@,%@,%@]",[whiteArr[0] card_no],[whiteArr[1] card_no],[whiteArr[2] card_no]];
        }
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:@"0" forKey:@"voiceId"];
        [messageDic setObject:@"4" forKey:@"dialogContentType"];
        [messageDic setObject:cardId forKey:@"cardNos"];
        [weakSelf.sendDic setObject:messageDic forKey:@"data"];
         AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:weakSelf.sendDic];
    };
  
    [self.navigationController pushViewController:ctl animated:NO];
    [self backView];
    
    //convertToJsonData
}

//发图片
- (void)sendImagClick{
    if (self.emotionOpen) {
        self.emotionOpen = NO;
       _emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, _emotionView.frame.size.height);
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_whiteem") forState:UIControlStateNormal];
    }
    
    if (self.httpOpen) {
        self.isLinkUrl = YES;
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_httpimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.httpOpen = NO;
        self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        [self.sendView.topicField resignFirstResponder];
    }
    
    if (self.imgOpen) {
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_newsendimgpri") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0,self.tableViewOrinY, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY);
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, self.sendView.frame.size.height);
        }];
    }else{
        [self.imgListView refreshImage];
        [UIView animateWithDuration:0.5 animations:^{
            self.sendView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.sendView.frame.size.height-self.imgListView.frame.size.height, DR_SCREEN_WIDTH,self.sendView.frame.size.height);
            self.tableView.frame = CGRectMake(0,self.tableView.frame.origin.y, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.sendView.frame.size.height-self.tableViewOrinY-self.imgListView.frame.size.height);
            self.imgListView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.imgListView.frame.size.height, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        }];
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_openimgpri") forState:UIControlStateNormal];
        self.canLoad = YES;
        [self scroToBottom];
    }
    self.imgOpen = !self.imgOpen;
}

//发送失败点击重新发送
- (void)failReSend:(NSInteger)section row:(NSInteger)row chatM:(NoticeChats *)chat{
    [_sendDic setObject:chat.sendDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self->_sendDic];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waitMessage) userInfo:nil repeats:YES];
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
    cell.playerView.timeLen = chat.resource_len;
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.playerView.slieView.progress = 0;
    [cell.playerView.playButton setImage:UIImageNamed(!chat.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    
    return cell;
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

- (void)failReSendchatM:(NoticeChats *)chat{
    self.reSendChat = chat;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"msg.resend"],[NoticeTools getLocalStrWith:@"msg.back"]]];
    sheet.delegate = self;
    self.failSheet = sheet;
    [sheet show];

}

//删除缓存
- (void)deleteSave:(NoticeChats *)chat{
    for (NoticeChats *locaChat in self.localdataArr) {
        if ([locaChat.saveId isEqualToString:chat.saveId]) {
            NSMutableArray *saveArr = [NoticeTools getChatArrarychatId:self.toUserId];
            for (NoticeChatSaveModel *saveM in saveArr) {
                if ([saveM.saveId isEqualToString:chat.saveId]) {
                    [saveArr removeObject:saveM];
                    [NoticeTools saveChatArr:saveArr chatId:self.toUserId];
                    break;
                }
            }
            [self.localdataArr removeObject:locaChat];
            break;
        }
    }
    [self.tableView reloadData];
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
            
            if (self.reSendChat) {
                [self deleteSave:self.reSendChat];
                self.reSendChat = nil;
            }
        
            
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
            if (self.isLead) {
                [messageDic setObject:self.toUserId.intValue==1?@"1":@"2" forKey:@"task_type"];
            }
            [messageDic setObject:[NSString stringWithFormat:@"%ld",(long)time] forKey:@"dialogContentLen"];
            [self->_sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:self->_sendDic];
            
            sendChat.sendDic = messageDic;
            [self.localdataArr addObject:sendChat];
            [self.tableView reloadData];
            if (self.isLead) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"101"}];
            }
 
            [self hideHUD];
        } else{
            [self hideHUD];
            if (!self.reSendChat) {
                [self saveVoice:[NSString stringWithFormat:@"%ld",time] path:path];
            }
            
            [self showToastWithText:Message];
        }
    }];
}

//缓存音频
- (void)saveVoice:(NSString *)time path:(NSString *)path{
    
 
    
    NSString *pathName = [NSString stringWithFormat:@"%ld",(long)arc4random()%999999999];
    NSString *voicePath = [NSString stringWithFormat:@"%@.%@",pathName,[path pathExtension]];
    NSMutableArray *alreadyArr = [NoticeTools getChatArrarychatId:self.toUserId];
    if ([NoticeSaveVoiceTools copyItemAtPath:path toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voicePath]]) {
        NoticeChatSaveModel *saveM = [[NoticeChatSaveModel alloc] init];
        saveM.pathName = [NSString stringWithFormat:@"%@.%@",pathName,[path pathExtension]];
        saveM.voiceTimeLen = time;
        saveM.chatId = self.toUserId;
        saveM.saveId = [NSString stringWithFormat:@"%@2-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
        saveM.type = @"1";
        saveM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:saveM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        [alreadyArr addObject:saveM];
        [NoticeTools saveChatArr:alreadyArr chatId:self.toUserId];
        
        NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
        NoticeChats *locaChat = [[NoticeChats alloc] init];
        locaChat.from_user_id = selfUser.user_id;
        locaChat.content_type = saveM.type;
        locaChat.resource_url = saveM.voiceFilePath;
        locaChat.isSaveCace = YES;
        locaChat.avatar_url = selfUser.avatar_url;
        locaChat.resource_type = saveM.type;
        locaChat.resource_len = saveM.voiceTimeLen;
        locaChat.saveId = saveM.saveId;
        [self.localdataArr addObject:locaChat];
        [self.tableView reloadData];
        [self scroToBottom];
    }
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

- (void)sendLinkUrlClick{
    if (!self.sendView.topicField.text.length || !self.sendView.topicField.text) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"group.linkmark"]];
        return;
    }
    NSString *urlStr = self.sendView.topicField.text;
    if (![NoticeTools isWhetherNoUrl:urlStr]) {//存在中文字的话
        NSArray *arr = [NoticeTools getURLFromStr:urlStr];
        if (arr.count) {
             urlStr = arr[0];
            if (![NoticeTools isWhetherNoUrl:urlStr]) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"group.linkmark"]];
            }
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"group.linkmark"]];
            return;
        }
    }
    
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"5" forKey:@"dialogContentType"];
  
    [messageDic setObject:urlStr forKey:@"shareUrl"];
    [self.sendDic setObject:messageDic forKey:@"data"];
     AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
    self.sendView.topicField.text = @"";
    [self backView];
}

- (void)sendTextDelegate{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.saveKey = [NSString stringWithFormat:@"chatto%@%@",[NoticeTools getuserId],self.toUserId];
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.navigationItem.title];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if (!str || !str.length) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:str forKey:@"keyword"];
    [parm setObject:@"2" forKey:@"type"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"getKeyword" Accept:@"application/vnd.shengxi.v5.3.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            UIImage *image = [NoticeClipImage clipImageWithText:aboutM.keyword fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.navigationItem.title];
            if (image) {
                NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
                [self upLoadHeader:UIImageJPEGRepresentation(image, 0.6) path:pathMd5 text:aboutM.keyword];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

//反馈订单
- (void)setRecoModel:(NoticeChangeRecoderModel *)recoModel{
    _recoModel = recoModel;
    self.orderView = [[UIView alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-80-116, DR_SCREEN_WIDTH-40, 80)];
    self.orderView.backgroundColor = [UIColor whiteColor];
    self.orderView.layer.cornerRadius = 10;
    self.orderView.layer.masksToBounds = YES;
    [self.view addSubview:self.orderView];
    [self.view bringSubviewToFront:self.orderView];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(10,5,150, 70)];
    colorView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.orderView addSubview:colorView];
    colorView.layer.cornerRadius = 5;
    colorView.layer.masksToBounds = YES;
    
    UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(5,0,140, 35)];
    statusL.textColor = [UIColor colorWithHexString:@"#25262E"];
    statusL.font = [UIFont systemFontOfSize:14];
    [colorView addSubview:statusL];
    statusL.text = recoModel.title;

    UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(5, 35,140, 35)];
    moneyL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    moneyL.font = [UIFont systemFontOfSize:12];
    [colorView addSubview:moneyL];
    moneyL.text = self.recoModel.money;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.orderView.frame.size.width-10-48, 24, 48, 32)];
    cancelBtn.layer.cornerRadius = 16;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [self.orderView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(noFankClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.orderView.frame.size.width-10-48-8-70, 24, 70, 32)];
    fBtn.layer.cornerRadius = 16;
    fBtn.layer.masksToBounds = YES;
    fBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [fBtn setTitle:@"反馈账单" forState:UIControlStateNormal];
    [fBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [self.orderView addSubview:fBtn];
    [fBtn addTarget:self action:@selector(FankClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)FankClick{
    [self sendTextDelegate:[NSString stringWithFormat:@"[%@]%@\n订单编号：%@\n交易单号：%@",self.recoModel.title,self.recoModel.money,self.recoModel.order_sn,self.recoModel.transaction_no]];
    [self.orderView removeFromSuperview];
}

- (void)noFankClick{
    [self.orderView removeFromSuperview];
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    if (!path) {
        path = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    [self showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            if (self.reSendChat) {
                [self deleteSave:self.reSendChat];
                self.reSendChat = nil;
            }
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
            if (!self.reSendChat) {
                [self saveImg:image str:text path:path];
            }
            [self showToastWithText:errorMessage];
        }
    }];
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
            if (self.reSendChat) {
                [self deleteSave:self.reSendChat];
                self.reSendChat = nil;
            }
            
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
                if (self.photoArr.count) {
                    [self sendImagePhoto];
                }
            }
            [self hideHUD];
            
        }else{
            [self showToastWithText:errorMessage];
            if (!self.reSendChat) {
                [self saveImg:image str:nil path:path];
            }
        }
    }];
}

//缓存发送失败的图片
- (void)saveImg:(NSData *)imgData str:(NSString *)text path:(NSString *)path{
    NSMutableArray *alreadyArr = [NoticeTools getChatArrarychatId:self.toUserId];
    NSString *pathName = [NSString stringWithFormat:@"/%@",path];
    NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:pathName];
    BOOL result = [imgData writeToFile:Pathimg atomically:YES];
    if (!result) {
        [self showToastWithText:@"消息缓存失败"];
        return;
    }
    NoticeChatSaveModel *saveM = [[NoticeChatSaveModel alloc] init];
    saveM.imagePath = pathName;
    saveM.chatId = self.toUserId;
    saveM.text = text;
    saveM.saveId = [NoticeSaveVoiceTools getNowTmp];
    saveM.type = text.length? @"2":@"3";
    saveM.imgUpPath = Pathimg;
    [alreadyArr addObject:saveM];
    [NoticeTools saveChatArr:alreadyArr chatId:self.toUserId];
    
    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
    NoticeChats *locaChat = [[NoticeChats alloc] init];
    locaChat.from_user_id = selfUser.user_id;
    locaChat.content_type = saveM.type;
    locaChat.resource_url = saveM.imgUpPath;
    locaChat.isSaveCace = YES;
    locaChat.avatar_url = selfUser.avatar_url;
    locaChat.resource_type = saveM.type;
    locaChat.resource_len = @"456";
    locaChat.saveId = saveM.saveId;
    locaChat.text = text;
    locaChat.isText = text.length?@"1":@"0";
    [self.localdataArr addObject:locaChat];
    [self.tableView reloadData];
    [self scroToBottom];
}

- (void)requestData{
    NSString *url = nil;
    
    if (self.chatDetailId) {
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@",self.chatDetailId,self.managerCode];
        }else{
            url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@&lastId=%@",self.chatDetailId,self.managerCode,self.lastId];
        }
        [self requestWith:url];
        return;
    }
    
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
    
    [self requestWith:url];
}

- (void)requestWith:(NSString *)url{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.chatDetailId?nil: @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
        
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
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
            
            if (self.isFirst) {
                NSMutableArray *localArr = [NoticeTools getChatArrarychatId:self.toUserId];
                if ([localArr count]) {
                    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
                    for (NoticeChatSaveModel *chatM in localArr) {
                        NoticeChats *locaChat = [[NoticeChats alloc] init];
                        locaChat.from_user_id = selfUser.user_id;
                        locaChat.content_type = chatM.type;
                        locaChat.resource_url = chatM.type.intValue==1? chatM.voiceFilePath:chatM.imgUpPath;
                        locaChat.isSaveCace = YES;
                        locaChat.avatar_url = selfUser.avatar_url;
                        locaChat.resource_type = chatM.type;
                        locaChat.resource_len = chatM.voiceTimeLen;
                        locaChat.isText = chatM.type.intValue==2?@"1":@"0";
                        locaChat.saveId = chatM.saveId;
                        locaChat.text = chatM.text;
                        [self.localdataArr addObject:locaChat];
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
            if (!self.chatTiemId) {
                self.chatTiemId = self.chatId;
                [self getTimeLast];
            }
        }
    } fail:^(NSError *error) {
        if ([NoticeComTools pareseError:[NSError new]]) {
            if (self.isFirst) {
                self.isFirst = NO;
                NSMutableArray *localArr = [NoticeTools getChatArrarychatId:self.toUserId];
                if ([localArr count]) {
                    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
                    for (NoticeChatSaveModel *chatM in localArr) {
                        NoticeChats *locaChat = [[NoticeChats alloc] init];
                        locaChat.from_user_id = selfUser.user_id;
                        locaChat.content_type = chatM.type;
                        locaChat.resource_url = chatM.type.intValue==1? chatM.voiceFilePath:chatM.imgUpPath;
                        locaChat.isSaveCace = YES;
                        locaChat.avatar_url = selfUser.avatar_url;
                        locaChat.resource_type = chatM.type;
                        locaChat.resource_len = chatM.voiceTimeLen;
                        locaChat.isText = chatM.type.intValue==2?@"1":@"0";
                        locaChat.saveId = chatM.saveId;
                        locaChat.text = chatM.text;
                        [self.localdataArr addObject:locaChat];
                    }
                }
            }
        }


        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getTimeLast{
    if ([self.navigationItem.title isEqualToString:@"私聊完整对话"] || [self.navigationItem.title isEqualToString:@"悄悄话完整对话"] || self.toUserId.intValue == 1) {
        return;
    }
}

- (void)createRefesh{
    
    __weak NoticeSCViewController *ctl = self;
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

- (void)actionClick{
    if (self.isKeFu) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[[NoticeTools getLocalType]?@"clear":@"删除交流记录(对方记录也会删除)"]];
        sheet.delegate = self;
        [sheet show];
    }else{
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.hide"],[NoticeTools getLocalType]?@"clear":@"删除交流记录(对方记录也会删除)",[NoticeTools getLocalStrWith:@"chat.jubao"]]];
        sheet.delegate = self;
        [sheet show];
    }
}

- (void)jubao{
    NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithLeaderJuBaoView];
    [pinV showTostView];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.failSheet) {
        if (buttonIndex == 1) {
            if (self.reSendChat.content_type.intValue == 1) {
                [self sendTime:self.reSendChat.resource_len.intValue path:self.reSendChat.resource_url];
            }
            if (self.reSendChat) {
                if (self.reSendChat.content_type.intValue == 2) {
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.reSendChat.resource_url];
                    NSData *data = [fileHandle readDataToEndOfFile];
                    [fileHandle closeFile];
                    UIImage *image  = [[UIImage alloc] initWithData:data];
                    if (!image) {
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.noimg"]];
                        return;
                    }
                    //UIImage转换为NSData
                    NSData *imageData = UIImageJPEGRepresentation(image,0.8);//第二个参数为压缩倍数
                    [self upLoadHeader:imageData path:nil text:self.reSendChat.text];
                }else if (self.reSendChat.content_type.intValue == 3){
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.reSendChat.resource_url];
                    NSData *data = [fileHandle readDataToEndOfFile];
                    [fileHandle closeFile];
                    UIImage *image  = [[UIImage alloc] initWithData:data];
                    DRLog(@"图片%@",data);
                    if (!image) {
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.noimg"]];
                        return;
                    }
                    //UIImage转换为NSData
                    NSData *imageData = UIImageJPEGRepresentation(image,0.8);//第二个参数为压缩倍数
                    [self upLoadHeader:imageData path:nil];
                }
            }
        }else if (buttonIndex == 2){
            [self deleteSave:self.reSendChat];
            self.reSendChat = nil;
        }
        return;
    }
    if (buttonIndex == 3) {
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dialogs/%@/recognitionContent",self.tapChat.dialog_id] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticeChats *textM = [NoticeChats mj_objectWithKeyValues:dict[@"data"]];
                NoticeChangeTextView *changeView = [[NoticeChangeTextView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                changeView.voiceContent = (textM.recognition_content && textM.recognition_content.length)?textM.recognition_content:@"转文字失败";
                
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
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
    
    self.tapChat = chat;
    NSArray *arr = self.tapChat.content_type.intValue == 1 ?@[[NoticeTools getLocalStrWith:@"yl.sctodui"],chat.is_self.integerValue?[NoticeTools getLocalStrWith:@"group.back"]:[NoticeTools getLocalStrWith:@"chat.jubao"]]:@[chat.is_self.integerValue?[NoticeTools getLocalStrWith:@"group.back"]:[NoticeTools getLocalStrWith:@"chat.jubao"]];
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (self.tapChat.content_type.intValue != 1) {
            if (buttonIndex == 1) {
                buttonIndex = 2;
            }
        }
        if (buttonIndex == 2 && chat.is_self.integerValue) {//撤回
           
            NSMutableDictionary * dsendDic = [NSMutableDictionary new];
            [dsendDic setObject:weakSelf.toUser ? weakSelf.toUser : @"noNet" forKey:@"to"];
            [dsendDic setObject:@"singleChat" forKey:@"flag"];
            [dsendDic setObject:@"delete" forKey:@"action"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"2" forKey:@"chatType"];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            [messageDic setObject:chat.chat_id?chat.chat_id:@"7777777" forKey:@"chatId"];
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

    } otherButtonTitleArray:arr];
    self.cellSheet = sheet;
    sheet.delegate = self;
    [sheet show];
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
                [[NSNotificationCenter defaultCenter]postNotificationName:@"pingbiNotification" object:self userInfo:@{@"userId":self.toUserId}];
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
    if (self.chatDetailId) {
        return;
    }
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


- (void)closeClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
           
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
        }
    };
    [alerView showXLAlertView];
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
    
    if (chat.dialog_content_type.intValue > 9) {
        chat.dialog_content_type = @"10";
        chat.contentText = @"请更新到最新版本";
    }
    
    if ([chat.flag isEqualToString:@"1"]) {
        return;
    }
    if ([ifDelegate.flag isEqualToString:@"receiveCard"]) {//领取白噪声
        if ([chat.from_user_id isEqualToString:[NoticeTools getuserId]] || [chat.to_user_id isEqualToString:[NoticeTools getuserId]]) {
            for (NoticeChats *achat in self.localdataArr) {
                if ([achat.dialog_id isEqualToString:chat.dialog_id]) {
                    achat.whiteModel.receive_status = chat.receive_status;
                    [self.tableView reloadData];
                    break;
                }
            }
            for (NoticeChats *achat in self.dataArr) {
                if ([achat.dialog_id isEqualToString:chat.dialog_id]) {
                    achat.whiteModel.receive_status = chat.receive_status;
                    [self.tableView reloadData];
                    break;
                }
            }
        }

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

        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
        
        if (!self.canLoad) {
            self.messageNum++;
            self.readView.frame = CGRectMake(DR_SCREEN_WIDTH-15-30,_sendView.frame.origin.y-5-30, 30, 30);
            self.readView.hidden = NO;
            self.readView.numL.text = [NSString stringWithFormat:@"%ld",self.messageNum];
        }
    }
    
    if (!self.chatTiemId) {
        self.chatTiemId = self.chatId;
        [self getTimeLast];
    }
    
    [self scroToBottom];
}


- (NSMutableArray *)cacheArr{
    if (!_cacheArr) {
        _cacheArr = [NSMutableArray new];
    }
    return _cacheArr;
}

- (void)dealloc{
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGEYUSEREPLAY" object:nil];
}
@end
