//
//  NoticeShareTostView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareTostView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserShareCell.h"
#import "NoticeShareSureView.h"
#import "NoticeSearchSendListController.h"
@interface NoticeShareTostView()
@property (nonatomic, strong) NoticeShareSureView *sureView;
@end

@implementation NoticeShareTostView

- (NoticeShareSureView *)sureView{
    if (!_sureView) {
        _sureView = [[NoticeShareSureView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _sureView.dissMissBlock = ^(BOOL diss) {
            [weakSelf cancelClick];
        };
    }
    return _sureView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 160+BOTTOM_HEIGHT+40+222)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
    
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-20, DR_SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line];
        self.line = line;
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,222+20, DR_SCREEN_WIDTH, 80)];
        self.buttonView.backgroundColor = self.keyView.backgroundColor;
        [self.keyView addSubview:self.buttonView];
        
        
        NSArray *imgArr = @[@"Image_shareweix",@"Image_sharepyq",@"Image_sharewb",@"Image_shareQQ"];
        NSArray *textArr = @[[NoticeTools getLocalStrWith:@"shanrev.wx"],[NoticeTools getLocalStrWith:@"shanrev.pyq"],[NoticeTools getLocalStrWith:@"shanrev.wb"],@"QQ"];
        CGFloat space = (DR_SCREEN_WIDTH-44*4)/5;
        for (int i = 0; i < 4; i++) {
            UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(space+(space+44)*i, 0, 44, 44)];
            [self.buttonView addSubview:iamgeView];
            iamgeView.image = UIImageNamed(imgArr[i]);
            iamgeView.userInteractionEnabled = YES;
            iamgeView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTap:)];
            [iamgeView addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iamgeView.frame.origin.x, CGRectGetMaxY(iamgeView.frame)+14, 44, 14)];
            label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = textArr[i];
            [self.buttonView addSubview:label];
        }
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-20, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *labei1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 14)];
        labei1.font = ELEVENTEXTFONTSIZE;
        labei1.textColor = [UIColor colorWithHexString:@"#25262E"];
        labei1.text = [NoticeTools getLocalStrWith:@"chat.zuijinchant"];
        [self.keyView addSubview:labei1];
        self.chatL = labei1;
        
        UILabel *labei2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 200, 14)];
        labei2.font = ELEVENTEXTFONTSIZE;
        labei2.textColor = [UIColor colorWithHexString:@"#25262E"];
        labei2.text = [NoticeTools getLocalStrWith:@"yl.likeeach"];
        [self.keyView addSubview:labei2];
        self.likeL = labei2;
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(20,CGRectGetMaxY(labei1.frame)+12,DR_SCREEN_WIDTH-40, 60);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeUserShareCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 70;
        [self.keyView addSubview:self.movieTableView];
        self.dataArr = [[NSMutableArray alloc] init];
        
        self.movieTableView1 = [[UITableView alloc] init];
        self.movieTableView1.delegate = self;
        self.movieTableView1.dataSource = self;
        self.movieTableView1.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView1.frame = CGRectMake(20,CGRectGetMaxY(labei2.frame)+12,DR_SCREEN_WIDTH-40, 60);
        _movieTableView1.showsVerticalScrollIndicator = NO;
        self.movieTableView1.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView1 registerClass:[NoticeUserShareCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView1.rowHeight = 70;
        [self.keyView addSubview:self.movieTableView1];
        self.dataArr1 = [[NSMutableArray alloc] init];
        
        [self requestUser];
    }
    return self;
}

- (void)setIsPyOrTc:(BOOL)isPyOrTc{
    _isPyOrTc = isPyOrTc;
    if (isPyOrTc) {
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 160+BOTTOM_HEIGHT+20+222-100+40);
        self.buttonView.hidden = YES;
        self.cancelBtn.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-20, DR_SCREEN_WIDTH, 50);
        self.line.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-20, DR_SCREEN_WIDTH, 10);
    }
}

- (void)requestUser{
    NSString *type = @"3";
    NSString *url = @"";

    url = [NSString stringWithFormat:@"users/%@/newAdmires?type=%@&pageNo=1",[NoticeTools getuserId],type];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr1 removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                model.userId = model.user_id;
                [self.dataArr1 addObject:model];
            }
      
            NoticeFriendAcdModel *moreM = [[NoticeFriendAcdModel alloc] init];
            moreM.more = YES;
            [self.dataArr1 addObject: moreM];
            [self.movieTableView1 reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/recently" Accept:@"application/vnd.shengxi.v5.3.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            NoticeFriendAcdModel *moreM = [[NoticeFriendAcdModel alloc] init];
            moreM.more = YES;
            [self.dataArr addObject: moreM];
            [self.movieTableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.movieTableView) {
        return self.dataArr.count;
    }
    return self.dataArr1.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUserShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (tableView == self.movieTableView) {
        cell.friendM = self.dataArr[indexPath.row];
    }else{
        cell.friendM = self.dataArr1[indexPath.row];
    }
    
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.movieTableView) {
        if (indexPath.row == self.dataArr.count-1) {
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

            
            NoticeSearchSendListController *ctl = [[NoticeSearchSendListController alloc] init];
            ctl.isLike = NO;
            if (self.voiceM) {
                ctl.voiceM = self.voiceM;
            }
            if (self.pyModel) {
                ctl.pyModel = self.pyModel;
            }
            if (self.tcModel) {
                ctl.tcModel = self.tcModel;
            }
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            [self removeFromSuperview];
            return;
        }
    }else{
        if (indexPath.row == self.dataArr1.count-1) {
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

            
            NoticeSearchSendListController *ctl = [[NoticeSearchSendListController alloc] init];
            ctl.isLike = YES;
            if (self.voiceM) {
                ctl.voiceM = self.voiceM;
            }
            if (self.pyModel) {
                ctl.pyModel = self.pyModel;
            }
            if (self.tcModel) {
                ctl.tcModel = self.tcModel;
            }
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            [self removeFromSuperview];
            return;
        }
    }
    if (self.voiceM) {
        self.sureView.voiceM = self.voiceM;
    }
    if (self.pyModel) {
        self.sureView.pyModel = self.pyModel;
    }
    if (self.tcModel) {
        self.sureView.tcModel = self.tcModel;
    }
    self.sureView.userM = tableView==self.movieTableView?self.dataArr[indexPath.row]:self.dataArr1[indexPath.row];
    [self.sureView showTost];
}

- (void)shareTap:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    if(tapView.tag == 0){
        [NoticeShareView shareWithurl:self.voiceM.share_url type:SSDKPlatformSubTypeWechatSession title:@"声昔APP-我发现了一段心情" name:self.voiceM.subUserModel.nick_name];
    }else if(tapView.tag == 1){
        [NoticeShareView shareWithurl:self.voiceM.share_url type:SSDKPlatformSubTypeWechatTimeline title:@"声昔APP-我发现了一段心情" name:self.voiceM.subUserModel.nick_name];
    }else if(tapView.tag == 2){
        [NoticeShareView shareWithurl:self.voiceM.share_url type:SSDKPlatformTypeSinaWeibo title:@"声昔APP-我发现了一段心情" name:self.voiceM.subUserModel.nick_name];
    }else if(tapView.tag == 3){
        [NoticeShareView shareWithurl:self.voiceM.share_url type:SSDKPlatformSubTypeQQFriend title:@"声昔APP-我发现了一段心情" name:self.voiceM.subUserModel.nick_name];
    }
    [self cancelClick];
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
