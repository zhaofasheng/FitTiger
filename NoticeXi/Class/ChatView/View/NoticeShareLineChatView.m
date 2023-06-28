//
//  NoticeShareLineChatView.m
//  NoticeXi
//
//  Created by li lei on 2022/5/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareLineChatView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeTcPageController.h"
@implementation NoticeShareLineChatView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 224, 117)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+2, 10, 224-20-14, 20)];
        self.nameL.font = TWOTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.nameL];
        
        self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 204, 67)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.layer.cornerRadius = 6;
        self.whiteView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.whiteView];
        
 
        self.tcL = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 204-16, 57)];
        self.tcL.font = [UIFont systemFontOfSize:12];
        self.tcL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.whiteView addSubview:self.tcL];
        self.tcL.numberOfLines = 0;
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 204, 67)];
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.statusL.font = TWOTEXTFONTSIZE;
        self.statusL.numberOfLines = 2;
        self.statusL.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:self.statusL];
        
        self.userInteractionEnabled = YES;
        self.contentView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVoice)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setChat:(NoticeChats *)chat{
    _chat = chat;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:chat.share_lineM.userM.avatar_url]];
    if ([NoticeTools getLocalType]) {
        self.nameL.text =[NSString stringWithFormat:@"%@ %@",chat.share_lineM.userM.nick_name,[NoticeTools getLocalStrWith:@"py.tc"]];
    }else{
        self.nameL.text =[NSString stringWithFormat:@"%@ 的台词",chat.share_lineM.userM.nick_name];
    }
    
    self.contentView.frame = CGRectMake(self.chat.isSelf?self.frame.size.width-224:0, 0, 224, 117);
    self.tcL.text = [NSString stringWithFormat:@"#%@#%@",chat.share_lineM.lineM.tag_id.intValue==1?@"求配音":@"freestyle",chat.share_lineM.lineM.line_content];

    if (self.chat.share_lineM.show_status.intValue > 1) {
        self.statusL.text = chat.share_lineM.show_status.intValue==2?[NoticeTools getLocalStrWith:@"chat.nolooknow"]:[NoticeTools getLocalStrWith:@"chat.noconnow"];
        self.statusL.hidden = NO;
        self.tcL.hidden = YES;
    }else{
        self.tcL.hidden = NO;
        self.statusL.hidden = YES;
    }
    
}

- (void)tapVoice{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.chat.share_lineM.show_status.intValue > 1) {
        [nav.topViewController showToastWithText:self.chat.share_lineM.show_status.intValue==2?[NoticeTools getLocalStrWith:@"chat.nolooknow"]:[NoticeTools getLocalStrWith:@"chat.noconnow"] ];
        return;
    }
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    
    NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
    ctl.tcId = self.chat.share_lineM.lineM.tcId;
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];

}


@end
