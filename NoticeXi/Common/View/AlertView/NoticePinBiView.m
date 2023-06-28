//
//  NoticePinBiView.m
//  NoticeXi
//
//  Created by li lei on 2019/6/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePinBiView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSendViewController.h"
#import "NoticeChangeServerAreaController.h"
#import "AFHTTPSessionManager.h"
#import "DDHAttributedMode.h"
@implementation NoticePinBiView
{
    NSMutableArray *_buttonArr;
    UIButton *_pinbBtn;
    UIButton *_cancelBtn;
    BOOL _isNoTost;
    BOOL _know;
    UIImageView *_choiceImg;
}

- (instancetype)initWithLeaderView{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,111)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,325,111)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"zj.tosta"]:@"移除心情:左滑心情條，點擊「移出」\n添加心情:每個已發布的心情，都可點擊右下角\n「更多」加入，或在時光機中點擊「加入專輯」";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithLeaderView1{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,111)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35,0,325-35,111)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = [NoticeTools getLocalStrWith:@"zj.tosat1"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithDeleteGroupMember{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.type = 0;
        
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 322)];
        self.tostView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self.markView removeFromSuperview];
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.tostView.frame.size.width, 14)];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NoticeTools getLocalStrWith:@"groupManager.dele"];
        [self.tostView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame), self.tostView.frame.size.width, 50)];
        label1.textColor = [UIColor colorWithHexString:@"#737780"];
        label1.font = TWOTEXTFONTSIZE;
        label1.numberOfLines = 0;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = [NoticeTools getLocalStrWith:@"groupManager.markdele"];
        [self.tostView addSubview:label1];
        
        NSArray *arrCHN = @[[NoticeTools getLocalStrWith:@"groupManager.delereason1"],[NoticeTools getLocalStrWith:@"groupManager.delereason2"],[NoticeTools getLocalStrWith:@"groupManager.delereason3"]];
        _buttonArr = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+65+55*i, self.tostView.frame.size.width-60, 40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [btn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
            [btn setTitle:arrCHN[i] forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(choiceTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [self.tostView addSubview:btn];
            [_buttonArr addObject:btn];
        }
        
        UIButton *oriBtn = _buttonArr[2];
        NSArray *chnArr = @[[NoticeTools getLocalStrWith:@"groupManager.del"],[NoticeTools getLocalStrWith:@"main.cancel"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.tostView.frame.size.width-204)/2+102*i, CGRectGetMaxY(oriBtn.frame),102,self.tostView.frame.size.height-CGRectGetMaxY(oriBtn.frame))];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if (i == 0) {
                _pinbBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#737780"] forState:UIControlStateNormal];
            }else{
                _cancelBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
            }
            [btn setTitle:chnArr[i] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(sureOrCancelClick1:) forControlEvents:UIControlEventTouchUpInside];
            [self.tostView addSubview:btn];
        }
    }
    return self;
}

