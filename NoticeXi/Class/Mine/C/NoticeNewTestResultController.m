//
//  NoticeNewTestResultController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewTestResultController.h"
#import "NoticeTestResultCell.h"
#import "NoticeTestFinishView.h"
#import "DRPsychologyViewController.h"
@interface NoticeNewTestResultController ()
@property (nonatomic, strong) NSMutableArray *dicArr;
@property (nonatomic, strong) NSMutableArray *oldDicArr;
@end

@implementation NoticeNewTestResultController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dicArr = [NSMutableArray new];
    self.oldDicArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeTestResultCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    if (!self.userM) {
        self.dataArr = [NoticeTools getPsychologyArrary];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"follow/personalityTest/%@",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                DRLog(@"%@",dict);
                NoticePsyModel *model = [NoticePsyModel mj_objectWithKeyValues:dict[@"data"]];
                for (int i = 0; i < model.result.count; i++) {
                    if (i <= self.dataArr.count) {
                        NoticePsyModel *oldM = self.dataArr[i];
                        NSString *choiceT = model.result[i];
                        if ([choiceT isEqualToString:@"A"]) {
                            oldM.choiceTag = 0;
                        }else if ([choiceT isEqualToString:@"B"]){
                            oldM.choiceTag = 1;
                        }else if ([choiceT isEqualToString:@"C"]){
                            oldM.choiceTag = 2;
                        }else if ([choiceT isEqualToString:@"D"]){
                            oldM.choiceTag = 3;
                        }
                    }
                    NSMutableDictionary *parm = [NSMutableDictionary new];
                    [parm setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"id"];
                    [parm setObject:model.result[i] forKey:@"result"];
                    
                    NSMutableDictionary *parm1 = [NSMutableDictionary new];
                    [parm1 setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"id"];
                    [parm1 setObject:model.result[i] forKey:@"result"];
                    
                    [self.dicArr addObject:parm];
                    [self.oldDicArr addObject:parm1];
                }
                [self.tableView reloadData];
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }

    if (!self.userM) {
        UIButton *reSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-48, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 48, 24)];
        [reSetBtn setTitle:[NoticeTools getLocalStrWith:@"t.update"] forState:UIControlStateNormal];
        reSetBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [reSetBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        reSetBtn.layer.cornerRadius = 12;
        reSetBtn.layer.masksToBounds = YES;
        reSetBtn.layer.borderWidth = 1;
        reSetBtn.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        [self.view addSubview:reSetBtn];
        [reSetBtn addTarget:self action:@selector(reClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIView *titheaderView = [[UIView alloc] initWithFrame:CGRectMake(42, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-62, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        UIImageView *iconImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, (titheaderView.frame.size.height-30)/2, 30, 30)];
        iconImageview.layer.cornerRadius = 15;
        iconImageview.layer.masksToBounds = YES;
        [iconImageview sd_setImageWithURL:[NSURL URLWithString:self.userM.avatar_url]];
        [titheaderView addSubview:iconImageview];
        
        UILabel *nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(39, 0, titheaderView.frame.size.width-39, titheaderView.frame.size.height)];
        nickNameL.font = SIXTEENTEXTFONTSIZE;
        nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        nickNameL.text = [NSString stringWithFormat:@"%@%@",self.userM.nick_name,[NoticeTools getLocalStrWith:@"t.hisdat"]];
        [titheaderView addSubview:nickNameL];
        
        if (!self.dataArr.count) {
            self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height);
            self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy8");
            self.queshenView.titleStr = [NoticeTools getLocalStrWith:@"t.notest"];
            self.tableView.tableFooterView = self.queshenView;
        }
        
        if (![[[NoticeSaveModel getUserInfo] personality_test] boolValue]) {
            UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 50)];
            headerV.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
            [self.view addSubview:headerV];
            
            UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-50, 50)];
            textL.font = FOURTHTEENTEXTFONTSIZE;
            textL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            textL.text = [NoticeTools getLocalStrWith:@"t.younotest"];
            [headerV addSubview:textL];
            
            UIImageView *iamgeV1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
            iamgeV1.image = UIImageNamed(@"Image_testgantanh");
            [headerV addSubview:iamgeV1];
            
            UIImageView *iamgeV2 = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-20, 15, 20, 20)];
            iamgeV2.image = UIImageNamed(@"Image_testinto");
            [headerV addSubview:iamgeV2];
            
            headerV.userInteractionEnabled = YES;
            UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testNowClick)];
            [headerV addGestureRecognizer:headTap];
            self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+50, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
        }
        [self.view addSubview:titheaderView];
    }

    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-44)/2, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
}

- (void)testNowClick{

    DRPsychologyViewController *ctl = [[DRPsychologyViewController alloc] init];
    ctl.isFromMain = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)backToPageAction{
    if (self.userM) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (![[NoticeTools convertToJsonData:self.dicArr] isEqualToString:[NoticeTools convertToJsonData:self.oldDicArr]]) {//进行过更改
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"t.change"] message:nil sureBtn:@"退出" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.save"] right:YES];
        alerView.resultIndex = ^(NSInteger indexs) {
            if (indexs == 2) {
                [weakSelf reClick];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTestResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.userM) {
        cell.noTap = YES;
    }
    cell.testM = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.choiceBlock = ^(NoticePsyModel * _Nonnull choiceM) {
        NSMutableDictionary *parm = weakSelf.dicArr[choiceM.tag.intValue];
        [parm setObject:choiceM.choiceName forKey:@"result"];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticePsyModel *model = self.dataArr[indexPath.row];
    return 68+model.answers.count*60+12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)reClick{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject: [NoticeTools convertToJsonData:self.dicArr] forKey:@"personalityResult"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"follow/personalityTest/result" Accept:@"application/vnd.shengxi.v5.0.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            __weak typeof(self) weakSelf = self;
            NoticeTestFinishView *finishV = [[NoticeTestFinishView alloc] initWithShowUserInfo];
            finishV.hideBlock = ^(BOOL hideToPush) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [finishV showChoiceView];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
