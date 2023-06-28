//
//  NoticeTuiJianCareView.m
//  NoticeXi
//
//  Created by li lei on 2021/5/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTuiJianCareView.h"
#import "DRPsychologyViewController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeNewTuiJianCell.h"
@implementation NoticeTuiJianCareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        self.isOpen = YES;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 160)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0,200, 40)];
        label.text = @"偶遇";
        label.font = FIFTHTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.backView addSubview:label];
        
        self.openImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-20-10, 10, 20, 20)];
        self.openImageView.image = UIImageNamed(@"Image_opentuijian");
        [self.backView addSubview:self.openImageView];
        
        self.userInteractionEnabled = YES;
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, 40)];
        tapView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrClose)];
        [tapView addGestureRecognizer:tap];
        [self.backView addSubview:tapView];
        
        self.dataArr = [NSMutableArray new];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(10,40,DR_SCREEN_WIDTH-30-20, 120);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = self.backView.backgroundColor;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeNewTuiJianCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 65;
        [self.backView addSubview:self.movieTableView];
        
        self.noDataL = [[UILabel alloc] initWithFrame:self.movieTableView.frame];
        self.noDataL.textAlignment = NSTextAlignmentCenter;
        self.noDataL.textColor = [UIColor colorWithHexString:@"#737780"];
        self.noDataL.font = FIFTHTEENTEXTFONTSIZE;
        self.noDataL.text = @"我听见悄悄话，来自山谷和心间";
        [self.backView addSubview:self.noDataL];
        self.noDataL.hidden = YES;
    }
    return self;
}

- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.backView.frame.size.width, 120)];
        _testView.backgroundColor = self.backView.backgroundColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, _testView.frame.size.width, 32)];
        label.text = @"完成个性化测试，更容易发现和你默契度高的Ta哦~";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = SIXTEENTEXTFONTSIZE;
        [_testView addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((_testView.frame.size.width-124)/2, CGRectGetMaxY(label.frame)+15, 124, 38)];
        [btn setTitle:[NoticeTools getLocalStrWith:@"test.now"] forState:UIControlStateNormal];
        [btn setTitleColor:label.textColor forState:UIControlStateNormal];
        btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [btn addTarget:self action:@selector(testNow) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 19;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:UIImageNamed(@"img_buttonback") forState:UIControlStateNormal];
        [_testView addSubview:btn];
        [self.backView addSubview:_testView];
    }
    return _testView;
}

- (void)testNow{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    DRPsychologyViewController *ctl = [[DRPsychologyViewController alloc] init];
    ctl.isFromMain = YES;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewTuiJianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.careM = self.dataArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (void)openOrClose{
    self.isOpen = !self.isOpen;
    self.openImageView.image = UIImageNamed(self.isOpen? @"Image_opentuijian":@"Image_closetuijian");
    self.frame= CGRectMake(0, 0, DR_SCREEN_WIDTH, (!self.isOpen?60:180));
    self.backView.frame = CGRectMake(15, 20, DR_SCREEN_WIDTH-30, (!self.isOpen?40:160));
    if (self.changeFrameBlock) {
        self.changeFrameBlock(YES);
    }
}

- (void)request{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"getEncounter/voices" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.dataArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            self.noDataL.hidden = self.dataArr.count?YES:NO;
            [self.movieTableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

@end
