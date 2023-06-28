//
//  NoticeUserInfoCenterController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/25.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserInfoCenterController.h"
#import "NoticeNewSelfVoiceCell.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeUserCenterHeaderView.h"
#import "NoticeSCViewController.h"
#import "NoticeChatToKfController.h"
#import "NoticeCoverModel.h"
#import "NoticeXi-Swift.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
#import "NoticeNoticenterModel.h"
#import "NoticeEditViewController.h"
#import "NoticeNewTestResultController.h"
#import "NoticePsyModel.h"
#import "NoticeChangeNickNameView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "NoticeUserCenterVoiceController.h"
#import "NoticeSeasonViewController.h"
#import "NoticeUserCenterDubbingAndTcController.h"

//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@interface NoticeUserInfoCenterController ()<TZImagePickerControllerDelegate,LCActionSheetDelegate,NoticeManagerUserDelegate,JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isChangeIcon;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) NoticeUserCenterHeaderView *navHeaderView;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, assign) NSInteger managerType;
@property (nonatomic, strong) UIView *footV;
@property (nonatomic, strong) UIView *buttonTapView;
@property (nonatomic, assign) NSInteger testType;//1自己没做，2对方没做
@property (nonatomic, assign) BOOL hasNoPower;//无权限
@property (nonatomic, assign) BOOL hasPingb;//存在屏蔽关系
@property (nonatomic, strong) NSMutableArray *testArr;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NoticeUserCenterVoiceController *voiceVC;
@property (nonatomic, strong) NoticeUserCenterDubbingAndTcController *pyVC;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) UIView *fgView;
@property (nonatomic, strong) UIView *pingbV;
@property (nonatomic, strong) UILabel *pingbL;
@property (nonatomic, strong) NoticeSeasonViewController *seasonVC;
@end

@implementation NoticeUserInfoCenterController