- (instancetype)initWithLeaderViewZjLlimiy{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,87)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,325,87)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = @"收藏对话:长按私聊或悄悄话音频，点击「收藏」\n删除对话:左滑对话条，点击「删除」";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (instancetype)initWithAddZJView{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,80)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,325,80)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = [NoticeTools isSimpleLau]?@"已发布的心情，点击右下角「更多」加入\n或在时光机中点击「加入专辑」":@"已發布的心情，點擊右下角「更多」加入\n或在時光機中點擊「加入專輯」";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithLeaderJuBaoView{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,111)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,0,325,111)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = [NoticeTools isSimpleLau]?@"-举报涂鸦:\n长按想要举报的涂鸦图片\n-举报用户:\n点击用户头像，在封面页右上角点击···":@"-舉報回聲或私聊:\n長按想要舉報的語音條或圖片\n-舉報用戶:\n點擊用戶頭像，在封面頁右上角點擊···";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        //label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (instancetype)initWithLeaderJuBaoView1{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,111)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,0,325,111)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = [NoticeTools isSimpleLau]?@"-举报悄悄话或私聊:\n长按想要举报的语音条或图片\n-举报用户:\n点击用户头像，在封面页右上角点击···":@"-舉報回聲或私聊:\n長按想要舉報的語音條或圖片\n-舉報用戶:\n點擊用戶頭像，在封面頁右上角點擊···";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        //label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithImageView{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 294, 454)];
        imgView.center = self.center;
        [self addSubview:imgView];
        imgView.image = UIImageNamed(@"Image_mh_bh");
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithLeaderJuBaoViewDraw{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,111)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,0,325,111)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = @"-举报涂鸦:\n长按想要举报的涂鸦图片\n-举报用户:\n点击用户头像，在封面页右上角点击···";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        //label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithWarnWord:(NSString *)warnWord{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,281,87)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,281,87)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str =[NSString stringWithFormat:@"【%@】%@",warnWord,[NoticeTools isSimpleLau]?@"是敏感词\n请修改后在发布":@"敏感詞\n請修改後在發布"];
        NSMutableAttributedString *attributedString = [DDHAttributedMode setColorString:str setColor:[UIColor redColor] setLengthString:warnWord beginSize:1];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];

        
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (instancetype)initWithLeaderWorld{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,197)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,325,197)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = [NoticeTools isSimpleLau]?@"什么是「个性化」?\n通过你共享的心情，为你展示与你个性相近的\n人最近共享的心情，共享的心情越多结果越准\n\n如何开启「个性化」 :\n-完成社团「测一测」\n-共享至少1条心情到「操场」":@"什麽是「個性化」?\n通過妳共享的心情，為妳展示與妳個性相近的\n人最近共享的心情，共享的心情越多結果越準\n\n如何開啟「個性化」 :\n-完成社團「測壹測」\n-共享至少1條心情到「操场」";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        //label.textAlignment = NSTextAlignmentCenter;
        //label.center = self.tostView.center;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithNoticeView{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,281,190)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,25,281,18)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = EIGHTEENTEXTFONTSIZE;
        label.text = [NoticeTools isSimpleLau]?@"无法开启闹钟":@"無法開啟鬧鐘";
        label.textAlignment = NSTextAlignmentCenter;
        [self.tostView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame),281,77)];
        label1.textColor = GetColorWithName(VDarkTextColor);
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.text = [NoticeTools isSimpleLau]?@"无法开启闹钟":@"無法開啟鬧鐘";
        NSString *str = [NoticeTools isSimpleLau]?@"当前APP通知已关闭\n开启后闹钟才能正常使用":@"當前APP通知已關閉\n開啟後鬧鐘才能正常使用";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label1.attributedText = attributedString;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.numberOfLines = 0;
        [self.tostView addSubview:label1];
        
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label1.frame), self.tostView.frame.size.width-30, 46)];
        setBtn.layer.cornerRadius = 23;
        setBtn.layer.masksToBounds = YES;
        setBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        [setBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        setBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [setBtn setTitle:[NoticeTools isSimpleLau]?@"去设置":@"去設置" forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setNoticeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tostView addSubview:setBtn];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_clockclose":@"Image_clockclosey") forState:UIControlStateNormal];
        button.enabled = NO;
        [self addSubview:button];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;

}

- (instancetype)initWithNoticeViewWarn{
    if (self = [super init]) {
        NSString *str = [NoticeTools isSimpleLau]?@"由于IOS系统限制，在APP未打开，或手机处于锁屏状态时会播放默认铃声，当进入APP后会切换到您的自定义配音":@"由於IOS系統限制，在APP未打開，或手機處於鎖屏狀態時會播放默認鈴聲，當進入APP後會切換到您的自定義配音";
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,281,259+24)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,25,281,18)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = EIGHTEENTEXTFONTSIZE;
        label.text = [NoticeTools isSimpleLau]? @"自定义闹钟小提醒":@"自定義鬧鐘小提醒";
        label.textAlignment = NSTextAlignmentCenter;
        [self.tostView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(28,CGRectGetMaxY(label.frame)+21,281-56,GET_STRHEIGHT(str, 14, 281-56)+24)];
        label1.textColor = GetColorWithName(VDarkTextColor);
        label1.font = FOURTHTEENTEXTFONTSIZE;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label1.attributedText = attributedString;
        label1.numberOfLines = 0;
        [self.tostView addSubview:label1];
        
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label1.frame)+20, self.tostView.frame.size.width-30, 46)];
        setBtn.layer.cornerRadius = 23;
        setBtn.layer.masksToBounds = YES;
        setBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        [setBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        setBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [setBtn setTitle:[NoticeTools getLocalStrWith:@"group.knowjoin"] forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(noWarnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tostView addSubview:setBtn];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(setBtn.frame)+15, 22, 22)];
        imgV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Img_clock_seldayn":@"Img_clock_seldayny");
        [self.tostView addSubview:imgV];
        _choiceImg = imgV;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10,CGRectGetMaxY(setBtn.frame)+20, 70, 13)];
        label2.text = @"不再提醒";
        label2.font = THRETEENTEXTFONTSIZE;
        label2.textColor = GetColorWithName(VDarkTextColor);
        [self.tostView addSubview:label2];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(setBtn.frame), 110, 52)];
        [self.tostView addSubview:tapView];
        
        tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrClose)];
        [tapView addGestureRecognizer:tap];
    }
    return self;
}

