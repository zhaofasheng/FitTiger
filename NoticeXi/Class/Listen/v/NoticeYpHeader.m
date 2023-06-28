//
//  NoticeYpHeader.m
//  NoticeXi
//
//  Created by li lei on 2018/11/11.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeYpHeader.h"
#import "NoticeRat.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeYpHeader
{
    NSMutableArray *_nameLarr;
    NSMutableArray *_numLArr;
    NSMutableArray *_iconArr;
    
    NSMutableArray *_snameLarr;
    NSMutableArray *_snumLArr;
    NSMutableArray *_siconArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#46CDCF"];
        
        _nameLarr = [NSMutableArray new];
        _numLArr = [NSMutableArray new];
        _iconArr = [NSMutableArray new];
        _snameLarr = [NSMutableArray new];
        _snumLArr = [NSMutableArray new];
        _siconArr = [NSMutableArray new];
        NSArray *arr = @[@"2",@"1",@"3"];
        for (int i = 0; i < 3; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(6+(DR_SCREEN_WIDTH-12)/3*i, i == 1 ? 23 : 56, (DR_SCREEN_WIDTH-12)/3, i == 1 ? frame.size.height-23 : frame.size.height-56)];
            view.layer.shadowOffset = CGSizeMake(1, 1);
            view.layer.shadowOpacity = 0.8;
            view.layer.shadowColor = [UIColor colorWithHexString:WHITEMAINCOLOR].CGColor;
            [self addSubview:view];
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            view1.backgroundColor = GetColorWithName(VBackColor);
            view1.layer.cornerRadius = 5;
            view1.layer.masksToBounds = YES;
            [view addSubview:view1];
            
            UIImageView *iconImagev = [[UIImageView alloc] initWithFrame:CGRectMake((view1.frame.size.width-(i == 1 ? 55:45))/2, i == 1 ? 43:27, i == 1 ? 55:45, i == 1 ? 55:45)];
            iconImagev.layer.cornerRadius = iconImagev.frame.size.width/2;
            iconImagev.layer.masksToBounds = YES;
            [view1 addSubview:iconImagev];
            [_iconArr addObject:iconImagev];
            
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-50-14, view1.frame.size.width, 14)];
            nameL.textAlignment = NSTextAlignmentCenter;
            nameL.textColor = GetColorWithName(VMainTextColor);
            nameL.font = i == 1? THRETEENTEXTFONTSIZE : FOURTHTEENTEXTFONTSIZE;
            [view1 addSubview:nameL];
            [_nameLarr addObject:nameL];
            
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0,  view1.frame.size.height-23-14, view1.frame.size.width, 14)];
            numL.textAlignment = NSTextAlignmentCenter;
            numL.textColor = [UIColor colorWithHexString:@"#C88F12"];
            numL.font = i == 1? THRETEENTEXTFONTSIZE : FOURTHTEENTEXTFONTSIZE;
            [view1 addSubview:numL];
            [_numLArr addObject:numL];
            
            UIImageView *paImgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 27, 26)];
            paImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"pai_%@",arr[i]]];
            [view1 addSubview:paImgV];
            
            UILabel *paiL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 27, 26)];
            paiL.textAlignment = NSTextAlignmentCenter;
            paiL.font = XGTwentyBoldFontSize;
            paiL.text = arr[i];
            paiL.textColor = [UIColor whiteColor];
            [paImgV addSubview:paiL];
            
            view1.tag = i;
            view1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapchoice:)];
            [view1 addGestureRecognizer:tap];
        }
        [_siconArr addObject:_iconArr[1]];
        [_siconArr addObject:_iconArr[0]];
        [_siconArr addObject:_iconArr[2]];
        
        [_snumLArr addObject:_numLArr[1]];
        [_snumLArr addObject:_numLArr[0]];
        [_snumLArr addObject:_numLArr[2]];
        
        [_snameLarr addObject:_nameLarr[1]];
        [_snameLarr addObject:_nameLarr[0]];
        [_snameLarr addObject:_nameLarr[2]];
    }
    return self;
}

- (void)tapchoice:(UITapGestureRecognizer *)tap{
    UIView *view = (UIView *)tap.view;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if (view.tag == 0) {
        ctl.userId = [_dataArr[1] user_id];
    }else if (view.tag == 1){
        ctl.userId = [_dataArr[0] user_id];
    }else{
        ctl.userId = [_dataArr[2] user_id];
    }
    ctl.isOther = YES;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    if (dataArr.count >= 3) {
        for (int i = 0; i < 3; i++) {
            NoticeRat *rat = dataArr[i];
            UILabel *nameL = _snameLarr[i];
            nameL.text = rat.nick_name;
            
            UILabel *numL = _snumLArr[i];
            numL.text =  [NSString stringWithFormat:@"%@%@",rat.movie_voice,GETTEXTWITE(@"listen.ypn")];
            
            UIImageView *icon = _siconArr[i];
            [icon sd_setImageWithURL:[NSURL URLWithString:rat.avatar_url]
                              placeholderImage:UIImageNamed(@"Image_jynohe")
                                       options:SDWebImageRefreshCached];
        }
    }
}

@end
