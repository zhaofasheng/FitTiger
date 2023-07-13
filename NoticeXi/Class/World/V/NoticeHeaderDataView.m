//
//  NoticeHeaderDataView.m
//  NoticeXi
//
//  Created by li lei on 2022/1/14.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHeaderDataView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeAdMainCell.h"
#import "NoticePickerShowController.h"
#import "NoticeNewUserOrderController.h"
#import "NoticeXi-Swift.h"
@implementation NoticeHeaderDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.00];
                
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(20,10,DR_SCREEN_WIDTH-40, 48);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeAdMainCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 92;
        [self addSubview:self.movieTableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:@"REFRESHGNEWSTOPLIST" object:nil];
        self.dataArr = [[NSMutableArray alloc] init];
        //
        [self request];
    }
    return self;
}

- (void)request{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"infoLattice/list?platformId=2&appVersion=%@",[NoticeSaveModel getVersion]] Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeWriteRecodModel *topicM = [NoticeWriteRecodModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:topicM];
            }
            [self.movieTableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWriteRecodModel *model = self.dataArr[indexPath.row];
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
   
    if (model.show_type.intValue == 2) {
        NoticeNewUserOrderController *ctl = [[NoticeNewUserOrderController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if(model.show_type.intValue == 1){
        NoticePickerShowController *ctl = [[NoticePickerShowController alloc] init];
        ctl.imgUrl = model.content;
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if(model.show_type.intValue == 3){
        NoticeLeaderController *ctl = [[NoticeLeaderController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAdMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.movieTableView reloadData];
}

@end