- (void)closeClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf.fgView removeFromSuperview];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
        }
    };
    [alerView showXLAlertView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.userId) {
        if ([self.userId isEqualToString:[NoticeTools getuserId]]) {
            self.isOther = NO;
        }else{
            self.isOther = YES;
        }
    }
    self.navHeaderView.userId = self.isOther?self.userId: [[NoticeSaveModel getUserInfo] user_id];
    self.needBackGroundView = YES;
    self.backGroundImageView.noNeedPaopao = YES;

    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+2, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-2);
    self.tableView.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
    self.titles = @[[NoticeTools getLocalStrWith:@"yl.xinqing"],[NoticeTools getLocalStrWith:@"minee.xqzj"],[NoticeTools getLocalStrWith:@"main.py"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrder) name:@"HASNEWORDERCHANTORDER" object:nil];
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,DR_SCREEN_WIDTH, 50)];
    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.categoryView.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleFont = SIXTEENTEXTFONTSIZE;
    self.categoryView.titleSelectedFont = XGSIXBoldFontSize;
    self.categoryView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    
    self.pingbV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
    
    UIImageView *pingImg = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, 20, 335, 70)];
    pingImg.image = UIImageNamed(@"Image_pingb");
    [self.pingbV addSubview:pingImg];
    
    self.pingbL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 335, 70)];
    self.pingbL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.pingbL.font = THRETEENTEXTFONTSIZE;
    self.pingbL.textAlignment = NSTextAlignmentCenter;
    self.pingbL.text = [NoticeTools chinese:@"你已屏蔽对方，无法查看其内容" english:@"You have blocked this user." japan:@"ユーザーをブロックしました。"];
    [pingImg addSubview:self.pingbL];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    [self.sectionView addSubview:_categoryView];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
    lineView.lineScrollOffsetX = 2;
    lineView.indicatorHeight = 2;
    lineView.indicatorColor = [UIColor colorWithHexString:@"#0099E6"];
    lineView.indicatorWidth = 50;
    self.categoryView.indicators = @[lineView];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.isOther) {
        self.navBarView.hidden = NO;
        self.needHideNavBar = YES;
        self.backGroundImageView.hidden = YES;
        self.hasNoPower = YES;//默认无权限
        
        self.navBarView.rightButton.frame = CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [self.navBarView.rightButton setImage:UIImageNamed(@"morebuttonimg") forState:UIControlStateNormal];
        [self.navBarView.rightButton addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];

        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+2, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-2);
        
        UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        tabView.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.2];
        [self.view addSubview:tabView];
        self.buttonTapView = tabView;
        tabView.hidden = YES;
        
        UIButton *jiaoliuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-40-20)/2-30, TAB_BAR_HEIGHT-BOTTOM_HEIGHT)];
        [jiaoliuBtn setTitle:[NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"chat.title"]] forState:UIControlStateNormal];
        [jiaoliuBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        jiaoliuBtn.titleLabel.font = XGEightBoldFontSize;
        [tabView addSubview:jiaoliuBtn];
        [jiaoliuBtn addTarget:self action:@selector(jiaoliuClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.careButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-138, (TAB_BAR_HEIGHT-BOTTOM_HEIGHT-36)/2, 138, 36)];
        
        self.careButton.layer.cornerRadius = 36/2;
        self.careButton.layer.masksToBounds = YES;
        self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.careButton setTitle:[NoticeTools getLocalStrWith:@"add.xs"] forState:UIControlStateNormal];
        self.careButton.titleLabel.font = XGEightBoldFontSize;
        [tabView addSubview:self.careButton];
        [self.careButton addTarget:self action:@selector(careClick) forControlEvents:UIControlEventTouchUpInside];

        [self requestUserInfo];
        
    }else{
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-62, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 62, 24)];
        [editBtn setBackgroundImage:UIImageNamed(@"Image_editinfo") forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 40, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [backBtn setImage:UIImageNamed(@"Image_backbutton") forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
  
    self.backGroundImageView = [[NoticeCustumBackImageView alloc] initWithFrame:CGRectMake(-20, -20, DR_SCREEN_WIDTH+40, DR_SCREEN_HEIGHT+40)];
    [self.view addSubview:self.backGroundImageView];
    [self.view sendSubviewToBack:self.backGroundImageView];
    
    
    // 图片视差效果：水平方向
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectX.maximumRelativeValue = @(-50);
    effectX.minimumRelativeValue = @(50);
    [self.backGroundImageView addMotionEffect:effectX];

    // 图片视差效果：垂直方向
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectY.maximumRelativeValue = @(-50);
    effectY.minimumRelativeValue = @(50);
    [self.backGroundImageView addMotionEffect:effectY];
    
    UIView *mbV = [[UIView alloc] initWithFrame:self.backGroundImageView.bounds];
    [self.backGroundImageView addSubview:mbV];
    self.mbsView = mbV;
    self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:0.3];
    
    if (!self.isOther) {
        if (appdel.backImg) {
            self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:appdel.alphaValue>0?(appdel.alphaValue>0.8?0.8:appdel.alphaValue) :0.3];
            if (appdel.backImg) {
                self.backGroundImageView.hidden = NO;
                self.backGroundImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:appdel.effect];
            }else{
                self.backGroundImageView.hidden = YES;
            }
        }else{
            self.backGroundImageView.hidden = YES;
        }
        self.navHeaderView.userM = [NoticeSaveModel getUserInfo];
    }else{
        [self.view bringSubviewToFront:self.navBarView];
    }
    
    if (self.isLead) {
        self.fgView.hidden = NO;
    }
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayMusic) name:@"STOPCUTUSMEMUSICPALY" object:nil];
    [self.navHeaderView rePlay];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.isOther) {
        self.pagerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-2);
    }else{
        self.pagerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }
    self.pagerView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];

    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
}


#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.navHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.navHeaderView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.hasPingb?90: 50;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.hasPingb?self.pingbV: self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    if(self.hasPingb){
        return 0;
    }
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.voiceVC;
    }else if (index == 1) {
        return self.seasonVC;
    }else{
        return self.pyVC;
    }
}

- (NoticeUserCenterDubbingAndTcController *)pyVC{
    if (!_pyVC) {
        _pyVC = [[NoticeUserCenterDubbingAndTcController alloc] init];
        _pyVC.isOther = self.isOther;
        _pyVC.userId = self.userId;
    }
    return _pyVC;
}

- (NoticeUserCenterVoiceController *)voiceVC{
    if (!_voiceVC) {
        _voiceVC = [[NoticeUserCenterVoiceController alloc] init];
        _voiceVC.userId = self.userId;
        _voiceVC.isOther = self.isOther;
        __weak typeof(self) weakSelf = self;
        _voiceVC.playVoice = ^(BOOL play) {
            if (weakSelf.navHeaderView.currentModel.status == 1) {
                [weakSelf.navHeaderView playTap];
            }
            [weakSelf.navHeaderView.audioPlayer stopPlaying];
        };
    }
    return _voiceVC;
}

