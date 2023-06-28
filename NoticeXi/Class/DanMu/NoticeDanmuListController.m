//
//  NoticeDanmuListController.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanmuListController.h"
#import "NoticeBoKeCell.h"
#import "NoticeMyBokeController.h"
#import "NoticeDanMuController.h"
@interface NoticeDanmuListController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NSString *lastPodcastNo;
@end

@implementation NoticeDanmuListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;

    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.backgroundColor = self.view.backgroundColor;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"main.bk"];
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeBoKeCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = ((DR_SCREEN_WIDTH*203)/305)+12;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.line.hidden = YES;
    
    UIImageView *_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-32,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2,32, 32)];
    _iconImageView.layer.cornerRadius = 16;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.userInteractionEnabled = YES;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myBokeTap)];
    [_iconImageView addGestureRecognizer:tap];
    [self.navBarView addSubview:_iconImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBoKeBeDelete:) name:@"DeleteBoKeNotification" object:nil];
}

- (void)getBoKeBeDelete:(NSNotification*)notification{
    if (self.dataArr.count) {
        for (NoticeDanMuModel *bokeM in self.dataArr) {
            NSDictionary *nameDictionary = [notification userInfo];
            NSString *num = nameDictionary[@"danmuNumber"];
            if ([bokeM.podcast_no isEqualToString:num]) {
                [self.dataArr removeObject:bokeM];
                [self.tableView reloadData];
                break;
            }
        }
    }
}


- (void)myBokeTap{
    NoticeMyBokeController *ctl = [[NoticeMyBokeController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuModel *model = self.dataArr[indexPath.row];
    return 50 + model.titleHeight + (((DR_SCREEN_WIDTH-70)*203)/305)+12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];

    ctl.bokeModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBoKeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{

    __weak NoticeDanmuListController *ctl = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.page = 1;
        [ctl requestVoice];
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.page++;
        ctl.isDown = NO;
        [ctl requestVoice];
    }];
}

- (void)requestVoice{
    NSString *url = nil;
    if (self.isDown) {
        url = @"podcast";
    }else{
        url = [NSString stringWithFormat:@"podcast?pageNo=%ld&lastPodcastNo=%@",self.page,self.lastPodcastNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeDanMuModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.bokeId;
                self.lastPodcastNo = lastM.podcast_no;
            }
            [self.tableView reloadData];
        }

    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
@end
