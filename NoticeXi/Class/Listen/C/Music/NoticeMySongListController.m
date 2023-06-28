//
//  NoticeMySongListController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMySongListController.h"
#import "NoticeAllHotCell.h"
#import "NoticeNoDataView.h"
#import "NoticeSongDetailController.h"
#import "NoticeMBSPlayerView.h"
#import "NoticeMoreVoiceController.h"
#import "NoticeMusicBaseController.h"
@interface NoticeMySongListController ()
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIView *hasDataFootView;
@property (nonatomic, assign) BOOL isGetMore;
@end

@implementation NoticeMySongListController
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,3, DR_SCREEN_WIDTH-90,14)];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _numL = label;
    [_backV addSubview:_numL];
    
    if (self.type == 1) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/resources/3/statistics",self.isOther?self.userId: [NoticeTools getuserId]] Accept: @"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeSong *songTotlaM = [NoticeSong mj_objectWithKeyValues:dict[@"data"]];
                self->_numL.text = [NSString stringWithFormat:@"%@%@%@",[NoticeTools getLocalStrWith:@"groupImg.g"],songTotlaM.resouce_num,[NoticeTools getLocalStrWith:@"music.s"]];
            }
        } fail:^(NSError *error) {
        }];
    }

    
    self.dataArr = [NSMutableArray new];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-35-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeAllHotCell class] forCellReuseIdentifier:@"hotCell"];
    self.tableView.rowHeight = 84+15;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    self.oldIndex = 99999999;
    self.currentIndex = 0;
}

- (void)clickMBSMore:(NSInteger)index{
    NoticeSong*song = self.dataArr[index];
    NoticeMoreVoiceController *ctl = [[NoticeMoreVoiceController alloc] init];
    ctl.resourceId = song.albumId;
    ctl.resourceType = @"3";
    ctl.userId = self.isOther?self.userId:[NoticeTools getuserId];
    ctl.isOther = self.isOther;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAllHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    cell.song = self.dataArr[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        return;
    }
    NoticeSongDetailController *ctl = [[NoticeSongDetailController alloc] init];
    NoticeSong *song = self.dataArr[indexPath.row];
    ctl.songId = song.song_id;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)createRefesh{
    
    __weak NoticeMySongListController *ctl = self;
    
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
            url = [NSString stringWithFormat:@"users/%@/resources/3",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id]];
        }else{
            url = [NSString stringWithFormat:@"users/%@/resourceSubscription?resourceType=3&subscriptionType=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.type == 2?@"1":@"2"];
        }
    }else{
        if (self.type == 1) {
           url = [NSString stringWithFormat:@"users/%@/resources/3?lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/resourceSubscription?resourceType=3&subscriptionType=%@&lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.type == 2?@"1":@"2",self.lastId];
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
                    NoticeSong *songTotlaM = [NoticeSong mj_objectWithKeyValues:dict[@"data"]];
                    self->_numL.text = [NSString stringWithFormat:@"%@%d%@",[NoticeTools getLocalStrWith:@"groupImg.g"],songTotlaM.total.intValue,[NoticeTools getLocalStrWith:@"music.s"]];
                }
                [self.dataArr removeAllObjects];
            }
            if (self.type == 1) {
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeSong *model = [NoticeSong mj_objectWithKeyValues:dic];
                    NoticeSong *showM = [NoticeSong mj_objectWithKeyValues:model.resource];
                    showM.voice_num = model.voice_num;
                    showM.rate_id = model.albumId;
                    [self.dataArr addObject:showM];
                }
            }else{
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    NoticeSong *model = [NoticeSong mj_objectWithKeyValues:dic];
                    if (model) {
                        [self.dataArr addObject:model];
                    }
                }
            }
          
            if (self.dataArr.count) {
                NoticeSong *song = self.dataArr[self.dataArr.count-1];
                self.lastId = self.type == 1? song.rate_id:song.albumId;
                self.tableView.tableFooterView = nil;
                self.tableView.tableHeaderView = self.backV;
            }else{
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy10");
                self.queshenView.titleStr = @"历史功能不能使用";
                self.tableView.tableFooterView = self.queshenView;
                self.tableView.tableHeaderView = nil;
                self.tableView.tableFooterView = self.queshenView;
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

- (void)gotomuiscClick{
    NoticeMusicBaseController *ctl = [[NoticeMusicBaseController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UIView *)hasDataFootView{
    if (!_hasDataFootView) {
        _hasDataFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 49+BOTTOM_HEIGHT+10)];
    }
    return _hasDataFootView;
}

@end
