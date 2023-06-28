//
//  NoticeMyMovieListController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyMovieListController.h"
#import "NoticeMovieTopCell.h"
#import "NoticeNoDataView.h"
#import "NoticeMovieDetailViewController.h"
#import "NoticeMoreVoiceController.h"
#import "NoticeMovieBaseController.h"
@interface NoticeMyMovieListController ()<NoticeMyMBSListClickPalyerButtonDelegate>
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIView *hasDataFootView;
@property (nonatomic, assign) BOOL isGetMore;

@end

@implementation NoticeMyMovieListController
{
    UILabel *_numL;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    backV.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:appdel.backImg?0:1];
 
    _backV = backV;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0, DR_SCREEN_WIDTH-90,44)];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    label.text = @"0";
    _numL = label;
    [_backV addSubview:_numL];
    
    if (self.type == 1) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/resources/1/statistics",self.isOther?self.userId: [NoticeTools getuserId]] Accept: @"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeSong *songTotlaM = [NoticeSong mj_objectWithKeyValues:dict[@"data"]];
                self->_numL.text = [NSString stringWithFormat:@"%@%@",songTotlaM.resouce_num,[NoticeTools getLocalStrWith:@"py.ofnum"]];
            }
        } fail:^(NSError *error) {
        }];
    }
    
    self.dataArr = [NSMutableArray new];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-48-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeMovieTopCell class] forCellReuseIdentifier:@"mCell"];
    self.tableView.rowHeight = 159;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    self.line.hidden = YES;
    
    self.oldIndex = 99999999;
    self.currentIndex = 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMovieTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mCell"];
    cell.isOther = self.userId ? YES:NO;
    cell.userId = self.userId;
    if (self.type == 1) {
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.firstMovice = self.dataArr[indexPath.row];
    }else{
        cell.movice = self.dataArr[indexPath.row];
    }
    
    if (indexPath.row == self.dataArr.count-1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type != 1) {
        NoticeMovieDetailViewController *ctl = [[NoticeMovieDetailViewController alloc] init];
        ctl.movie = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)createRefesh{
    
    __weak NoticeMyMovieListController *ctl = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        ctl.isDown = NO;
        [ctl requestData];
    }];
}
- (void)requestData{

    NSString *url = nil;
  
    if (self.isDown) {
        if (self.type == 1) {
            url = [NSString stringWithFormat:@"users/%@/resources/1",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id]];
        }else{
            url = [NSString stringWithFormat:@"users/%@/resourceSubscription?resourceType=1&subscriptionType=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.type == 2?@"1":@"2"];
        }
    }else{
        if (self.type == 1) {
            url = [NSString stringWithFormat:@"users/%@/resources/1?lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/resourceSubscription?resourceType=1&subscriptionType=%@&lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.type == 2?@"1":@"2",self.lastId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.type == 1 ? @"application/vnd.shengxi.v4.6.0+json":@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                if (self.type != 1) {
                    NoticeMovie *movieTotalM = [NoticeMovie mj_objectWithKeyValues:dict[@"data"]];
                    self->_numL.text = [NSString stringWithFormat:@"%d%@",movieTotalM.total.intValue,[NoticeTools getLocalStrWith:@"py.ofnum"]];
                }
                [self.dataArr removeAllObjects];
            }
            if (self.type == 1) {
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeMovie *model = [NoticeMovie mj_objectWithKeyValues:dic];
                    NoticeMovie *showM = [NoticeMovie mj_objectWithKeyValues:model.resource];
                    showM.voice_num = model.voice_num;
                    showM.rate_id = model.movieListId;
                    [self.dataArr addObject:showM];
                }
            }else{
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    NoticeMovie *model = [NoticeMovie mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
            }
        
            if (self.dataArr.count) {
                NoticeMovie *movie = self.dataArr[self.dataArr.count-1];
                self.lastId = self.type == 1 ? movie.rate_id : movie.movieListId;
                self.tableView.tableHeaderView = self.backV;
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy10");
                self.queshenView.titleStr = @"历史功能不能使用";
                self.tableView.tableFooterView = self.queshenView;
                self.tableView.tableHeaderView = nil;
            }
            [self.tableView reloadData];
        }else{
            self.tableView.tableHeaderView = nil;
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
