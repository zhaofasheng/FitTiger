//
//  NoticeDrawViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawViewController.h"
#import "NoticeTopicViewController.h"
#import "NoticeTuYaChatWithOtherController.h"
#import "NoticeDrawShowListController.h"
#import "UIImage+Color.h"
#import "NoticeDrawTools.h"
#import "DDHAttributedMode.h"
#import "SPMultipleSwitch.h"
#import "DrawView.h"
@interface NoticeDrawViewController ()<NoticeChoicePenAndColorDelegate,DrawDelegate>
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *navline;
@property (nonatomic, strong) UIButton *topicBtn;
@property (nonatomic, strong) UILabel *sendBtn;
@property (nonatomic, strong) UIButton *beforeBtn;
@property (nonatomic, strong) UIButton *furetureBtn;
@property (nonatomic, strong) NoticeDrawTools *tools;
@property (nonatomic, strong) DrawView *drawView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) BOOL hasDraws;
@property (nonatomic, assign) BOOL haspop;
@property (nonatomic, assign) NSInteger drawViewType;
@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, assign) CGFloat totalScale;
@property (nonatomic, assign) CGFloat oldX;
@property (nonatomic, assign) CGFloat oldY;
@end

@implementation NoticeDrawViewController
{
    CGPoint lastPoint;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];

    if (self.isTuYa) {
        if ([NoticeTools isFirstDrawOnThisDeveicetuya]) {
            [self.view addSubview:self.titleHeadView];
        }
    }else{
        if ([NoticeTools isFirstDrawOnThisDeveice]) {
            [self.view addSubview:self.titleHeadView];
        }
    }
    
    UILabel *btn = [[UILabel alloc] init];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-15-60, STATUS_BAR_HEIGHT,60,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    btn.text = self.isTuYa?[NoticeTools getLocalStrWith:@"read.send"]: [NoticeTools getLocalStrWith:@"py.send"];
    btn.font = SIXTEENTEXTFONTSIZE;
    btn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.5];
    btn.userInteractionEnabled = YES;
    btn.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
    [btn addGestureRecognizer:sendTap];
    _sendBtn = btn;
    [self.view addSubview:btn];
    
    UILabel *backBtn = [[UILabel alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT,60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    backBtn.text = [NoticeTools getLocalStrWith:@"main.cancel"];
    backBtn.textColor = [UIColor colorWithHexString:@"#ACB3BF"];
    backBtn.font = SIXTEENTEXTFONTSIZE;
    backBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToPageAction)];
    [backBtn addGestureRecognizer:backTap];
    [self.view addSubview:backBtn];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-120, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titleL.text = self.isTuYa?[NoticeTools getLocalStrWith:@"em.tuya"] :[NoticeTools getLocalStrWith:@"main.draw"];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+55, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
    imgView.userInteractionEnabled = YES;
    imgView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    if (self.tuyeImage) {
        imgView.image = self.tuyeImage;
     }
    [self.view addSubview:imgView];
    self.backImageView = imgView;
    
    //画板
    self.totalScale = 1.0;
    self.drawView = [[DrawView alloc] initWithFrame:CGRectMake(0,0, self.backImageView.frame.size.width, self.backImageView.frame.size.height)];
    self.drawView.lineColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.drawView.lineWidth = 1;
    self.drawView.drawViewType = 1;
    self.drawView.delegate = self;
    self.drawView.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:self.isTuYa?0:1];
    [imgView addSubview:self.drawView];
    
    if (!self.isTuYa) {
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [self.drawView addGestureRecognizer:pinchGestureRecognizer];
    }

    UIView *senBackV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-50-10-20, DR_SCREEN_WIDTH, 200)];
    senBackV.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    [self.view addSubview:senBackV];
    
    //工具栏
    self.tools = [[NoticeDrawTools alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH,50)];
    self.tools.delegate = self;
    self.tools.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    [self.view addSubview:self.tools];
    

    self.topicBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.backImageView.frame)+10, 84, 24)];
    self.topicBtn.titleLabel.font = XGELEVENBoldFontSize;
    [self.topicBtn setTitle:[NoticeTools getLocalStrWith:@"em.daigetopic"] forState:UIControlStateNormal];
    [self.topicBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.topicBtn.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
    self.topicBtn.layer.cornerRadius = 24/2;
    self.topicBtn.layer.masksToBounds = YES;
    [self.topicBtn addTarget:self action:@selector(insertClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topicBtn];
    if (self.isTuYa) {
        self.topicBtn.hidden = YES;
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,self.topicBtn.frame.origin.y-10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.topicBtn.frame.origin.y+10)];
    backView.backgroundColor = GetColorWithName(VBackColor);
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
        
    self.backImageView.frame = CGRectMake(0,backView.frame.origin.y-DR_SCREEN_WIDTH, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,self.backImageView.frame.origin.y)];
    topView.backgroundColor = GetColorWithName(VBackColor);
    [self.view addSubview:topView];
    [self.view sendSubviewToBack:topView];
    [self.view sendSubviewToBack:self.backImageView];
    
    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"main.draw"],[NoticeTools getLocalStrWith:@"em.big"]]];
    switch1.titleFont = FOURTHTEENTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,self.tools.frame.origin.y-20-30-20,146, 30);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#FFFFFF"];
    switch1.titleColor = [UIColor colorWithHexString:@"#8A8F99"];
    switch1.trackerColor = [UIColor colorWithHexString:@"#0099E6"];
    switch1.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
    [self.view addSubview:switch1];
    switch1.hidden = YES;
    if (!self.isTuYa) {
        switch1.hidden = NO;
    }

    if (self.topicM) {
        NSString *str = self.isTuYa? [NSString stringWithFormat:@"#%@#",self.topicM.topic_name]: [NSString stringWithFormat:@"#%@#",self.topicM.topic_name];
        [self.topicBtn setTitle:str forState:UIControlStateNormal];
        self.topicBtn.frame = CGRectMake(20,CGRectGetMaxY(self.backImageView.frame)+10,GET_STRWIDTH(str, 14, 25)+10, 24);
    }
    self.beforeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-30-30-30,switch1.frame.origin.y, 30, 30)];
    [self.beforeBtn setImage:UIImageNamed(@"Image_drawbefore_nb") forState:UIControlStateNormal];
    [self.beforeBtn addTarget:self action:@selector(beforeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beforeBtn];

    self.furetureBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-30,switch1.frame.origin.y, 30, 30)];
    [self.furetureBtn setImage:UIImageNamed(@"Image_furture_nb") forState:UIControlStateNormal];
    [self.furetureBtn addTarget:self action:@selector(furetureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.furetureBtn];
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.drawView.drawViewType = (int)swithbtn.selectedSegmentIndex+1;
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)gesture
{
    if (self.drawView.drawViewType != 2) {
        return;
    }
    if ([gesture numberOfTouches] < 2){
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastPoint = [gesture locationInView:self.drawView];
    }

    CGPoint point = [gesture locationInView:self.drawView];
    [self.drawView.layer setAffineTransform:
        CGAffineTransformTranslate([self.drawView.layer affineTransform],
                                   point.x - lastPoint.x,
                                   point.y - lastPoint.y)];
    lastPoint = [gesture locationInView:self.drawView];
    if (gesture.scale > 1.0) {
        if(self.totalScale > 2.0) return;
    }
    if (gesture.scale < 1.0) {
        if(self.totalScale < 0.75) return;
    }
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    self.totalScale *= gesture.scale;
    gesture.scale = 1;
    
}