- (void)openOrClose{
    _isNoTost = !_isNoTost;
    if (_isNoTost) {
        _choiceImg.image =  UIImageNamed([NoticeTools isWhiteTheme]?@"Img_clock_selday":@"Img_clock_seldayy");
    }else{
       _choiceImg.image =  UIImageNamed([NoticeTools isWhiteTheme]?@"Img_clock_seldayn":@"Img_clock_seldayny");
    }
}

- (void)noWarnClick{
    if (_isNoTost) {
        [NoticeTools setMarkForOpenClock];
    }
    [self closeTap];
}

- (void)setNoticeClick{
    [self closeTap];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:nil];
            }
        } else {
            [application openURL:url options:@{} completionHandler:nil];
        }
    }
}

- (instancetype)initWithLeaderBook:(NSInteger)type{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 325,197)];
        self.tostView.backgroundColor = GetColorWithName(VBackColor);
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,325,197)];
        label.textColor = GetColorWithName(VMainTextColor);
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        NSString *str = nil;
        if (type == 2) {
            str = [NoticeTools isSimpleLau]?@"什么是欣赏?\n欣赏用户的书籍心情后，就可以在这里看到Ta的\n全部公开书籍心情(30天后自动解除欣赏)\n\n怎样欣赏？\n他人的书籍心情右下角点「更多」\n选择「欣赏Ta的书籍心情」, 点击「欣赏」":@"什麽是關註?\n關註用戶的書籍心情後，就可以在這裏看到Ta的\n全部公開書籍心情(30天後自動解除關註)\n\n怎樣關註？\n他人的書籍心情右下角點「更多」\n選擇「關註Ta的書籍心情」, 點擊「關註」";
        }else if (type == 1){
           str = [NoticeTools isSimpleLau]?@"什么是欣赏?\n欣赏用户的电影心情后，就可以在这里看到Ta的\n全部公开电影心情(30天后自动解除欣赏)\n\n怎样欣赏？\n他人的电影心情右下角点「更多」\n选择「欣赏Ta的电影心情」, 点击「欣赏」":@"什麽是關註?\n關註用戶的电影心情後，就可以在這裏看到Ta的\n全部公開电影心情(30天後自動解除關註)\n\n怎樣關註？\n他人的电影心情右下角點「更多」\n選擇「關註Ta的电影心情」, 點擊「關註」";
        }else{
             str = [NoticeTools isSimpleLau]?@"什么是欣赏?\n欣赏用户的音乐心情后，就可以在这里看到Ta的\n全部公开音乐心情(30天后自动解除欣赏)\n\n怎样欣赏？\n他人的音乐心情右下角点「更多」\n选择「欣赏Ta的音乐心情」, 点击「欣赏」":@"什麽是關註?\n關註用戶的音乐心情後，就可以在這裏看到Ta的\n全部公開音乐心情(30天後自動解除關註)\n\n怎樣關註？\n他人的音乐心情右下角點「更多」\n選擇「關註Ta的音乐心情」, 點擊「關註」";
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        label.attributedText = attributedString;
        [self.tostView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2, CGRectGetMaxY(self.tostView.frame)+25, 30, 30)];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zj_tost_close":@"zj_tost_closey") forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)closeTap{
    [self removeFromSuperview];
}

