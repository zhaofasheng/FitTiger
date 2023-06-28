//
//  NoticeNewLeadController.m
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewLeadController.h"
#import "NoticeAdMainCell.h"
#import "NoticePickerShowController.h"
#import "NoticeNewUserOrderController.h"

#import "NoticeXi-Swift.h"


@interface NoticeNewLeadController ()

@end

@implementation NoticeNewLeadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.needBackGroundView = NO;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 102;
    [self.tableView registerClass:[NoticeAdMainCell class] forCellReuseIdentifier:@"cell"];
    
    [self request];

}

- (void)request{
    self.dataArr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"infoLattice/list?platformId=2&appVersion=%@",[NoticeSaveModel getVersion]] Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeWriteRecodModel *topicM = [NoticeWriteRecodModel mj_objectWithKeyValues:dic];
                if (topicM.show_type.intValue != 3) {
                    [self.dataArr addObject:topicM];
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeWriteRecodModel *model = self.dataArr[indexPath.row];
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
   
    if (model.show_type.intValue == 2) {
        NoticeNewUserOrderController *ctl = [[NoticeNewUserOrderController alloc] init];
        [self.navigationController pushViewController:ctl animated:NO];
    }else if(model.show_type.intValue == 1){
        NoticePickerShowController *ctl = [[NoticePickerShowController alloc] init];
        ctl.imgUrl = model.content;
        [self.navigationController pushViewController:ctl animated:NO];
    }else if(model.show_type.intValue == 3){
        NoticeLeaderController *ctl = [[NoticeLeaderController alloc] init];
        [self.navigationController pushViewController:ctl animated:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAdMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


@end
