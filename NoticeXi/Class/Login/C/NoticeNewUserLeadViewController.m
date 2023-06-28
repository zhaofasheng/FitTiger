//
//  NoticeNewUserLeadViewController.m
//  NoticeXi
//
//  Created by li lei on 2022/12/13.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewUserLeadViewController.h"
#import "XJTypeWriterLabel.h"
#import "XJTypeWriterTextView.h"
@interface NoticeNewUserLeadViewController ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *lookButton;
@property (nonatomic, strong) UIImageView *subheaderImageView;
@property (nonatomic, assign) BOOL isFanzhuan;
@property (nonatomic,strong) XJTypeWriterLabel * chatTextLabel;
@end

@implementation NoticeNewUserLeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.headerImageView.image = UIImageNamed(@"Image_userleadernew");
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.view addSubview:self.headerImageView];
    self.headerImageView.userInteractionEnabled = YES;
    
    self.subheaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40,(DR_SCREEN_WIDTH-40)/345*554)];
    self.subheaderImageView.image = UIImageNamed(@"Image_subuserleadernew");
    self.subheaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.subheaderImageView.clipsToBounds = YES;
    self.subheaderImageView.layer.cornerRadius = 2;
    self.subheaderImageView.layer.masksToBounds = YES;
    [self.headerImageView addSubview:self.subheaderImageView];
    self.subheaderImageView.userInteractionEnabled = YES;
    
    UIButton *lookButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-208)/2, CGRectGetMaxY(self.subheaderImageView.frame)-96-126,208, 96)];
    [lookButton setBackgroundImage:UIImageNamed(@"Image_looxin") forState:UIControlStateNormal];
    [self.view addSubview:lookButton];
    [lookButton addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    self.lookButton = lookButton;
    
    self.navBarView.backButton.hidden = YES;
    [self.tableView removeFromSuperview];
    
    [self.navBarView.rightButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.navBarView.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navBarView.rightButton.titleLabel.font = THRETEENTEXTFONTSIZE;
    [self.navBarView.rightButton addTarget:self action:@selector(goMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.navBarView];
    self.isFanzhuan = YES;
    

    NSString *str = @"hi，我是声昔，最近还好吗？\n\n不知道你会不会这样：\n\n遇到开心搞笑的事，想分享的时候，发现身边的朋友好像不太能get到；\n\n遇到难过生气的事，想倾诉的时候，害怕负面情绪会影响到朋友。\n\n希望当你想要分享倾诉的时候，能想起声昔里的我和Ta。";
    _chatTextLabel = [[XJTypeWriterLabel alloc] initWithFrame:CGRectMake(35, 15, self.subheaderImageView.frame.size.width-70,GET_STRHEIGHT(str, 21, self.subheaderImageView.frame.size.width-70))];
    _chatTextLabel.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0];
    _chatTextLabel.font = NOTICEHANTIFONT(20);
    _chatTextLabel.hasSound = NO;
    _chatTextLabel.currentIndex = 14;
    _chatTextLabel.numberOfLines = 0;
    [_chatTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    _chatTextLabel.typewriteEffectColor = [UIColor colorWithHexString:@"#25262E"];
    _chatTextLabel.textColor = _chatTextLabel.backgroundColor;//开始的文字颜色设置为零
    _chatTextLabel.textAlignment = NSTextAlignmentLeft;
    _chatTextLabel.typewriteTimeInterval = 0.1;
//    @weakify(self);
    _chatTextLabel.typewriteEffectBlock = ^(){
//        @strongify(self);
//        [self typeNext];
//        if (App.needLoadCellArray.count == 0) {
//            [CLUserNotificationCenter postNotificationName:kNotificationName_enableClick object:self.model];
//        }
    };
    [self.subheaderImageView addSubview:_chatTextLabel];
}

- (void)lookClick{
    if (!self.isFanzhuan) {
        [self goMain];
        return;
    }
    
    if (self.isFanzhuan) {
        self.isFanzhuan = NO;
    }
    [UIView transitionWithView:self.subheaderImageView duration:2.0f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.lookButton.frame = CGRectMake((DR_SCREEN_WIDTH-145)/2, CGRectGetMaxY(self.subheaderImageView.frame)+ (ISIPHONEXORLATER? 25:10),145, 44);
        [self.lookButton setBackgroundImage:UIImageNamed(@"Image_looxined") forState:UIControlStateNormal];
        
        self.subheaderImageView.image = UIImageNamed(@"Image_leadxinfeng");
    } completion:^(BOOL finished) {
        self.chatTextLabel.text = @"hi，我是声昔，最近还好吗？\n\n不知道你会不会这样：\n\n遇到开心搞笑的事，想分享的时候，发现身边的朋友好像不太能get到；\n\n遇到难过生气的事，想倾诉的时候，害怕负面情绪会影响到朋友。\n\n希望当你想要分享倾诉的时候，能想起声昔里的我和Ta。";
        [self.chatTextLabel startTypewrite];
    }];

}

- (void)goMain{
    [NoticeComTools saveHasShowLeader];
    [self.chatTextLabel.countDownTimer invalidate];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.chatTextLabel.countDownTimer invalidate];
    self.chatTextLabel.countDownTimer = nil;
}
@end
