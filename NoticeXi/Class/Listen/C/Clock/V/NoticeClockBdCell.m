//
//  NoticeClockBdCell.m
//  NoticeXi
//
//  Created by li lei on 2019/10/22.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockBdCell.h"

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeTcPageController.h"
#import "NoticePyComController.h"
@implementation NoticeClockBdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 65)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        backView.userInteractionEnabled = YES;
        
        self.pmImageV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 14, 33, 36)];
        [backView addSubview:self.pmImageV];
        
        self.pmL = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 33, 65)];
        self.pmL.textAlignment = NSTextAlignmentCenter;
        self.pmL.font = EIGHTEENTEXTFONTSIZE;
        self.pmL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        [backView addSubview:self.pmL];
        
        self.pyIconImageV = [[UIImageView alloc] initWithFrame:CGRectMake((backView.frame.size.width-33*3-80)/2+CGRectGetMaxX(self.pmImageV.frame)+2.5, 10, 28, 28)];
        self.pyIconImageV.layer.cornerRadius = 14;
        self.pyIconImageV.layer.masksToBounds = YES;
        [backView addSubview:self.pyIconImageV];
        self.pyIconImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pyTap)];
        [self.pyIconImageV addGestureRecognizer:tap];
        
        self.bgL = [[UILabel alloc] initWithFrame:CGRectMake(self.pyIconImageV.frame.origin.x-20, CGRectGetMaxY(self.pyIconImageV.frame)+4, 68, 14)];
        self.bgL.font = [UIFont systemFontOfSize:10];
        self.bgL.textAlignment = NSTextAlignmentCenter;
        self.bgL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [backView addSubview:self.bgL];
        
        self.tcIconImageV = [[UIImageView alloc] initWithFrame:CGRectMake((backView.frame.size.width-33*3-80)/2+CGRectGetMaxX(self.pyIconImageV.frame)+5, 10, 28, 28)];
        self.tcIconImageV.layer.cornerRadius = 14;
        self.tcIconImageV.layer.masksToBounds = YES;
        [backView addSubview:self.tcIconImageV];
        self.tcIconImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tcTap)];
        [self.tcIconImageV addGestureRecognizer:tTap];
        
        self.tcL = [[UILabel alloc] initWithFrame:CGRectMake(self.tcIconImageV.frame.origin.x-20, CGRectGetMaxY(self.tcIconImageV.frame)+4, 68, 14)];
        self.tcL.font = [UIFont systemFontOfSize:10];
        self.tcL.textAlignment = NSTextAlignmentCenter;
        self.tcL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [backView addSubview:self.tcL];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    self.pmL.text = @"";
    self.pmImageV.hidden = YES;
    
    if (self.index == 0) {
        self.pmImageV.hidden = NO;
        self.pmImageV.image = UIImageNamed(@"Image_numone");
    }else if (self.index == 1){
        self.pmImageV.hidden = NO;
        self.pmImageV.image = UIImageNamed(@"Image_numtwo");
    }else if (self.index == 2){
        self.pmImageV.hidden = NO;
        self.pmImageV.image = UIImageNamed(@"Image_numthree");
    }else{
        self.pmL.text = [NSString stringWithFormat:@"%ld",self.index+1];
    }
}

- (void)setBdModel:(NoticeClockBdUser *)bdModel{
    _bdModel = bdModel;
    if (self.index < 3) {
        self.pmL.hidden = YES;
        self.pmImageV.hidden = NO;
    }else{
        self.pmL.hidden = NO;
        self.pmImageV.hidden = YES;
    }
    
    if (bdModel.didding_vote_num.intValue) {
        self.pyIconImageV.hidden = NO;
        self.bgL.hidden = NO;
        self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ %@",bdModel.didding_vote_num,([NoticeTools getLocalType]==2)?@"おやつ": ([NoticeTools getLocalType]?@"Same":@"贴贴")] setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:bdModel.didding_vote_num beginSize:0];
        [_pyIconImageV sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:bdModel.didding_userM.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    }else{
        self.pyIconImageV.hidden = YES;
        self.bgL.hidden = YES;
    }
    
    if (bdModel.line_vote_num.intValue) {
        self.tcIconImageV.hidden = NO;
        self.tcL.hidden = NO;
        self.tcL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ %@",bdModel.line_vote_num,[NoticeTools getLocalStrWith:@"main.py"]] setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:bdModel.line_vote_num beginSize:0];
        [_tcIconImageV sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:bdModel.line_userM.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    }else{
        self.tcIconImageV.hidden = YES;
        self.tcL.hidden = YES;
    }
}

- (void)pyTap{
    if (!self.bdModel.didding_id.intValue) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.bdModel.didding_id.intValue) {
        NoticePyComController *ctl = [[NoticePyComController alloc] init];
        ctl.pyId = self.bdModel.didding_id;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)tcTap{
    if (!self.bdModel.line_id.intValue) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.bdModel.line_id.intValue) {
        NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
        ctl.tcId = self.bdModel.line_id;
        ctl.tcSendUser = self.bdModel.line_userM;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}
@end
