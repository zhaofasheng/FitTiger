//
//  NoticeSearFootMovie.m
//  NoticeXi
//
//  Created by li lei on 2019/7/25.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearFootMovie.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeHandAddMovieController.h"
#import "NoticeHandAddBookController.h"
#import "NoticeHandAddSongController.h"
@implementation NoticeSearFootMovie
{
    UIButton *_actionButton;
    UILabel *label;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, DR_SCREEN_WIDTH, 13)];
        label.font = THRETEENTEXTFONTSIZE;
        label.textColor = GetColorWithName(VDarkTextColor);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.nosearch"]:@"沒有找到这部電影？";
        [self addSubview:label];
        
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-240)/2, CGRectGetMaxY(label.frame)+20,240, 56)];
        _actionButton.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        _actionButton.layer.cornerRadius = 56/2;
        _actionButton.layer.masksToBounds = YES;
        [_actionButton setBackgroundImage:UIImageNamed(@"img_buttonback") forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _actionButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [_actionButton setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.shoudongadd"]:@"手動添加電影詞條" forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionButton];
    }
    return self;
}

- (void)setType:(NSInteger)type{
    _type = type;
    if (type == 1) {
        label.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.nosearchbook"]:@"沒有找到這本書？";
        [_actionButton setTitle:[NoticeTools getLocalStrWith:@"movie.shoudongaddbook"] forState:UIControlStateNormal];
    }else if (type == 2){
        label.text = [NoticeTools getLocalStrWith:@"movie.nosearchsong"];
        [_actionButton setTitle:[NoticeTools getLocalStrWith:@"movie.shoudongaddsong"] forState:UIControlStateNormal];
    }
}

- (void)addClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (_type == 1) {
        NoticeHandAddBookController *ctl = [[NoticeHandAddBookController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        return;
    }
    if (_type == 2) {
        NoticeHandAddSongController *ctl = [[NoticeHandAddSongController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        return;
    }
    NoticeHandAddMovieController *ctl = [[NoticeHandAddMovieController alloc] init];
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}
@end