- (NoticeSeasonViewController *)seasonVC{
    if (!_seasonVC) {
        _seasonVC = [[NoticeSeasonViewController alloc] init];
        _seasonVC.isOther = self.isOther;
        _seasonVC.isNoShowSimi = YES;
        _seasonVC.userId = self.userId;
        _seasonVC.isUserCenter = YES;
    }
    return _seasonVC;
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)editClick{
    NoticeEditViewController *ctl = [[NoticeEditViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestReai{
    if (self.isOther) {
        [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"relations/%@",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" parmaer:nil success:^(NSDictionary *dict1, BOOL success) {
            if (success) {
                if ([dict1[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                if ([dict1[@"data"][@"friend_status"] isEqual:[NSNull null]]) {
                    return ;
                }
                NSString *friend_status = [NSString stringWithFormat:@"%@",dict1[@"data"][@"friend_status"]];

                if ([friend_status isEqualToString:@"3"] || [friend_status isEqualToString:@"4"]) {
                    self.hasNoPower = YES;
                    self.hasPingb = YES;
                    self.navHeaderView.playBackView.hidden = YES;
                    [self.pagerView reloadData];
                    self.pingbL.text = [friend_status isEqualToString:@"3"]?[NoticeTools chinese:@"对方已屏蔽你，无法查看其内容" english:@"This user has blocked you." japan:@"ユーザーをブロックしました。"]:[NoticeTools chinese:@"你已屏蔽对方，无法查看其内容" english:@"You have blocked this user." japan:@"このユーザーはあなたをブロックしました。"];
                }else{
                    self.hasPingb = NO;
                    self.hasNoPower = NO;
                }
            }
            if (self.isLead) {
                UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
            
                [rootWindow bringSubviewToFront:_fgView];
            }
        }];
    }
}

- (void)setHasNoPower:(BOOL)hasNoPower{
    _hasNoPower = hasNoPower;
    if (_hasNoPower) {
        self.buttonTapView.hidden = YES;
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+2, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-2);
    }else{
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+2, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-2);
        self.buttonTapView.hidden = NO;
    }
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
            if (self.isChangeIcon) {
                [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate] ischangeIcon:YES];
            }
        }else{
            if (self.isChangeIcon) {
                [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate] ischangeIcon:YES];
            }
        }
    }];
}


- (void)jiaoliuClick{

    if (self.isLead) {
        [self.fgView removeFromSuperview];
    }
    NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
    vc.toUser = self.userM.socket_id;
    vc.isLead = self.isLead;
    vc.lelve = self.userM.levelImgName;
    vc.identType = self.userM.identity_type;
    vc.toUserId = self.userM.user_id;
    vc.navigationItem.title = self.userM.nick_name;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)deleteCare{
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",self.userId] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.userM.is_myadmire = @"0";
            if (self.userM.is_myadmire.intValue) {
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                [self.careButton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"]colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
                if (self.userM.spec_bg_type.intValue < 3) {
                    self.careButton.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
                }
            }else{
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"add.xs"] forState:UIControlStateNormal];
                [self showToastWithText:@"已取消欣赏"];
                self.userM.is_myadmire = @"0";
            }
            if (self.careClickBlock) {
                self.careClickBlock(@"0", self.userId);
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)careClick{
    
    if (self.userM.is_myadmire.intValue) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.surecanxs"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [self showHUD];
                [weakSelf deleteCare];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.userId forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            self.userM.is_myadmire = idM.allId;
            if (self.userM.admire_time.intValue) {
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
                [self.careButton setTitle:[NoticeTools getLocalType]?@"Friends":@"互相欣赏" forState:UIControlStateNormal];
                [self.careButton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"]colorWithAlphaComponent:0.8]  forState:UIControlStateNormal];
                [self showToastWithText:[NoticeTools getLocalStrWith:@"xs.xssus"]];
            }else if (self.userM.is_myadmire.intValue) {
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                [self.careButton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"]colorWithAlphaComponent:0.8]  forState:UIControlStateNormal];
                [self showToastWithText:[NoticeTools getLocalStrWith:@"xs.xssus"]];
                
                if (self.userM.spec_bg_type.intValue < 3) {
                    self.careButton.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
                }
            }else{
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"add.xs"] forState:UIControlStateNormal];
            }
            if (self.careClickBlock) {
                self.careClickBlock(idM.allId, self.userId);
            }
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)moreBtnClick{
    
    NSArray *arr = @[self.userM.relation_status.intValue == 2?[NoticeTools getLocalStrWith:@"intro.canpingb"]: [NoticeTools getLocalStrWith:@"chat.hide"],[NoticeTools getLocalStrWith:@"chat.jubao"]];
    if (self.userM.is_myadmire.intValue) {
        arr = @[self.userM.renew_remind.intValue?[NoticeTools getLocalStrWith:@"intro.noticeme"]:[NoticeTools getLocalStrWith:@"intro.nonoticeme"],[NoticeTools getLocalStrWith:@"setmarkname"], self.userM.relation_status.intValue == 2?[NoticeTools getLocalStrWith:@"intro.canpingb"]: [NoticeTools getLocalStrWith:@"chat.hide"],[NoticeTools getLocalStrWith:@"chat.jubao"]];
    }
    if ([NoticeTools isManager]) {
        arr = @[@"发警告",self.userM.isClose?@"解除禁闭状态" : @"关禁闭",self.userM.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌",@"封号",self.userM.renew_remind.intValue?[NoticeTools getLocalStrWith:@"intro.noticeme"]:[NoticeTools getLocalStrWith:@"intro.nonoticeme"]];
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

    } otherButtonTitleArray:arr];
    sheet.delegate = self;
    [sheet show];
}

