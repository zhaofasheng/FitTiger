//
//  NoticeQuestionDetailController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeQuestionDetailController.h"
#import "NoticeQuestionDetailCell.h"
@interface NoticeQuestionDetailController ()
@property (nonatomic, strong) UIButton *biaoBtn;
@end

@implementation NoticeQuestionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"反馈详情";
    [self.tableView registerClass:[NoticeQuestionDetailCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView reloadData];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44-40);
    
    self.biaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44-40, DR_SCREEN_WIDTH-90, 44)];
    self.biaoBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    self.biaoBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.biaoBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.biaoBtn.layer.cornerRadius = 22;
    self.biaoBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.biaoBtn];
    [self.biaoBtn addTarget:self action:@selector(biaoClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.questionM.sign.intValue) {
        [self.biaoBtn setTitle:@"  已标记" forState:UIControlStateNormal];
        [self.biaoBtn setImage:UIImageNamed(@"Image_pyshoucangy") forState:UIControlStateNormal];
    }else{
        [self.biaoBtn setTitle:@"  标记" forState:UIControlStateNormal];
        [self.biaoBtn setImage:UIImageNamed(@"Image_pyshoucang") forState:UIControlStateNormal];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/feedback/%@?confirmPasswd=%@",self.questionM.questionId,self.managerCode] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)biaoClick{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.questionM.sign.intValue?@"0":@"1" forKey:@"sign"];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/feedback/%@",self.questionM.questionId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.questionM.sign = self.questionM.sign.intValue?@"0":@"1";
            if (self.questionM.sign.intValue) {
                [self.biaoBtn setTitle:@"  已标记" forState:UIControlStateNormal];
                [self.biaoBtn setImage:UIImageNamed(@"Image_pyshoucangy") forState:UIControlStateNormal];
            }else{
                [self.biaoBtn setTitle:@"  标记" forState:UIControlStateNormal];
                [self.biaoBtn setImage:UIImageNamed(@"Image_pyshoucang") forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105+GET_STRHEIGHT(self.questionM.describe, 13, DR_SCREEN_WIDTH-30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeQuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.questionM = self.questionM;
    return cell;
}
@end
