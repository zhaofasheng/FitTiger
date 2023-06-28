//
//  NoticememoryFootView.m
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticememoryFootView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSendViewController.h"
@implementation NoticememoryFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = GetColorWithName(VBackColor);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35,23, DR_SCREEN_WIDTH-70, GET_STRHEIGHT(GETTEXTWITE(@"jy.knowm"), 13, frame.size.height))];
        label.textColor = GetColorWithName(VDarkTextColor);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = THRETEENTEXTFONTSIZE;
        label.text = GETTEXTWITE(@"jy.knowm");
        _titleL = label;
        label.numberOfLines = 0;
        [self addSubview:label];
        
//        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, CGRectGetMaxY(label.frame)+30, 160, 45)];
//        _actionButton.backgroundColor = GetColorWithName(VMainThumeColor);
//        _actionButton.layer.cornerRadius = 45/2;
//        _actionButton.layer.masksToBounds = YES;
//        _actionButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
//        [_actionButton setTitle:@"+ 室友" forState:UIControlStateNormal];
//        [_actionButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
//        [_actionButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_actionButton];
    }
    return self;
}

- (void)refreshFrame{
    self.titleL.frame = CGRectMake(0, 15, DR_SCREEN_WIDTH, 17);
    _actionButton.frame = CGRectMake((DR_SCREEN_WIDTH-200)/2, CGRectGetMaxY(self.titleL.frame)+15, 200, 45);
}

- (void)setRealisAbout:(NoticeAbout *)realisAbout{
    _realisAbout = realisAbout;
    if (!realisAbout.whitelist) {
        if ([_realisAbout.strange_view isEqualToString:@"7"]) {//非好友7日可见
            _titleL.text = _isPhoto? [NoticeTools getTextWithSim:@"ta设置了非学友只能浏览最近七天的相册" fantText:@"ta設置了非学友只能瀏覽最近七天的相冊"] : [NoticeTools getTextWithSim:@"ta设置了非学友只能浏览最近七天的记忆" fantText:@"ta設置了非好友只能瀏覽最近七天的記憶"];
        }else if ([_realisAbout.strange_view isEqualToString:@"30"]){
            _titleL.text = _isPhoto? [NoticeTools getTextWithSim:@"ta设置了非学友只能浏览最近三十天的相册" fantText:@"ta設置了非学友只能瀏覽最近三十天的相冊"] : [NoticeTools getTextWithSim:@"ta设置了非学友只能浏览最近三十天的记忆" fantText:@"ta設置了非学友只能瀏覽最近三十天的記憶"];
        }
    }
    
    if ([realisAbout.friend_status isEqualToString:@"1"]) {
        _actionButton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#222238"];
        [_actionButton setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3E3E4A"] forState:UIControlStateNormal];
        [_actionButton setTitle:@"等待验证" forState:UIControlStateNormal];
    }
}

- (void)addClick{
    if (!self.userId || [_realisAbout.friend_status isEqualToString:@"1"]) {
        return;
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.userId forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/friendslog",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
       
        if (success) {
            self->_realisAbout.friend_status = @"1";
            self->_actionButton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#222238"];
            [self->_actionButton setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3E3E4A"] forState:UIControlStateNormal];
            [self->_actionButton setTitle:@"等待验证" forState:UIControlStateNormal];
            [NoticeAddFriendTools addFriendWithUserId:self.userId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addFriendNotice" object:nil];
        }
    } fail:^(NSError *error) {
    
    }];
}
@end