- (instancetype)initWithPinBiView{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.type = 0;
        
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 277)];
        self.tostView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self.markView removeFromSuperview];
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, self.tostView.frame.size.width, 18)];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGEightBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NoticeTools getLocalStrWith:@"pingbi.title"];
        [self.tostView addSubview:label];

        NSArray *arrCHN = @[[NoticeTools getLocalStrWith:@"pingbi.reason"],[NoticeTools getLocalStrWith:@"pingbi.reason1"],[NoticeTools getLocalType]?@"No reason":@"没啥理由，就想屏蔽ta"];
        _buttonArr = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+25+55*i, self.tostView.frame.size.width-60, 40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [btn setTitle:arrCHN[i] forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(choiceTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [self.tostView addSubview:btn];
            [_buttonArr addObject:btn];
        }
        
  
        NSArray *chnArr = @[[NoticeTools getLocalStrWith:@"chat.hide"],[NoticeTools getLocalStrWith:@"main.cancel"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.tostView.frame.size.width-204)/2+102*i, self.tostView.frame.size.height-44,102,44)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if (i == 0) {
                _pinbBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
            }else{
                _cancelBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
            }
            [btn setTitle:chnArr[i] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(sureOrCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tostView addSubview:btn];
        }
        
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0, _pinbBtn.frame.origin.y, self.tostView.frame.size.width, 1)];
        hline.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.tostView addSubview:hline];
        
        UIView *sline = [[UIView alloc] initWithFrame:CGRectMake(self.tostView.frame.size.width/2-0.5, _pinbBtn.frame.origin.y, 1, 44)];
        sline.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.tostView addSubview:sline];
    }
    return self;
}

- (instancetype)initWithGroupName1:(NSString *)name name2:(NSString *)name2{
    if (self = [super init]) {
        self.choiceName1 = name;
        self.choiceName2 = name2;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.type = 0;
        
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 247)];
        self.tostView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self.markView removeFromSuperview];
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,10, self.tostView.frame.size.width,39)];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"已订阅2个社团，选择1个进行替代：";
        [self.tostView addSubview:label];
        
        _buttonArr = [NSMutableArray new];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+25+55*i, self.tostView.frame.size.width-60, 40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [btn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
            [btn setTitle:i==0?name:name2 forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(choiceGroupClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [self.tostView addSubview:btn];
            [_buttonArr addObject:btn];
        }
        

        NSArray *chnArr = @[[NoticeTools getLocalStrWith:@"main.cancel"],[NoticeTools getLocalStrWith:@"main.sure"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.tostView.frame.size.width-204)/2+102*i, self.tostView.frame.size.height-50,102,50)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if (i == 0) {
                _cancelBtn = btn;
                btn.tag = 1;
                [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
            }else{
                btn.tag = 0;
                _pinbBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
            }
            [btn setTitle:chnArr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(surethOrCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tostView addSubview:btn];
        }
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.tostView.frame.size.height-50, self.tostView.frame.size.width, 1)];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.tostView addSubview:lineV];
        
        UIView *lineh = [[UIView alloc] initWithFrame:CGRectMake((self.tostView.frame.size.width-1)/2, CGRectGetMaxY(lineV.frame), 1, self.tostView.frame.size.height-CGRectGetMaxY(lineV.frame))];
        lineh.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.tostView addSubview:lineh];
    }
    return self;
}

- (instancetype)initWithTostViewString:(NSString *)str{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.tostView removeFromSuperview];
        if (!str.length || !str) {
            str = @"";
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        
        CGFloat contentHeight = GET_STRHEIGHT(str, 12,self.markView.frame.size.width-60);
        
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270,contentHeight+4+20+12+14+20+40)];
        self.markView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FCFCFC":@"#181828"];
        self.markView.layer.cornerRadius = 10;
        self.markView.layer.masksToBounds = YES;
        self.markView.center = self.center;
        [self.tostView removeFromSuperview];
        [self addSubview:self.markView];
        
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(0,20, self.markView.frame.size.width,0)];
        titL.textColor = GetColorWithName(VMainTextColor);
        titL.font = TWOTEXTFONTSIZE;
        titL.textAlignment = NSTextAlignmentCenter;
        //titL.text = str;
        [self.markView addSubview:titL];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(titL.frame)+14,self.markView.frame.size.width-60,contentHeight+8)];
        contentL.textColor = GetColorWithName(VMainTextColor);
        contentL.font = TWOTEXTFONTSIZE;
        contentL.numberOfLines = 0;
        contentL.attributedText = attributedString;
        contentL.textAlignment = NSTextAlignmentCenter;
        [self.markView addSubview:contentL];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.markView.frame.size.height-40, self.markView.frame.size.width, 40)];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn setTitle:[NoticeTools getLocalStrWith:@"chat.close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"];
        [btn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#FCFCFC"] forState:UIControlStateNormal];
        [self.markView addSubview:btn];
    }
    return self;
}

