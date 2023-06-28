//
//  NoticeVoiceReadController.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceReadController.h"
#import "NoticeVoiceReadTuiJianCell.h"
#import "NoticeVoiceReadFooterView.h"
#import "NoticeReadingMoreController.h"
#import "NoticeHeJiListController.h"
#import "NoticeReadAllContentView.h"
#import "NoticeHeJiListController.h"
@interface NoticeVoiceReadController ()
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NoticeReadAllContentView *readingView;

@end

@implementation NoticeVoiceReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"luy.langdu"];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.dataArr = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[NoticeVoiceReadTuiJianCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 165;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    headerView.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    label.font = XGEightBoldFontSize;
    label.text = [NoticeTools getLocalStrWith:@"luy.tuijian"];
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    [headerView addSubview:label];
    self.sectionView = headerView;
    
    [self requestTuijian];
    
    __weak typeof(self) weakSelf = self;
    NoticeVoiceReadFooterView *footerView = [[NoticeVoiceReadFooterView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 222)];
    footerView.moreBlock = ^(BOOL more) {
        NoticeReadingMoreController *ctl = [[NoticeReadingMoreController alloc] init];
        ctl.readingBlock = ^(NoticeVoiceReadModel * _Nonnull readM, BOOL isHejiBack) {
            if (weakSelf.readingBlock) {
                [weakSelf.navigationController popViewControllerAnimated:NO];
                weakSelf.readingBlock(readM,isHejiBack);
            }
        };
   
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:weakSelf.navigationController.view];
        [weakSelf.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [weakSelf.navigationController pushViewController:ctl animated:YES];
    };
    footerView.moreDetailBlock = ^(NoticeVoiceReadModel * _Nonnull detailReadModel) {
        NoticeHeJiListController *ctl = [[NoticeHeJiListController alloc] init];
        ctl.readModel = detailReadModel;
        ctl.readingBlock = ^(NoticeVoiceReadModel * _Nonnull readM, BOOL isHejiBack) {
            if (weakSelf.readingBlock) {
                [weakSelf.navigationController popViewControllerAnimated:NO];
                weakSelf.readingBlock(readM,isHejiBack);
            }
        };
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:weakSelf.navigationController.view];
        [weakSelf.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [weakSelf.navigationController pushViewController:ctl animated:YES];
    };
    self.tableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceReadTuiJianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.readModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.readingBlock = ^(NoticeVoiceReadModel * _Nonnull readM) {
        if (weakSelf.readingBlock) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            weakSelf.readingBlock(readM,NO);
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceReadModel *model = self.dataArr[indexPath.row];
    self.readingView.readModel = model;
    self.readingView.hidden = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = YES;
    [CoreAnimationEffect animationEaseIn:self.readingView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)requestTuijian{
    
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"readAloud/getHot" Accept:@"application/vnd.shengxi.v5.3.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceReadModel *readM = [NoticeVoiceReadModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:readM];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];

}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (NoticeReadAllContentView *)readingView{
    if (!_readingView) {
        _readingView = [[NoticeReadAllContentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.view addSubview:_readingView];
        _readingView.hidden = YES;
    }
    return _readingView;;
}
@end
