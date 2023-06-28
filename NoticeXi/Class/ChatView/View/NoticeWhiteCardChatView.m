//
//  NoticeWhiteCardChatView.m
//  NoticeXi
//
//  Created by li lei on 2022/5/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteCardChatView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeWhiteVoiceController.h"
@implementation NoticeWhiteCardChatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        self.backgroundColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
                
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,160,210)];
        [self addSubview:self.cardImageView];
        self.cardImageView.layer.cornerRadius = 8;
        self.cardImageView.layer.masksToBounds = YES;
        self.cardImageView.userInteractionEnabled = YES;
        
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(0,27, 160, 16)];
        self.numL.textAlignment = NSTextAlignmentCenter;
        self.numL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.numL.font = TWOTEXTFONTSIZE;
        [self.cardImageView addSubview:self.numL];
    
        
        self.getLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numL.frame)+100, 160, 16)];
        self.getLabel.textAlignment = NSTextAlignmentCenter;
        self.getLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.getLabel.font = TWOTEXTFONTSIZE;
        [self.cardImageView addSubview:self.getLabel];
        
        self.fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 210)];
        self.fgView.backgroundColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:0.5];
        [self.cardImageView addSubview:self.fgView];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cardImageView.frame) , frame.size.width, 40)];
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        self.markL.font = TWOTEXTFONTSIZE;
        [self addSubview:self.markL];
        
        self.cardImageView.userInteractionEnabled = YES;
        self.markL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCardTap)];
        [self.cardImageView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCardTap)];
        [self.markL addGestureRecognizer:tap2];
    }
    return self;
}

- (void)getCardTap{
    if (!_chat.isSelf) {
        if (self.chat.whiteModel.receive_status.intValue == 1) {
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"recieveChatCard/%@",self.chat.dialog_id] Accept:@"application/vnd.shengxi.v5.3.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                
            } fail:^(NSError * _Nullable error) {
                
            }];
            return;
        }
    }
    
    if (self.chat.whiteModel.receive_status.intValue == 3) {
        return;
    }
    
    if (self.chat.whiteModel.receive_status.intValue == 2 || self.chat.whiteModel.receive_status.intValue == 1) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];

        
        NoticeWhiteVoiceController *ctl = [[NoticeWhiteVoiceController alloc] init];
        ctl.dialogId = self.chat.dialog_id;
        if (self.chat.isSelf) {
            ctl.isHasSend = YES;
        }else{
            ctl.isHsGet = YES;
        }
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }

}

- (void)setChat:(NoticeChats *)chat{
    _chat = chat;
    
    if (chat.isSelf) {//自己发送的
        self.cardImageView.frame = CGRectMake(self.frame.size.width-160, 0, 160, 210);
        self.getLabel.hidden = YES;
        self.fgView.hidden = YES;
        if (chat.whiteModel.receive_status.intValue == 2) {
            self.markL.hidden = NO;
            self.markL.text = [NoticeTools getLocalStrWith:@"chat.getyourwhitek"];//对方领取了
        }else if(chat.whiteModel.receive_status.intValue == 1){
            self.markL.hidden = YES;
        }else if(chat.whiteModel.receive_status.intValue == 3){
            self.markL.hidden = NO;
            self.markL.text = [NoticeTools getLocalStrWith:@"chat.cardback"];//对方7天没领取
        }
    }else{//对方发送的
        self.cardImageView.frame = CGRectMake(0, 0, 160, 210);
        self.getLabel.hidden = NO;
        if (chat.whiteModel.receive_status.intValue == 1) {
            self.getLabel.text = [NoticeTools getLocalStrWith:@"chat.clickget"];//点击领取
            self.fgView.hidden = YES;
            self.markL.hidden = YES;
        }else if (chat.whiteModel.receive_status.intValue == 2){
            self.getLabel.text = [NoticeTools getLocalStrWith:@"chat.hasgetcard"];
            self.fgView.hidden = NO;
            self.markL.hidden = NO;
            NSString *str1 = [NoticeTools getLocalStrWith:@"chat.yougethiscard"];//你领取了对方的白噪声卡
            NSString *str2 = [NoticeTools getLocalStrWith:@"chat.golookcard"];
            self.markL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ %@",str1,str2] setColor:[UIColor whiteColor] setLengthString:str2 beginSize:str1.length+1];
        }else{
            self.markL.hidden = YES;
            self.fgView.hidden = NO;
            self.getLabel.text = [NoticeTools getLocalStrWith:@"chat.hasdiss"];
        }
    }
    if ([NoticeTools getLocalType] == 1) {
        self.numL.text = [NSString stringWithFormat:@"gifted you %@ sound card（s)",chat.whiteModel.card_num];
    }else if ([NoticeTools getLocalType] == 2){
        self.numL.text = [NSString stringWithFormat:@"%@ホワイトノイズカードを送ってください",chat.whiteModel.card_num];
    }else{
        self.numL.text = [NSString stringWithFormat:@"送你%@张白噪声卡",chat.whiteModel.card_num];
    }
    
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:chat.whiteModel.first_card_url] placeholderImage:GETUIImageNamed(@"img_empty")];
}

@end
