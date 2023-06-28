//
//  NoticeMoreClickView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoreClickView.h"
#import "NoticeUserShareCell.h"
#import "NoticeMyBookController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeMoreClickView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 140+BOTTOM_HEIGHT+20+10)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
    
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-10, DR_SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line];
        self.line = line;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(20,20,DR_SCREEN_WIDTH-40, 70);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeUserShareCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 70;
        [self.keyView addSubview:self.movieTableView];
        self.dataArr = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)setIsShare:(BOOL)isShare{
    _isShare = isShare;
    self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 140+BOTTOM_HEIGHT+20+10+50);
    self.line.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-10, DR_SCREEN_WIDTH, 10);
    self.cancelBtn.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10, DR_SCREEN_WIDTH, 50);
    self.movieTableView.frame = CGRectMake(0,20+40,DR_SCREEN_WIDTH, 70);
    self.movieTableView.rowHeight = DR_SCREEN_WIDTH/4;
    self.imgArr = @[@"Image_shareweix",@"Image_sharepyq",@"Image_sharewb",@"Image_shareQQ"];
    self.titleArr = @[[NoticeTools getLocalStrWith:@"shanrev.wx"],[NoticeTools getLocalStrWith:@"shanrev.pyq"],[NoticeTools getLocalStrWith:@"shanrev.wb"],@"QQ"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = XGTwentyBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.text = [NoticeTools getLocalStrWith:@"group.shareto"];
    [self.keyView addSubview:label];
    
    [self.movieTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    
    if (self.isShare) {
        if (self.bokeId) {
            NSString *url = [NSString stringWithFormat:@"http://priapi.byebyetext.com/share3/index.html?id=%@",self.bokeId];
            if(indexPath.row == 0){
                [NoticeShareView shareWithurl:url type:SSDKPlatformSubTypeWechatSession title:self.name name:self.title];
            }else if(indexPath.row == 1){
                [NoticeShareView shareWithurl:url type:SSDKPlatformSubTypeWechatTimeline title:self.name name:self.title];
            }else if(indexPath.row == 2){
                [NoticeShareView shareWithurl:url type:SSDKPlatformTypeSinaWeibo title:self.name name:self.title];
            }else if(indexPath.row == 3){
                [NoticeShareView shareWithurl:url type:SSDKPlatformSubTypeQQFriend title:self.name name:self.title];
            }
            return;
        }
        if(indexPath.row == 0){
            [NoticeShareView shareWithurl:@"http://priapi.byebyetext.com/share2/index.html?type=shengxi1" type:SSDKPlatformSubTypeWechatSession title:self.name name:self.title];
        }else if(indexPath.row == 1){
            [NoticeShareView shareWithurl:@"http://priapi.byebyetext.com/share2/index.html?type=shengxi1" type:SSDKPlatformSubTypeWechatTimeline title:self.name name:self.title];
        }else if(indexPath.row == 2){
            [NoticeShareView shareWithurl:@"http://priapi.byebyetext.com/share2/index.html?type=shengxi1" type:SSDKPlatformTypeSinaWeibo title:self.name name:self.title];
        }else if(indexPath.row == 3){
            [NoticeShareView shareWithurl:@"http://priapi.byebyetext.com/share2/index.html?type=shengxi1" type:SSDKPlatformSubTypeQQFriend title:self.name name:self.title];
        }
        return;
    }
    
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
    NoticeMyBookController *ctl = [[NoticeMyBookController alloc] init];
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isShare? 4: 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUserShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.isShare) {
        cell.moreL.hidden = YES;
        cell.nameL.text = self.titleArr[indexPath.row];
        cell.iconImageView.image = UIImageNamed(self.imgArr[indexPath.row]);
        cell.iconImageView.frame = CGRectMake((DR_SCREEN_WIDTH/4-44)/2, 0, 44, 44);
        cell.nameL.frame = CGRectMake(0,CGRectGetMaxY(cell.iconImageView.frame)+3,DR_SCREEN_WIDTH/4,17);
    }else{
        cell.moreL.hidden = YES;
        cell.nameL.text = [NoticeTools getLocalType]==1?@"Past": ([NoticeTools getLocalType]==2?@"過去": @"书影音画");
        cell.iconImageView.image = UIImageNamed(@"Image_syydra");
    }

    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (void)showTost{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+20, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
