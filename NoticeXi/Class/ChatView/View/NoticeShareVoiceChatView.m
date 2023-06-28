//
//  NoticeShareVoiceChatView.m
//  NoticeXi
//
//  Created by li lei on 2022/5/27.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareVoiceChatView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeVoiceDetailController.h"
@implementation NoticeShareVoiceChatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 224, 98)];
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
        
        self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 204, 48)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.layer.cornerRadius = 6;
        self.whiteView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.whiteView];
        
        self.voiceView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 120, 32)];
        self.voiceView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.voiceView.layer.cornerRadius = 16;
        self.voiceView.layer.masksToBounds = YES;
        [self.whiteView addSubview:self.voiceView];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(3, 4, 24, 24)];
        imageV.image = UIImageNamed(@"Image_newplay");
        [self.voiceView addSubview:imageV];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(120-3-90, 0, 90, 32)];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.voiceView addSubview:self.timeL];
        self.timeL.textAlignment = NSTextAlignmentRight;
        
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 48, 60, 60)];
        [self.whiteView addSubview:self.imageView1];
        self.imageView1.layer.cornerRadius = 4;
        self.imageView1.layer.masksToBounds = YES;
        
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 48, 60, 60)];
        [self.whiteView addSubview:self.imageView2];
        self.imageView2.layer.cornerRadius = 4;
        self.imageView2.layer.masksToBounds = YES;
        
        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 48, 60, 60)];
        [self.whiteView addSubview:self.imageView3];
        self.imageView3.layer.cornerRadius = 4;
        self.imageView3.layer.masksToBounds = YES;
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 204, 48)];
        self.statusL.numberOfLines = 2;
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.statusL.font = TWOTEXTFONTSIZE;
        self.statusL.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:self.statusL];
        
        self.userInteractionEnabled = YES;
        self.contentView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVoice)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapVoice{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (self.chat.shareVoiceM.show_status.intValue > 1) {
        [nav.topViewController showToastWithText:self.chat.shareVoiceM.show_status.intValue==2?[NoticeTools getLocalStrWith:@"chat.nolooknow"]:[NoticeTools getLocalStrWith:@"chat.noconnow"] ];
        return;
    }
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.chat.shareVoiceM.voiceM.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.content_type.intValue == 2 && model.title) {
                model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
            }
            if (model.content_type.intValue == 2) {
                NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
                ctl.voiceM = model;
                [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            }else{
                NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
                ctl.voiceM = model;
                [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            }
            
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];

}

- (void)setChat:(NoticeChats *)chat{
    _chat = chat;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.userM.avatar_url]];
    if ([NoticeTools getLocalType]) {
        self.nameL.text =[NSString stringWithFormat:@"%@ %@",chat.shareVoiceM.userM.nick_name,[NoticeTools getLocalStrWith:@"yl.xinqing"]];
    }else{
        self.nameL.text =[NSString stringWithFormat:@"%@ 的心情",chat.shareVoiceM.userM.nick_name];
    }
    
    self.timeL.text = [NSString stringWithFormat:@"%@s",chat.shareVoiceM.voiceM.voice_len];
    
    self.imageView1.hidden = YES;
    self.imageView2.hidden = YES;
    self.imageView3.hidden = YES;
    self.voiceView.hidden = NO;
    if (self.chat.shareVoiceM.show_status.intValue > 1) {
        self.contentView.frame = CGRectMake(self.chat.isSelf?self.frame.size.width-224:0, 0, 224, 98);
        self.whiteView.frame = CGRectMake(10, 40, 204, 48);
        self.statusL.text = chat.shareVoiceM.show_status.intValue==2?[NoticeTools getLocalStrWith:@"chat.nolooknow"]:[NoticeTools getLocalStrWith:@"chat.noconnow"];
        self.statusL.hidden = NO;
        self.voiceView.hidden = YES;
    }else{
        self.statusL.hidden = YES;
        if (self.chat.shareVoiceM.voiceM.img_list.count == 3) {
            self.contentView.frame = CGRectMake(self.chat.isSelf?self.frame.size.width-224:0, 0,224, 166);
            self.whiteView.frame = CGRectMake(10, 40, 204, 116);
            self.imageView1.hidden = NO;
            self.imageView2.hidden = NO;
            self.imageView3.hidden = NO;
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.voiceM.img_list[0]]];
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.voiceM.img_list[1]]];
            [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.voiceM.img_list[2]]];
            
            self.imageView1.frame = CGRectMake(8, 48, 60, 60);
            self.imageView2.frame = CGRectMake(72, 48, 60, 60);
            self.imageView3.frame = CGRectMake(136, 48, 60, 60);
            
        }else if (self.chat.shareVoiceM.voiceM.img_list.count == 2){
            self.contentView.frame = CGRectMake(self.chat.isSelf?self.frame.size.width-224:0,0, 224, 186);
            self.whiteView.frame = CGRectMake(10, 40, 204, 136);
            self.imageView1.hidden = NO;
            self.imageView2.hidden = NO;
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.voiceM.img_list[0]]];
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.voiceM.img_list[1]]];
            
            self.imageView1.frame = CGRectMake(8, 48, 80, 80);
            self.imageView2.frame = CGRectMake(92, 48, 80, 80);
        }else if (self.chat.shareVoiceM.voiceM.img_list.count == 1){
            self.contentView.frame = CGRectMake(self.chat.isSelf?self.frame.size.width-224:0, 0, 224, 226);
            self.whiteView.frame = CGRectMake(10, 40, 204, 176);
            self.imageView1.hidden = NO;
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:chat.shareVoiceM.voiceM.img_list[0]]];
            self.imageView1.frame = CGRectMake(8, 48, 120, 120);
        }else{
            self.contentView.frame = CGRectMake(self.chat.isSelf?self.frame.size.width-224:0, 0, 224, 98);
            self.whiteView.frame = CGRectMake(10, 40, 204, 48);
        }
    }
}

@end