- (void)manangerUserWith:(NSInteger)type{
    if (!type) {
        return;
    }
    NSArray *arr = @[@"发警告",self.userM.isClose?@"解除禁闭状态" : @"关禁闭",self.userM.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌",@"封号"];
    self.managerType = type;
    self.magager.type = arr[type-1];
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.managerType == 1) {//发警告
        [parm setObject:@"1" forKey:@"warn"];
    }else if (self.managerType == 2){//关禁闭
        [parm setObject:self.userM.isClose?@"0": @"1" forKey:@"confine"];
    }else if (self.managerType == 3){//仙人掌
        [parm setObject:self.userM.flag.integerValue?@"0" : @"1" forKey:@"flag"];
    }else if (self.managerType == 4){
        [parm setObject:@"3" forKey:@"userStatus"];
    }
    [parm setObject:code forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/users/%@",self.userId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            if (self.managerType == 3) {
                if (self.userM.flag.integerValue) {
                    self.userM.flag = @"0";
                }else{
                    self.userM.flag = @"1";
                }
            }else if (self.managerType == 2){
                self.userM.isClose = !self.userM.isClose;
            }
            [self showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}


- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if ([NoticeTools isManager]) {
        if (buttonIndex >=1 && buttonIndex < 5) {
            [self manangerUserWith:buttonIndex];
        }else if (buttonIndex == 5){
            [self noticeSwitch];
        }
        return;
    }
    if (self.userM.is_myadmire.intValue) {
        if (buttonIndex == 3) {
            [self pinbgi];
        }else if (buttonIndex == 4){
            [self jubao];
        }else if(buttonIndex == 1){
            [self noticeSwitch];
        }else if(buttonIndex == 2){
            [self setNickName];
        }
    }else{
        if (buttonIndex == 1) {
            [self pinbgi];
        }else if (buttonIndex == 2){
            [self jubao];
        }
    }
}

//设置备注名称
- (void)setNickName{
    NoticeChangeNickNameView *inputView = [[NoticeChangeNickNameView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    __weak typeof(self) weakSelf = self;
    inputView.sendBlock = ^(NSString * _Nonnull name) {
        [weakSelf showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:name?name:@"" forKey:@"nickName"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/friends/%@",[NoticeTools getuserId],self.userId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [weakSelf requestUserInfo];
            }
            [weakSelf hideHUD];
        } fail:^(NSError * _Nullable error) {
            [weakSelf hideHUD];
        }];
    };

    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.nameField becomeFirstResponder];
}

