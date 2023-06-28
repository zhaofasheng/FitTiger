//
//  NoticeMyBookListController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyBookListController.h"
#import "NoticeMovieTopCell.h"
#import "NoticeNoDataView.h"
#import "NoticeBookDetailController.h"
#import "NoticeMoreVoiceController.h"
#import "NoticeBookBaseController.h"
@interface NoticeMyBookListController ()<NoticeMyMBSListClickPalyerButtonDelegate>
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIView *hasDataFootView;
@property (nonatomic, assign) BOOL isGetMore;
@end

@implementation NoticeMyBookListController

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
    _numL = label;
    [_backV addSubview:_numL];
    
    if (self.type == 1) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/resources/2/statistics",self.isOther?self.userId: [NoticeTools getuserId]] Accept: @"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeSong *songTotlaM = [NoticeSong mj_objectWithKeyValues:dict[@"data"]];
                self->_numL.text = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"groupImg.g"],songTotlaM.resouce_num];
            }
        } fail:^(NSError *error) {
        }];
    }
    
    self.dataArr = [NSMutableArray new];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-48-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeMovieTopCell class] forCellReuseIdentifier:@"mCell"];
    self.tableView.rowHeight = 170;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];

    self.oldIndex = 99999999;
    self.currentIndex = 0;
}

- (void)clickMBSMoreButton:(NSInteger)index{
    NoticeBook*book = self.dataArr[index];
    NoticeMoreVoiceController *ctl = [[NoticeMoreVoiceController alloc] init];
    ctl.resourceId = book.bookId?book.bookId:book.book_id;
    ctl.resourceType = @"2";
    ctl.userId = self.isOther?self.userId:[NoticeTools getuserId];
    ctl.isOther = self.isOther;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMovieTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mCell"];
    cell.isOther = self.userId ? YES:NO;
    cell.userId = self.userId;
    if (self.type == 1) {
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.firstbook = self.dataArr[indexPath.row];
    }else{
        cell.book = self.dataArr[indexPath.row];
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
    if (self.type == 1) {
        return;
    }
    NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
    NoticeBook *book = self.dataArr[indexPath.row];
    ctl.bookId = book.book_id?book.book_id:book.bookId;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)createRefesh{
    
    __weak NoticeMyBookListController *ctl = self;
    
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
            url = [NSString stringWithFormat:@"users/%@/resources/2",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id]];
        }else{
            url = [NSString stringWithFormat:@"users/%@/resourceSubscription?resourceType=2&subscriptionType=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.type == 2?@"1":@"2"];
        }
      
        
    }else{
        if (self.type == 1) {
            url = [NSString stringWithFormat:@"users/%@/resources/2?lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/resourceSubscription?resourceType=2&subscriptionType=%@&lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.type == 2?@"1":@"2",self.lastId];
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
                    NoticeBook *bookTotalM = [NoticeBook mj_objectWithKeyValues:dict[@"data"]];
                    self->_numL.text = [NSString stringWithFormat:@"%@ %d",[NoticeTools getLocalStrWith:@"groupImg.g"],bookTotalM.total.intValue];
                }
                [self.dataArr removeAllObjects];
            }
            if (self.type == 1) {
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeBook *model = [NoticeBook mj_objectWithKeyValues:dic];
                    NoticeBook *showM = [NoticeBook mj_objectWithKeyValues:model.resource];
                    showM.voice_num = model.voice_num;
                    showM.rate_id = model.bookId;
                    [self.dataArr addObject:showM];
                }
            }else{
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    NoticeBook *model = [NoticeBook mj_objectWithKeyValues:dic];
                    if (model) {
                        [self.dataArr addObject:model];
                    }
                }
            }
            
            if (self.dataArr.count) {
                self.tableView.tableHeaderView = self.backV;
                NoticeBook *book = self.dataArr[self.dataArr.count-1];
                self.lastId = self.type == 1 ? book.rate_id : book.bookId;
                self.tableView.tableFooterView = self.hasDataFootView;
            }else{
                self.tableView.tableHeaderView = nil;
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        }else{
            self.tableView.tableHeaderView = nil;
            self.tableView.tableFooterView = self.footView;
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)gotobookClick{
    NoticeBookBaseController *ctl = [[NoticeBookBaseController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NoticeNoDataView *)footView{
    if (!_footView) {//
        _footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,self.tableView.frame.size.height)];
        _footView.titleImageV.image = UIImageNamed(@"Image_quesy10");
        _footView.titleStr = @"历史功能不能使用";
    }
    return _footView;
}

- (UIView *)hasDataFootView{
    if (!_hasDataFootView) {
        _hasDataFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 49+BOTTOM_HEIGHT+10)];
    }
    return _hasDataFootView;
}

@end