- (void)hasMoveX:(CGFloat)x moveY:(CGFloat)y{
    self.oldX = x;
    self.oldY = y;
}

- (void)beforeClick{
    [self.drawView undo];
}

- (void)furetureClick{
    [self.drawView reBack];
}

//判断是否可返回或者可前进
- (void)refreshHasUndo:(BOOL)hasUndo hasReback:(BOOL)hasReback{
    
    if (hasUndo) {
        self.hasDraws = YES;
        self.sendBtn.textColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.beforeBtn setImage:UIImageNamed(@"Image_drawbefore_b") forState:UIControlStateNormal];
    }else{
        self.hasDraws = NO;
        self.sendBtn.textColor = [UIColor colorWithHexString:@"#ACB3BF"];
        [self.beforeBtn setImage:UIImageNamed(@"Image_drawbefore_nb") forState:UIControlStateNormal];
    }
    
    if (hasReback) {
        [self.furetureBtn setImage:UIImageNamed(@"Image_furture_b") forState:UIControlStateNormal];
    }else{
        [self.furetureBtn setImage:UIImageNamed(@"Image_furture_nb") forState:UIControlStateNormal];
    }
}

- (void)sendClick{
    if (!self.hasDraws) {
        return;
    }
    self.drawView.frame = CGRectMake(0,0, self.backImageView.frame.size.width, self.backImageView.frame.size.height);
    self.drawView.transform = CGAffineTransformScale(self.drawView.transform, 1, 1);
    _sendBtn.userInteractionEnabled = NO;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.isTuYa ? @"4" : @"14" forKey:@"resourceType"];
    [parm setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]] forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:[self shotShareImage] parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message, NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            self->_sendBtn.userInteractionEnabled = YES;
            return ;
        }else{
            if (self.isTuYa) {
                NSInteger length = [UIImageJPEGRepresentation([self shotShareImage] , 1) length]/1024;
                NSMutableDictionary *messageDic = [NSMutableDictionary new];
                [messageDic setObject:@"2" forKey:@"dialogContentType"];
                [messageDic setObject:@"0" forKey:@"voiceId"];
                if (bucketId) {
                    [messageDic setObject:bucketId forKey:@"bucketId"];
                }
                [messageDic setObject:Message forKey:@"dialogContentUri"];
                [messageDic setObject:length? [NSString stringWithFormat:@"%ld",(long)length] : @"10" forKey:@"dialogContentLen"];
                [messageDic setObject:@"3" forKey:@"chatType"];
                [messageDic setObject:self.drawId forKey:@"resourceId"];
                
                NSMutableDictionary * sendDic = [NSMutableDictionary new];
                [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userId] forKey:@"to"];
                [sendDic setObject:@"singleChat" forKey:@"flag"];
                [sendDic setObject:messageDic forKey:@"data"];
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appdel.socketManager sendMessage:sendDic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGETHEROOTSELECTARTTY" object:self userInfo:@{@"drawId":self.drawId,@"add":@"1"}];
                if (self.isFromDrawList) {
                    NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
                    ctl.toUserId = self.userId;
                    ctl.drawId = self.drawId;
                    ctl.fromNomerl = YES;
                    [self.navigationController pushViewController:ctl animated:YES];
                    __weak typeof(self) weakSelf = self;
                    ctl.backBlock = ^(BOOL back) {
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                    };
                    return;
                }
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [self upWith:Message buckId:bucketId];
        }
    }];
}