- (void)noticeSwitch{
    if (self.userM.renew_remind.intValue) {//关闭欣赏的人内容通知
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:@"0" forKey:@"renewRemind"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/admiresRenew/%@",self.userId] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [self showToastWithText:@"已关闭"];
                self.userM.renew_remind = @"0";
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else{//开启欣赏的人内容通知
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[NoticeTools getuserId]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            
            if (success) {
                NoticeNoticenterModel *noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
                __weak typeof(self) weakSelf = self;
                if (noticeM.admirers_renew.intValue) {//如果总开关开启
                    [self openLikeNotice];
                }else{
                    [self hideHUD];
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"intro.setin"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.noticeOpen"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.keepClose"] right:YES];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 1) {
                            [self showHUD];
                            NSMutableDictionary *parm = [NSMutableDictionary new];
                            [parm setObject:@"1" forKey:@"admirersRenew"];
                            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                                
                                if (success) {
                                    [weakSelf openLikeNotice];
                                }else{
                                    [weakSelf hideHUD];
                                    [weakSelf showToastWithText:dict[@"msg"]];
                                }
                            } fail:^(NSError *error) {
                                [weakSelf hideHUD];
                            }];
                        }
                    };
                    [alerView showXLAlertView];
                }
            }else{
                [self hideHUD];
                [self showToastWithText:dict[@"msg"]];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
}

- (void)openLikeNotice{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"1" forKey:@"renewRemind"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/admiresRenew/%@",self.userId] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.yikaqi"]];
            self.userM.renew_remind = @"1";
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)jubao{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.userId;
    juBaoView.reouceType = @"4";
    [juBaoView showView];
}

- (void)outlahei{
    if (!self.userId) {
        return;
    }
    [self showHUD];
  
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/blacklist/%@",[[NoticeSaveModel getUserInfo]user_id],self.userId] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.canpb"]];
            self.userM.relation_status = @"0";
            [self requestReai];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)pinbgi{
    if (self.userM.relation_status.intValue == 2) {
        [self outlahei];
        return;
    }
    __weak typeof(self) weakSelf = self;
    

     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"提示" english:@"Note" japan:@"リマインダ"] message:[NoticeTools chinese:@"屏蔽后，你们将互相看不到对方的内容。相关互动消息也会被删除，并且不会再恢复。" english:@"All contents related to this user will be hidden from you. Comments and other past interactions will be deleted." japan:@"このユーザーに関連するすべてのコンテンツが非表示になります。コメントと他の過去のやり取りは削除されます。"] sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"chat.hide"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.userId forKey:@"toUserId"];
            [parm setObject:@"1" forKey:@"reasonType"];
            [parm setObject:@"4" forKey:@"resourceType"];
            [parm setObject:self.userId forKey:@"resourceId"];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/shield",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"pingbiNotification" object:self userInfo:@{@"userId":self.userId}];
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"intro.yibp"]];
                    [weakSelf requestReai];
                    weakSelf.hasPingb = YES;
                    weakSelf.userM.relation_status = @"2";
                    [weakSelf.pagerView reloadData];
                    weakSelf.navHeaderView.playBackView.hidden = YES;
                    [weakSelf showToastWithText:[NoticeTools chinese:@"已屏蔽" english:@"Blocked" japan:@"ブロックした"]];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
    

}

- (void)jiaoliu{

    NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
    vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.userId];
    vc.toUserId = self.userId;
    vc.lelve = self.userM.levelImgName;
    vc.navigationItem.title = self.userM.nick_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)iconTap{
    [self.navHeaderView iconTapBig];
}

- (NoticeUserCenterHeaderView *)navHeaderView{
    if (!_navHeaderView) {
        _navHeaderView = [[NoticeUserCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 226)];
        _navHeaderView.isOther = self.isOther;
        __weak typeof(self) weakSelf = self;
        _navHeaderView.changeIcon = ^(BOOL changeIcon) {
            [weakSelf changeIconClick];
        };
        _navHeaderView.playMusic = ^(BOOL play) {
            [weakSelf.voiceVC.voiceVC reSetPlayerData];
        };
    }
    return _navHeaderView;
}

- (void)changeIconClick{
    self.isChangeIcon = YES;
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date ischangeIcon:(BOOL)change{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    //获取七牛token
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"6" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:errorMessage forKey:@"avatarUri"];
            
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    self.navHeaderView.iconImageView.image = image;
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
                        
                        if (success) {
                            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                            [NoticeSaveModel saveUserInfo:userIn];
                   
                        }
                    } fail:^(NSError *error) {
                    }];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
}