- (instancetype)initWithTostViewType:(NSInteger)type{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.tostView removeFromSuperview];
        
        NSArray *arrCHN = @[[NoticeTools getLocalStrWith:@"jubao.more"],[NoticeTools getLocalStrWith:@"jubao.k"],[NoticeTools getLocalStrWith:@"jubao.other"],[NoticeTools getLocalStrWith:@"jubao.result"]];

        NSArray *TitleCHN = @[[NoticeTools getLocalStrWith:@"pingbi.result"],[NoticeTools getLocalStrWith:@"pingbi.thank"],[NoticeTools getLocalStrWith:@"pingbi.thank1"],[NoticeTools getLocalStrWith:@"pingbi.jubao"]];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:arrCHN[type-1]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [arrCHN[type-1] length])];
        
         CGFloat contentHeight = GET_STRHEIGHT(arrCHN[type-1], 12,self.markView.frame.size.width-60);
        
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270,contentHeight+4+20+12+14+20+40)];
        self.markView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.markView.layer.cornerRadius = 10;
        self.markView.layer.masksToBounds = YES;
        self.markView.center = self.center;
        [self.tostView removeFromSuperview];
        [self addSubview:self.markView];
        
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(0,20, self.markView.frame.size.width, 12)];
        titL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titL.font = TWOTEXTFONTSIZE;
        titL.textAlignment = NSTextAlignmentCenter;
        titL.text =type==4?[NoticeTools getLocalStrWith:@"pingbi.jubao"]: TitleCHN[type-1];
        [self.markView addSubview:titL];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(titL.frame)+14,self.markView.frame.size.width-60,contentHeight+8)];
        contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        contentL.font = TWOTEXTFONTSIZE;
        contentL.numberOfLines = 0;
        contentL.attributedText = attributedString;
        contentL.textAlignment = NSTextAlignmentCenter;
        [self.markView addSubview:contentL];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.markView.frame.size.height-40, self.markView.frame.size.width, 40)];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn setTitle:[NoticeTools getLocalStrWith:@"chat.close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.markView addSubview:btn];
    }
    return self;
}

- (instancetype)initWithWarnTostViewContent:(NSString *)content{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.tostView removeFromSuperview];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        CGFloat contentHeight = GET_STRHEIGHT(content, 12,270-60)+40;
        
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270,contentHeight+90)];
        self.markView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.markView.layer.cornerRadius = 10;
        self.markView.layer.masksToBounds = YES;
        self.markView.center = self.center;
        [self.tostView removeFromSuperview];
        [self addSubview:self.markView];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(30,30,self.markView.frame.size.width-60,contentHeight)];
        contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        contentL.font = TWOTEXTFONTSIZE;
        contentL.numberOfLines = 0;
        contentL.attributedText = attributedString;
        contentL.textAlignment = NSTextAlignmentCenter;
        [self.markView addSubview:contentL];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.markView.frame.size.height-40, self.markView.frame.size.width, 40)];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn setTitle:@"OK" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"];
        [btn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#FCFCFC"] forState:UIControlStateNormal];
        [self.markView addSubview:btn];
    }
    return self;
}

