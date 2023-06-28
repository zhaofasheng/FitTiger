//
//  NoticeHotMovieList.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHotMovieList.h"
#import "FSCustomButton.h"
#import "NoticeHotMovieCell.h"
#import "NoticeHotMovieViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMovieDetailViewController.h"
#import "NoticeMovieTopViewController.h"
#import "NoticeMyMovieController.h"
#import "NoticeFindSameViewController.h"
#import "NoticeMyCareController.h"
@implementation NoticeHotMovieList

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
   
        self.payView = [[UIView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height-5)];
        [self addSubview:self.payView];
        self.payView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        // 绘制圆角 需设置的圆角 使用"|"来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.payView.bounds byRoundingCorners:UIRectCornerBottomLeft |
        UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        // 设置大小
        maskLayer.frame = self.payView.bounds;
        // 设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.payView.layer.mask = maskLayer;
        

        self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, DR_SCREEN_WIDTH-40, 36)];
        self.searchBtn.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        self.searchBtn.layer.cornerRadius = 8;
        self.searchBtn.layer.masksToBounds = YES;
        [self.payView addSubview:self.searchBtn];
        [self.searchBtn setTitle:[NoticeTools getLocalStrWith:@"movie.searchmovie"] forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"]colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.searchBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.searchBtn setImage:UIImageNamed(@"Image_searchimg") forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,66, 200, 45)];
        label.text = [NoticeTools getLocalStrWith:@"movie.hotmovie"];
        label.font = EIGHTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.payView addSubview:label];
        
        UILabel * _subL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-60,label.frame.origin.y,60, 45)];
        _subL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _subL.font = TWOTEXTFONTSIZE;
        _subL.text = [NoticeTools getLocalStrWith:@"movie.more"];
        _subL.textAlignment = NSTextAlignmentRight;
        [self.payView addSubview:_subL];
        self.userInteractionEnabled = YES;
        _subL.userInteractionEnabled = YES;
        UITapGestureRecognizer *allTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allClick)];
        [_subL addGestureRecognizer:allTap];
        
        self.dataArr = [NSMutableArray new];
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(20,45+66,DR_SCREEN_WIDTH-40, 155);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.payView.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeHotMovieCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 87+15;
        [self.payView addSubview:self.movieTableView];
        [self requestList];

    }
    return self;
}

- (void)requestList{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"resources/1?sortType=2" Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (![dict[@"data"] count]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMovie *model = [NoticeMovie mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.movieTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeMovieDetailViewController *ctl = [[NoticeMovieDetailViewController alloc] init];
    
    NoticeHotMovieCell *cell = (NoticeHotMovieCell *)[tableView cellForRowAtIndexPath:indexPath];
    ctl.detialView.postImageView = cell.postImageView;
    ctl.movie = self.dataArr[indexPath.row];
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHotMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.movie = self.dataArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)allClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeHotMovieViewController *ctl = [[NoticeHotMovieViewController alloc] init];
     [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 1);//渐变
    transform = CATransform3DTranslate(transform, -200, 0, 0);//左边水平移动
    // transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    
    cell.layer.transform = transform;
    cell.layer.opacity = 0.0;
    
    [UIView animateWithDuration:0.6 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}

@end
