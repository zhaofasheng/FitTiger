//
//  NoticeTuYaChatController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTuYaChatController.h"
#import "NoticeStayCell.h"
#import "NoticeTuYaChatWithOtherController.h"
@interface NoticeTuYaChatController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeTuYaChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"hh.allty"];
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:[NoticeStayCell class] forCellReuseIdentifier:@"cell1"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeStayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.contentView.tag = 2000+indexPath.row;
    cell.canTap = YES;
    cell.tuyaModel = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
    NoticeStaySys *chat = self.dataArr[indexPath.row];
    ctl.drawId = chat.resource_id;
    ctl.toUserId = chat.with_user_id;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeStaySys *sys = self.dataArr[indexPath.row];
    // 添加一个删除按钮
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NoticeTools getLocalStrWith:@"groupManager.del"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //在这里添加点击事件
        
        LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
            if (buttonIndex2 ==2 ) {
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"chats/%@",sys.chat_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
                        [weakSelf.tableView reloadData];
                        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                    }
                } fail:^(NSError *error) {
                    [weakSelf hideHUD];
                }];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"hh.surescdh"],[NoticeTools getLocalStrWith:@"main.sure"]]];
        [sheet2 show];
        
    }];
    UITableViewRowAction *jubaoRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NoticeTools getLocalStrWith:@"chat.jubao"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithLeaderJuBaoView];
        [pinV showTostView];
    }];
    jubaoRowAction.backgroundColor = GetColorWithName(VlineColor);
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction,jubaoRowAction];
}



- (void)createRefesh{
    
    __weak NoticeTuYaChatController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"artworks/%@/chats",self.drawId];
    }else{
        url = [NSString stringWithFormat:@"artworks/%@/chats?lastDialogId=%@",self.drawId,self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeStaySys *model = [NoticeStaySys mj_objectWithKeyValues:dic];
                
                BOOL alerady = NO;
                
                for (NoticeStaySys *olM in self.dataArr) {//判断是否有重复数据
                    if ([olM.chat_id isEqualToString:model.chat_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                  [self.dataArr addObject:model];
                }
                
            }
            if (self.dataArr.count) {
                NoticeStaySys *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.last_dialog_id;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}



@end