- (instancetype)initWithTostWithImage:(NSString *)imageName titleName:(NSString *)titleName content1:(NSString *)content1 content2:(NSString *)content buttonName1:(NSString *)name1 buttonName2:(NSString *)name2 actionId:(NSString *)actionId type:(NSInteger)type{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.tostView removeFromSuperview];
        
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275,376+59-15-(titleName.length?0:53))];
        self.markView.backgroundColor = GetColorWithName(VBackColor);
        self.markView.layer.cornerRadius = 10;
        self.markView.layer.masksToBounds = YES;
        self.markView.center = self.center;
        [self addSubview:self.markView];
     
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.markView.frame.size.width, titleName.length?23:0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = TWOThretyTEXTFONTSIZE;
        label.textColor = GetColorWithName(VMainTextColor);
        label.text = titleName;
        [self.markView addSubview:label];
        
        UIImageView *titImageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.markView.frame.size.width-134)/2,titleName.length? CGRectGetMaxY(label.frame)+30:30, 134, 134)];
        titImageV.image = UIImageNamed(imageName);
        [self.markView addSubview:titImageV];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+CGRectGetMaxY(titImageV.frame), self.markView.frame.size.width, 15)];
        contentL.textAlignment = NSTextAlignmentCenter;
        contentL.font = FIFTHTEENTEXTFONTSIZE;
        contentL.textColor = GetColorWithName(VMainTextColor);
        contentL.text = content1;
        [self.markView addSubview:contentL];
        
        UILabel *contentL2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+CGRectGetMaxY(contentL.frame), self.markView.frame.size.width, 13)];
        contentL2.textAlignment = NSTextAlignmentCenter;
        contentL2.font = THRETEENTEXTFONTSIZE;
        contentL2.textColor = GetColorWithName(VMainTextColor);
        contentL2.text = content;
        [self.markView addSubview:contentL2];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(contentL2.frame)+30, 115, 38)];
        button1.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"];
        button1.layer.cornerRadius = 19;
        button1.layer.masksToBounds = YES;
        [button1 setTitle:name1 forState:UIControlStateNormal];
        [button1 setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.markView addSubview:button1];
        [button1 addTarget:self action:@selector(imgtostClick1) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.origin.x,CGRectGetMaxY(button1.frame),115, 44)];
        [button2 setTitle:name2 forState:UIControlStateNormal];
        [button2 setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        button2.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.markView addSubview:button2];
        [button2 addTarget:self action:@selector(imgtostClick2) forControlEvents:UIControlEventTouchUpInside];
        self.actionId = actionId;
        self.imageTostType = type;
    }
    return self;
}

- (instancetype)initWithServer:(NSInteger)type{
    if (self = [super init]) {
        self.imageTostType = type;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.tostView removeFromSuperview];
        
        self.markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 275,345)];
        self.markView.center = self.center;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 275, 345)];
        imageView.image = UIImageNamed(@"Image_sever");
        [self.markView addSubview:imageView];
        [self addSubview:self.markView];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(80,249, 115, 38)];
        button1.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"];
        button1.layer.cornerRadius = 19;
        button1.layer.masksToBounds = YES;
        [button1 setTitle:@"我要流畅" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#FCFCFC"] forState:UIControlStateNormal];
        button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.markView addSubview:button1];
        [button1 addTarget:self action:@selector(imgtostClick1) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.origin.x,CGRectGetMaxY(button1.frame)+5,115, 44)];
        [button2 setTitle:@"暂时不用啦" forState:UIControlStateNormal];
        [button2 setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        button2.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.markView addSubview:button2];
        [button2 addTarget:self action:@selector(imgtostClick2) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithStopServer:(NSInteger)type dayNum:(NSInteger)dayNum{
    if (self = [super init]) {
        self.imageTostType = type;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.tostView removeFromSuperview];
        
        //stopserv_img
        
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275,397+(type==7?44:0))];
        self.markView.backgroundColor = GetColorWithName(VBackColor);
        self.markView.layer.cornerRadius = 10;
        self.markView.layer.masksToBounds = YES;
        self.markView.center = self.center;
        [self addSubview:self.markView];

        
        UIImageView *titImageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.markView.frame.size.width-134)/2,30, 134, 134)];
        titImageV.image = UIImageNamed(type == 6? @"stopserv_img":@"stopserv_img_yl");
        [self.markView addSubview:titImageV];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(48, 30+CGRectGetMaxY(titImageV.frame), self.markView.frame.size.width-96, 105)];
        contentL.textAlignment = NSTextAlignmentCenter;
        contentL.font = FIFTHTEENTEXTFONTSIZE;
        contentL.textColor = GetColorWithName(VMainTextColor);
        NSString *str = type == 7?[NSString stringWithFormat:@"当前版本太古老啦，会在%ld天后停止维护，为了避免数据丢失，请尽快更新一下吧",(long)dayNum] : @"当前版本由于历史过于悠久已停止维护，请小主更新至最新版本，有更多的惊喜等你发现哦~";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        contentL.attributedText = attributedString;
        contentL.numberOfLines = 0;
        [self.markView addSubview:contentL];

        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(contentL.frame)+30, 115, 38)];
        button1.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"];
        button1.layer.cornerRadius = 19;
        button1.layer.masksToBounds = YES;
        [button1 setTitle:type == 6? @"去瞧瞧":@"替朕引路" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#FCFCFC"] forState:UIControlStateNormal];
        button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.markView addSubview:button1];
        [button1 addTarget:self action:@selector(imgtostClick1) forControlEvents:UIControlEventTouchUpInside];
        
        if (type == 7) {
            UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.origin.x,CGRectGetMaxY(button1.frame)+5,115, 44)];
            [button2 setTitle:@"还能坚持" forState:UIControlStateNormal];
            [button2 setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
            button2.titleLabel.font = THRETEENTEXTFONTSIZE;
            [self.markView addSubview:button2];
            [button2 addTarget:self action:@selector(imgtostClick2) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    return self;
}

- (void)imgtostClick2{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.imageTostType == 1) {
        [UIView animateWithDuration:1 animations:^{
            [nav.topViewController showToastWithText:@"心情已发布~"];
        } completion:^(BOOL finished) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEROOTSELECT" object:nil];
            [nav.topViewController.navigationController popViewControllerAnimated:YES];
        }];
    }
    [self removeFromSuperview];
}

