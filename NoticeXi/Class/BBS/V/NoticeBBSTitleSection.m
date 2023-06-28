//
//  NoticeBBSTitleSection.m
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSTitleSection.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeBBSDetailController.h"

@implementation NoticeBBSTitleSection

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetail)];
        [self.contentView addGestureRecognizer:tap];
        
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 8)];
        self.line.backgroundColor = GetColorWithName(VBigLineColor);
        [self.contentView addSubview:self.line];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 23, DR_SCREEN_WIDTH-30, 70)];
        view.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#222238"];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(30,0, DR_SCREEN_WIDTH-30-60, 70)];
        self.titleL.font = [UIFont systemFontOfSize:16];
        self.titleL.numberOfLines = 0;
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.titleL];
        
        UIImageView *markImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 24)];
        markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_bbsmark_b":@"Image_bbsmark_y");
        [view addSubview:markImage];
        
        self.backView = view;
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame), DR_SCREEN_WIDTH-40, 0)];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = GetColorWithName(VMainTextColor);
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.contentL];
        
        UILabel *lyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(view.frame)+10, 100, 34)];
        lyLabel.text = [NoticeTools getTextWithSim:@"热门留言" fantText:@"熱門留言"];
        lyLabel.font = FIFTHTEENTEXTFONTSIZE;
        lyLabel.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:lyLabel];
        self.lyL = lyLabel;
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.contentL.frame)+15, DR_SCREEN_WIDTH, 0)];
        [self addSubview:self.imageViewS];

    }
    return self;
}

- (void)tapDetail{
    
    NoticeBBSDetailController *ctl = [[NoticeBBSDetailController alloc] init];
    ctl.bbsModel = self.bbsModel;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)setBbsModel:(NoticeBBSModel *)bbsModel{
    _bbsModel = bbsModel;
    self.titleL.attributedText = bbsModel.titleAttStr;

    self.backView.frame = CGRectMake(15, 23, DR_SCREEN_WIDTH-30, bbsModel.titleHeight);
    self.titleL.frame = CGRectMake(30,0, DR_SCREEN_WIDTH-30-60, bbsModel.titleHeight);
    
    self.contentL.attributedText = bbsModel.fiveAttTextStr;
    self.contentL.frame = CGRectMake(20, CGRectGetMaxY(self.backView.frame)+10, DR_SCREEN_WIDTH-40, bbsModel.fiveTextHeight);
    
    self.imageViewS.hidden = bbsModel.annexsArr.count?NO:YES;
    self.imageViewS.frame = CGRectMake(0,CGRectGetMaxY(self.contentL.frame)+15, DR_SCREEN_WIDTH,bbsModel.imgHeight-15);
    if (bbsModel.annexsArr.count) {
        NSMutableArray *imgListArr = [NSMutableArray new];
        for (NoticeAnnexsModel *imgM in bbsModel.annexsArr) {
            [imgListArr addObject:imgM.annex_url];
        }

        self.imageViewS.imgArr = imgListArr;
    }
    
    if (self.imageViewS.hidden) {
        self.lyL.frame = CGRectMake(15, CGRectGetMaxY(self.contentL.frame)+5, 100, 34);
    }else{
        self.lyL.frame = CGRectMake(15, CGRectGetMaxY(self.imageViewS.frame)+5, 100, 34);
    }
    
}

@end
