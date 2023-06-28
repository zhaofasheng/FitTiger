//
//  NoticeAreaViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAreaViewController.h"
#import "NoticeAreaCell.h"
#import "NoticeHeaderView.h"
@interface NoticeAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSMutableArray *otherArr;
@end

@implementation NoticeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"area.choice"];
    
    [self.tableView registerClass:[NoticeAreaCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[NoticeHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    self.tableView.rowHeight = 45;
    
    [self requsetData];
}

- (void)requsetData{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"nation" Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict[@"data"][@"hot"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if ([dict[@"data"][@"other"] isEqual:[NSNull null]]) {
                return ;
            }
            
            for (NSDictionary *hotDic in dict[@"data"][@"hot"]) {
                NoticeAreaModel *model = [NoticeAreaModel mj_objectWithKeyValues:hotDic];
                [self.hotArr addObject:model];
            }
            
            for (NSDictionary *otherDic in dict[@"data"][@"other"]) {
                NoticeAreaModel *model = [NoticeAreaModel mj_objectWithKeyValues:otherDic];
                [self.otherArr addObject:model];
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAreaModel *model = nil;
    
    if (indexPath.section == 0) {
        model = self.hotArr[indexPath.row];
    }else{
        model = self.otherArr[indexPath.row];
    }
    
    if (self.adressBlock) {
        self.adressBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.model = self.hotArr[indexPath.row];
    }else{
        cell.model = self.otherArr[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotArr.count;
    }
    return self.otherArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeHeaderView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    headV.mainTitleLabel.text = section == 0 ? [NoticeTools getLocalStrWith:@"area.hot"] : [NoticeTools getLocalStrWith:@"area.otert"];
    return headV;
}

- (NSMutableArray *)otherArr {
    if (!_otherArr) {
        _otherArr = [NSMutableArray new];
    }
    return _otherArr;
}

- (NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray new];
    }
    return _hotArr;
}
@end
