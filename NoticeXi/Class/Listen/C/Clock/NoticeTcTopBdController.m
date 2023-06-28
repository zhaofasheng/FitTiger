//
//  NoticeTcTopBdController.m
//  NoticeXi
//
//  Created by li lei on 2020/4/22.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTcTopBdController.h"
#import "NoticeTCCell.h"
@interface NoticeTcTopBdController ()<NoticeTcCellDelegate>
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@end

@implementation NoticeTcTopBdController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleSecond = self.type.intValue==0?@"Top3":(self.type.intValue>1?@"Top10":@"Top5");
    NSArray *titleArr = @[@"今日台词",@"本周台词",@"本月台词",[NoticeTools getLocalStrWith:@"py.tc"]];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",titleArr[self.type.intValue],titleSecond];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    [self.tableView registerClass:[NoticeTCCell class] forCellReuseIdentifier:@"pyCell"];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.dataArr = [NSMutableArray new];
    if (self.isBest) {
        self.navigationItem.title = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"py.tdbestTc"] fantText:@"今日最佳臺詞"];
        if (self.currentModel) {
            [self.dataArr addObject:self.currentModel];
        }
    }else{
        [self request];
    }
    
    
}

- (void)request{
    NSString *url = @"";
    self.voteType = @"0";
    if (self.type.intValue == 0) {
        url = [NSString stringWithFormat:@"leaderboard/lines/optimal?type=day&toUserId=%@",self.userId];
    }else if (self.type.intValue == 1){
        url = [NSString stringWithFormat:@"leaderboard/lines/optimal?type=week&toUserId=%@",self.userId];
    }else if (self.type.intValue == 2){
        url = [NSString stringWithFormat:@"leaderboard/lines/optimal?type=month&toUserId=%@",self.userId];
    }else{
        url = [NSString stringWithFormat:@"leaderboard/lines/optimal?toUserId=%@",self.userId];
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }

            for (NSDictionary *dic in dict[@"data"]) {
                    NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                    if (model.tag_id.intValue == 2) {
                        model.line_content = [NSString stringWithFormat:@"#求freestyle#%@",model.line_content];
                    }else{
                        model.line_content = [NSString stringWithFormat:@"#求配音#%@",model.line_content];
                    }
                   [self.dataArr addObject:model];
                }
        
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 120+[self.dataArr[indexPath.row] contentHeight]-50+21+15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
    cell.index = indexPath.row;
    cell.tcModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)delegateSuccess:(NoticeClockPyModel *)tcModel{
    if (self.dataArr.count) {
        NSInteger num1 = 0;
        for (NoticeClockPyModel *tcM in self.dataArr) {
            if ([tcModel.tcId isEqualToString:tcM.tcId]) {
                if (self.dataArr.count >= num1+1) {
                    [self.dataArr removeObjectAtIndex:num1];
                }
                break;
            }
            num1++;
        }
    }
    [self.tableView reloadData];
}

- (void)recoderSuccess:(NoticeClockPyModel *)tcModel{
    for (NoticeClockPyModel *tcM in self.dataArr) {
        if ([tcModel.tcId isEqualToString:tcM.tcId]) {
            tcM.is_dubbed = tcModel.is_dubbed;
            tcM.dubbing_num = tcModel.dubbing_num;
            break;
        }
    }
}

@end