- (void)imgtostClick1{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (self.imageTostType == 1) {
        [nav.topViewController showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/share",[[NoticeSaveModel getUserInfo] user_id],self.actionId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [UIView animateWithDuration:1 animations:^{
                    [nav.topViewController showToastWithText:@"共享成功，快去操场看看吧"];
                } completion:^(BOOL finished) {
                    [nav.topViewController.navigationController popViewControllerAnimated:YES];
                }];
                
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }else if (self.imageTostType == 2){
        NoticeSendViewController *send = [[NoticeSendViewController alloc] init];
        send.isFromAddFriend = YES;
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                        withSubType:kCATransitionFromTop
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionDefault
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:send animated:NO];
    }else if (self.imageTostType == 3){
        NoticeChangeServerAreaController *ctl = [[NoticeChangeServerAreaController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (self.imageTostType == 6 || self.imageTostType == 7){//强制更新
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
        if (self.imageTostType == 6) {
            return;
        }
    }
    
    [self removeFromSuperview];
}

- (void)choiceTypeClick:(UIButton *)btn{
    self.type = btn.tag;
    btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    for (UIButton *button in _buttonArr) {
        if (button.tag != self.type) {
            [button setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        }
    }
}

- (instancetype)initWithJuBaoCallView{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.type = 0;
        
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 322)];
        self.tostView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self.markView removeFromSuperview];
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.tostView.frame.size.width, 14)];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请选择一项举报理由";
        [self.tostView addSubview:label];
                
        NSArray *arrCHN = @[[NoticeTools getLocalStrWith:@"jubao.reason2"],[NoticeTools getLocalStrWith:@"jubao.reason3"]];
        _buttonArr = [NSMutableArray new];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+40+55*i, self.tostView.frame.size.width-60, 40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [btn setTitle:arrCHN[i] forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(jubaoTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [self.tostView addSubview:btn];
            [_buttonArr addObject:btn];
        }
        
        NSArray *chnArr = @[[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"],[NoticeTools getLocalStrWith:@"main.cancel"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.tostView.frame.size.width-204)/2+102*i, self.tostView.frame.size.height-10-40,102,40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if (i == 0) {
                _pinbBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
            }else{
                _cancelBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
            }
            [btn setTitle:chnArr[i] forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(sureOrCancelJuBaoClick1:) forControlEvents:UIControlEventTouchUpInside];
            [self.tostView addSubview:btn];
        }
        
        _choiceImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+40+55*2+18, 22, 22)];
        _choiceImg.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendvoiceself_b":@"Image_sendvoiceself_y");
        [self.tostView addSubview:_choiceImg];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_choiceImg.frame)+5,_choiceImg.frame.origin.y,160,22)];
        label1.textColor = GetColorWithName(VDarkTextColor);
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.text = @"我知道瞎举报会被封号";
        [self.tostView addSubview:label1];
        
        UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _choiceImg.frame.origin.y, self.tostView.frame.size.width, 22)];
        selBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.tostView addSubview:selBtn];
        [selBtn addTarget:self action:@selector(sureKnowClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithJuBaoCardCallView{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.type = 0;
        
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 322)];
        self.tostView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FCFCFC":@"#181828"];
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        self.tostView.center = self.center;
        [self.markView removeFromSuperview];
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.tostView.frame.size.width, 14)];
        label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#666666":@"#72727F"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请选择一项举报理由";
        [self.tostView addSubview:label];
                
        NSArray *arrCHN = @[[NoticeTools getLocalStrWith:@"jubao.reason2"],[NoticeTools getLocalStrWith:@"jubao.reason3"]];
        _buttonArr = [NSMutableArray new];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+40+55*i, self.tostView.frame.size.width-60, 40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [btn setTitleColor:[NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#666666"]:[UIColor colorWithHexString:@"#3E3E4A"] forState:UIControlStateNormal];
            [btn setTitle:arrCHN[i] forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(jubaoTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F4F4F4":@"#12121F"];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [self.tostView addSubview:btn];
            [_buttonArr addObject:btn];
        }
        
        NSArray *chnArr = @[@"举报并挂断",[NoticeTools getLocalStrWith:@"main.cancel"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.tostView.frame.size.width-204)/2+102*i, self.tostView.frame.size.height-10-40,102,40)];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if (i == 0) {
                _pinbBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
            }else{
                _cancelBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#666666":@"#72727F"] forState:UIControlStateNormal];
            }
            [btn setTitle:chnArr[i] forState:UIControlStateNormal];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(sureOrCancelJuBaoClick1:) forControlEvents:UIControlEventTouchUpInside];
            [self.tostView addSubview:btn];
        }
        
        _choiceImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+40+55*2+18, 22, 22)];
        _choiceImg.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendvoiceself_b":@"Image_sendvoiceself_y");
        [self.tostView addSubview:_choiceImg];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_choiceImg.frame)+5,_choiceImg.frame.origin.y,160,22)];
        label1.textColor = GetColorWithName(VDarkTextColor);
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.text = @"我知道瞎举报会被封号";
        [self.tostView addSubview:label1];
        
        UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _choiceImg.frame.origin.y, self.tostView.frame.size.width, 22)];
        selBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.tostView addSubview:selBtn];
        [selBtn addTarget:self action:@selector(sureKnowClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)sureKnowClick{
    _know = !_know;
    if (self.type && _know) {
        [_pinbBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"] forState:UIControlStateNormal];
    }else{
        [_pinbBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
    }
    if (_know) {
        _choiceImg.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendvoiceself_bs":@"Image_sendvoiceself_ys");
    }else{
        _choiceImg.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendvoiceself_b":@"Image_sendvoiceself_y");
    }
}

- (void)jubaoTypeClick:(UIButton *)btn{
    self.type = btn.tag;
    btn.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    for (UIButton *button in _buttonArr) {
        if (button.tag != self.type) {
            [button setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        }
    }
    if (self.type && _know) {
        [_pinbBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
    }else{
        [_pinbBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
    }
}

- (void)sureOrCancelJuBaoClick1:(UIButton *)btn{

    if (btn.tag == 1) {
        if (!_know) {
            return;
        }
        if (self.sureBlock) {
            self.sureBlock(self.type);
        }
    }
    [self removeFromSuperview];
}

- (void)choiceGroupClick:(UIButton *)btn{
    self.type = btn.tag;
    
    btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    for (UIButton *button in _buttonArr) {
        if (button.tag != self.type) {
            [button setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        }
    }
    [_pinbBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
}

- (void)surethOrCancelClick:(UIButton *)btn{
    if (btn.tag == 0) {
        if (!self.type) {
            return;
        }
        if (self.choiceBlock) {
            self.choiceBlock(self.type==1?self.choiceName1:self.choiceName2);
        }
    }
    [self removeFromSuperview];
}

//屏蔽或者取消
- (void)sureOrCancelClick:(UIButton *)btn{
    if (btn.tag == 1) {
        
    }else{
        if (!self.type) {
            return;
        }
        if (self.ChoiceType) {
            self.ChoiceType(self.type);
        }
    }
    [self removeFromSuperview];
}
- (void)sureOrCancelClick1:(UIButton *)btn{
    if (btn.tag == 1) {
        
    }else{
        if (!self.type) {
            return;
        }
        if (self.deleteBlock) {
            self.deleteBlock(self.type);
        }
    }
    [self removeFromSuperview];
}
- (void)closeClick{
    if (self.ChoiceType) {
        self.ChoiceType(5);
    }
    [self removeFromSuperview];
}

- (void)showPinbView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)showTostView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimations];
}

- (void)creatShowAnimation
{
    self.tostView.layer.position = self.center;
    self.tostView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tostView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)creatShowAnimations
{
    self.markView.layer.position = self.center;
    self.markView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.markView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
