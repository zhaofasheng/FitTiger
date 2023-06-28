//
//  NoticeTestViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/25.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTestViewController.h"
#import "DRPsychologyViewController.h"
#import "NoticePsyModel.h"
#import "DDHAttributedMode.h"
@interface NoticeTestViewController ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *numsL;
@end

@implementation NoticeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = GETTEXTWITE(@"listen.cyc");
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.backImageView.image = UIImageNamed(@"Image_backtext_nx");
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    [self.view addSubview:self.backImageView];
    
    BOOL isIphone5;
    if (DR_SCREEN_HEIGHT < 667) {
        isIphone5 = YES;
    }else{
        isIphone5 = NO;
    }
    
    UIImageView *centerImageVieww = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 62)];
    centerImageVieww.center = CGPointMake(self.backImageView.center.x, self.backImageView.center.y-NAVIGATION_BAR_HEIGHT/2);
    centerImageVieww.image = [NoticeTools isSimpleLau] ? UIImageNamed(@"Image_test_iaosj") : UIImageNamed(@"Image_test_iaosf");
    [self.view addSubview:centerImageVieww];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-127)/2,CGRectGetMaxY(centerImageVieww.frame)+(isIphone5 ? 70 : 90), 127, 131)];
    [startBtn setBackgroundImage:UIImageNamed(@"Image_test_bottom") forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startTestClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-262)/2,0,262, 161)];
    titleImageView.image = [NoticeTools isSimpleLau] ? UIImageNamed(@"Image_test_titlej") : UIImageNamed(@"Image_test_titlef");
    

    [self.view addSubview:titleImageView];
    
    self.numsL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleImageView.frame)+20, DR_SCREEN_WIDTH, 30)];
    self.numsL.textAlignment = NSTextAlignmentCenter;
    self.numsL.textColor = [UIColor colorWithHexString:@"#008ece"];
    self.numsL.font = FOURTHTEENTEXTFONTSIZE;
    [self.view addSubview:self.numsL];

    [self requestNumber];
}

- (void)requestNumber{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"personalityTest/dailyStatistics" Accept:@"application/vnd.shengxi.v3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {

        if (success) {
            NoticePsyModel *model = [NoticePsyModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.num.integerValue) {
                NSString *str = [NoticeTools isSimpleLau]?@"位小伙伴做过测试":@"位小夥伴做過測試";
                self->_numsL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"今天有%@%@",model.num,str] setColor:[UIColor colorWithHexString:@"#feef3d"] setLengthString:model.num beginSize:3];
            }
        }
    } fail:^(NSError *error) {

    }];
}

- (void)startTestClick{
    DRPsychologyViewController * ctl = [[DRPsychologyViewController alloc] init];
    ctl.isFromStart = YES;
    ctl.isFromShake = self.isFromShake;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