- (void)hasDraw{
    self.hasDraws = YES;
}

- (void)upWith:(NSString *)imgStr buckId:(NSString *)bucket{
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (bucket) {
        [parm setObject:bucket forKey:@"bucketId"];
    }
    [parm setObject:imgStr forKey:self.isTuYa ? @"graffitiUri" : @"artworkUri"];
    if (self.topicM && !self.isTuYa) {
        [parm setObject:self.topicM.topic_name forKey:@"topicName"];
        if (self.topicM.topic_id) {
            [parm setObject:self.topicM.topic_id forKey:@"topicId"];
        }
    }
    if (self.isTuYa) {
        [parm setObject:self.drawId?self.drawId:@"" forKey:@"artworkId"];
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isTuYa ? @"graffitis" : [NSString stringWithFormat:@"users/%@/artwork",[[NoticeSaveModel getUserInfo] user_id]] Accept:self.isTuYa ? @"application/vnd.shengxi.v4.1+json" : @"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEROOTSELECTART" object:nil];
            
            if (!self.haspop) {
                self.haspop = YES;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:1 animations:^{
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"py.sendsus"]];
                } completion:^(BOOL finished) {
                    if (self.isFromSelf) {
                        __block UIViewController *pushVC;
                        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NoticeDrawShowListController class]]) {//返回到指定界面
                                pushVC = obj;
                                [self.navigationController setNavigationBarHidden:NO animated:NO];
                                [weakSelf.navigationController popToViewController:pushVC animated:YES];
                                return ;
                            }
                        }];
                        return;
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }else{
           self->_sendBtn.userInteractionEnabled = YES;
        }
    } fail:^(NSError *error) {
        self->_sendBtn.userInteractionEnabled = YES;
        [self hideHUD];
    }];
}

- (UIImage *)shotShareImage{
    //高清方法
    //第一个参数表示区域大小 第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    CGSize size = CGSizeMake(self.backImageView.layer.bounds.size.width, self.backImageView.layer.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.backImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)choiceColorWith:(UIColor *)color{
    self.drawView.lineColor = color;
}

- (void)choicePenWidth:(CGFloat)width{
    self.drawView.lineWidth = width;
}

- (void)choiceXpcWith:(CGFloat)width{
    self.drawView.lineWidth = width;
    self.drawView.lineColor =self.isTuYa?self.backImageView.backgroundColor: self.drawView.backgroundColor;
}

- (void)cancelXpcWith:(CGFloat)width color:(UIColor *)color{
    self.drawView.lineWidth = width;
    self.drawView.lineColor = color;
}

- (void)insertClick{
    if (self.isTuYa) {
        return;
    }
    CGFloat topHeight = 0;
    if ([NoticeTools isFirstDrawOnThisDeveice]) {
        topHeight = 95;
    }else{
        topHeight = 25;
    }
    if (self.topicM) {
        [self.topicBtn setTitle:[NoticeTools getLocalStrWith:@"em.daigetopic"] forState:UIControlStateNormal];
       self.topicBtn.frame= CGRectMake(20,CGRectGetMaxY(self.backImageView.frame)+10,84, 24);
        self.topicM = nil;
        return;
    }
    NoticeTopicViewController *ctl = [[NoticeTopicViewController alloc] init];
    ctl.isDraw = YES;
    __weak typeof(self) weakSelf = self;
    ctl.topicBlock = ^(NoticeTopicModel * _Nonnull topic) {
        weakSelf.topicM = topic;
        NSString *str = [NSString stringWithFormat:@"#%@#",topic.topic_name];
        [weakSelf.topicBtn setTitle:str forState:UIControlStateNormal];
        self.topicBtn.frame= CGRectMake(20,CGRectGetMaxY(self.backImageView.frame)+10,GET_STRWIDTH(str, 14, 25)+10, 24);
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20, 10+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 35)];
        _titleHeadView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 35)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"py.rul"];
        label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        label.numberOfLines = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 35)];
        [button setImage:UIImageNamed(@"Image_sendXX") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    if (self.isTuYa) {
        [NoticeTools setMarkForDrawtuya];
    }else{
        [NoticeTools setMarkForDraw];
    }
    self.titleHeadView.hidden = YES;

}

- (void)backToPageAction{
    if (self.hasDraws) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"em.givesend"] message:[NoticeTools getLocalStrWith:@"em.givecontent"] sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
