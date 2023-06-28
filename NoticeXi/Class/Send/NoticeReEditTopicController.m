//
//  NoticeReEditTopicController.m
//  NoticeXi
//
//  Created by li lei on 2020/5/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeReEditTopicController.h"
#import "NoticeTopicViewController.h"
@interface NoticeReEditTopicController ()
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIButton *topicBtn;
@end

@implementation NoticeReEditTopicController

- (void)backToPageAction{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"em.givereedit"] message:[NoticeTools getLocalStrWith:@"em.givecontent"] sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [alerView showXLAlertView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"em.edittopic"] fantText:@"編輯話題"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    if ([NoticeTools isWhiteTheme]) {
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15,25,125,35)];
    self.playerView.timeLen = self.voiceM.voice_len;
    self.playerView.userInteractionEnabled = NO;
    self.playerView.timeL.textColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3E3E4A"];
    self.playerView.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#222238"];
    [self.playerView.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_reeditt_b":@"Image_reeditt_y") forState:UIControlStateNormal];
    self.playerView.leftView.hidden = YES;
    self.playerView.rightView.hidden = YES;
    self.playerView.rightLine.hidden = YES;
    self.playerView.slieView.hidden = YES;
    self.playerView.leftLine.hidden = YES;
    [self.view addSubview:self.playerView];
    
    CGFloat width = (DR_SCREEN_WIDTH-30-20)/3;
    for (int i = 0; i < self.voiceM.img_list.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15+(width+10)*i, CGRectGetMaxY(self.playerView.frame)+25, width, width)];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        mbView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [imageView addSubview:mbView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.voiceM.img_list[i]] placeholderImage:GETUIImageNamed(@"img_empty")];
        [self.view addSubview:imageView];
    }
    
    self.topicBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.playerView.frame)+25+(self.voiceM.img_list.count? (width+25):0), 110, 25)];
    self.topicBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.topicBtn setTitle:GETTEXTWITE(@"sendv.insert") forState:UIControlStateNormal];
    [self.topicBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEBACKCOLOR:@"#B2B2B2"] forState:UIControlStateNormal];
    self.topicBtn.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F90"];
    self.topicBtn.layer.cornerRadius = 25/2;
    self.topicBtn.layer.masksToBounds = YES;
    [self.topicBtn addTarget:self action:@selector(insertClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topicBtn];
    
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        NoticeTopicModel *topic = [[NoticeTopicModel alloc] init];
        topic.topic_name = _voiceM.topic_name;
        topic.topic_id = _voiceM.topic_id;
        self.topicBtn.backgroundColor = GetColorWithName(VBackColor);
        NSString *str = [NSString stringWithFormat:@"#%@#  x",topic.topic_name];
        [self.topicBtn setTitle:str forState:UIControlStateNormal];
        self.topicBtn.frame = CGRectMake(15,CGRectGetMaxY(self.playerView.frame)+25+(self.voiceM.img_list.count? (width+25):0),GET_STRWIDTH(str, 14, 25), 25);
        [self.topicBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, DR_SCREEN_HEIGHT-45-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 45);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
    btn.backgroundColor = GetColorWithName(VMainThumeColor);
    [btn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)sendClick{

    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:(self.voiceM.topic_name && self.voiceM.topic_name.length)?self.voiceM.topic_name:@"" forKey:@"topicName"];
    if (self.voiceM.topic_id && self.voiceM.topic_id.length) {
        [parm setObject:self.voiceM.topic_id forKey:@"topicId"];
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/voices/%@",[NoticeTools getuserId],self.voiceM.voice_id] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (self.reEditBlock) {
                self.reEditBlock(self.voiceM);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)insertClick{
    CGFloat width = (DR_SCREEN_WIDTH-30-20)/3;
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        [self.topicBtn setTitle:GETTEXTWITE(@"sendv.insert") forState:UIControlStateNormal];
        [self.topicBtn setTitleColor:[UIColor colorWithHexString:WHITEBACKCOLOR] forState:UIControlStateNormal];
        self.topicBtn.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.voiceM.topic_name = nil;
        self.topicBtn.frame = CGRectMake(15,CGRectGetMaxY(self.playerView.frame)+25+(self.voiceM.img_list.count? (width+25):0),110, 25);
        return;
    }
    NoticeTopicViewController *ctl = [[NoticeTopicViewController alloc] init];
     __weak typeof(self) weakSelf = self;
    ctl.topicBlock = ^(NoticeTopicModel * _Nonnull topic) {
        weakSelf.voiceM.topic_name = topic.topic_name;
        weakSelf.voiceM.topic_id = topic.topic_id;
        NSString *str = [NSString stringWithFormat:@"#%@#  x",topic.topic_name];
        weakSelf.topicBtn.backgroundColor = GetColorWithName(VBackColor);
        [weakSelf.topicBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
        weakSelf.topicBtn.frame = CGRectMake(15,CGRectGetMaxY(self.playerView.frame)+25+(self.voiceM.img_list.count? (width+25):0),GET_STRWIDTH(str, 14, 25), 25);
        [weakSelf.topicBtn setTitle:str forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