- (void)requestUserInfo{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.isOther) {
        self.mbsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:appdel.alphaValue > 0.8? 0.3:appdel.alphaValue];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.isOther?self.userId: [[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.userM = userIn;
            self.navHeaderView.userM = self.userM;
            self.titleL.text = self.userM.nick_name;
         
            if (self.isOther) {
       
                if (self.userM.admire_time.intValue) {
                    self.careButton.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
                    [self.careButton setTitle:[NoticeTools getLocalType]?@"Friends":@"互相欣赏" forState:UIControlStateNormal];
                    [self.careButton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"]colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
                }else if (self.userM.is_myadmire.intValue) {
                    self.careButton.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
                    [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                    [self.careButton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"]colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
                }else{
                    self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                    [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                    [self.careButton setTitle:[NoticeTools getLocalStrWith:@"add.xs"] forState:UIControlStateNormal];
                }
                
                self.backGroundImageView.svagPlayer.hidden = YES;
                [self.backGroundImageView.svagPlayer pauseAnimation];
                
                if (self.userM.spec_bg_type.intValue == 1) {//对方是默认背景
                    self.backGroundImageView.hidden = NO;
                    self.navHeaderView.needToum = YES;
                    if (appdel.backDefaultImg) {
                        self.backGroundImageView.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:appdel.effect];
                    }
                    
                    self.backGroundImageView.svagPlayer.hidden = YES;
                    [self.backGroundImageView.svagPlayer stopAnimation];
                    if (self.userM.is_myadmire.intValue) {
                        self.careButton.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
                    }
                    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                }else if (self.userM.spec_bg_type.intValue == 2 || self.userM.spec_bg_type.intValue == 4){//自定义图片
                    if (self.userM.is_myadmire.intValue) {
                        self.careButton.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
                    }
                    self.backGroundImageView.hidden = NO;
                    self.navHeaderView.needToum = YES;
                    self.backGroundImageView.svagPlayer.hidden = YES;
                    [self.backGroundImageView.svagPlayer pauseAnimation];
                    if (self.userM.spec_bg_type.intValue == 4) {
                        [self.backGroundImageView.parser parseWithURL:[NSURL URLWithString:self.userM.spec_bg_svg_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                            self.backGroundImageView.svagPlayer.videoItem = videoItem;
                            [self.backGroundImageView.svagPlayer startAnimation];
                        } failureBlock:nil];
                        self.backGroundImageView.svagPlayer.hidden = NO;
                    }
                    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                    
                    dispatch_async(globalQueue,^{
                        //子线程下载图片
                        NSURL *url=[NSURL URLWithString:self.userM.spec_bg_type.intValue==2? userIn.spec_bg_photo_url:userIn.spec_bg_skin_url];
                        NSData *data=[NSData dataWithContentsOfURL:url];
                        //将网络数据初始化为UIImage对象
                        UIImage *image=[UIImage imageWithData:data];
                        dispatch_async(mainQueue,^{
                            if(image!=nil){
                                //回到主线程设置图片，更新UI界面
                                UIImage *gqImage = image;
                                self.backGroundImageView.hidden = NO;
                                self.backGroundImageView.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
                            }else{
                                self.backGroundImageView.hidden = NO;
                                [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:userIn.spec_bg_skin_url]];
                            }
                        });
                        
                    });
                
                }else{
                    self.tableView.backgroundColor = self.view.backgroundColor;
                    self.navHeaderView.needToum = NO;
                }
                [self.tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
    }];
}


- (void)testClick{
    NoticeNewTestResultController *ctl = [[NoticeNewTestResultController alloc] init];
    ctl.testType = self.testType;
    ctl.dataArr = self.testArr;
    ctl.userM = self.userM;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isOther) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [self.navHeaderView rePlay];
    [self requestReai];
    if (!self.isOther) {
        [self requestUserInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.voiceVC.voiceVC reSetPlayerData];
    if (self.isLead) {
        [self.fgView removeFromSuperview];
    }
    if (!self.isOther) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
}

- (void)stopPlayMusic{
    if (self.navHeaderView.currentModel.status == 1) {
        [self.navHeaderView playTap];
    }
}

- (void)backClick{
    [self stopPlayMusic];
    [self.navHeaderView.musicPlayer stopPlaying];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)newOrder{
    [self stopPlayMusic];
}

- (void)stopMusic{
    [self stopPlayMusic];
    [self.navHeaderView.musicPlayer stopPlaying];
}
@end
