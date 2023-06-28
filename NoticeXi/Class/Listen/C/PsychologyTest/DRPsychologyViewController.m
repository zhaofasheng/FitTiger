//
//  DRPsychologyViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/21.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "DRPsychologyViewController.h"
#import "DRPsyCell.h"
#import "DDHAttributedMode.h"
#import "FSCustomButton.h"
#import "NoticeAllPersonlity.h"
#import "NoticeVideoViewController.h"
#import "NoticeTestResultViewController.h"
#import "NoticeTestFinishView.h"
@interface DRPsychologyViewController ()<NoticeQuestionDelegate>

@property (nonatomic, strong) NoticePsyModel *curretnModel;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *dicArr;
@property (nonatomic, assign) BOOL needAam;
@property (nonatomic, assign) NSInteger currentTag;
@end

@implementation DRPsychologyViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isFromMain) {
        //禁用右滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"test.title"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    

    self.tableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    
    self.tableView.frame = CGRectMake(0, 30, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT < 667 ? (446-80): 446);
    [self.tableView registerClass:[DRPsyCell class] forCellReuseIdentifier:@"psyCell"];
    self.tableView.rowHeight = DR_SCREEN_WIDTH;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollEnabled = NO;
    self.dataArr = [NoticeTools getPsychologyArrary];
    
    if (self.dataArr.count) {
        self.currentTag = 0;
       self.curretnModel = self.dataArr[0];
    }
    
    self.dicArr = [NSMutableArray new];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-170)/2, CGRectGetMaxY(self.tableView.frame)+(DR_SCREEN_HEIGHT < 667 ? 30 : 40), 170, DR_SCREEN_HEIGHT < 667 ? 40 : 50)];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [nextBtn setTitle:[NoticeTools getLocalStrWith:@"test.next"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = nextBtn.frame.size.height/2;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextQuextionClick) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn = nextBtn;
    [self.view addSubview:nextBtn];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)closeClick{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:GETTEXTWITE(@"listen.suretc") message:GETTEXTWITE(@"listen.tcbaoc") sureBtn:GETTEXTWITE(@"listen.yes") cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            if (weakSelf.isFromOpen) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLEFROMOPENRNOTICATION" object:nil];
                return ;
            }else if (weakSelf.isFromStart){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
    };
    [alerView showXLAlertView];
}

- (void)nextQuextionClick{
    
    if (!(self.curretnModel.choiceTag >= 0 && self.curretnModel.choiceTag <= (self.curretnModel.answers.count-1))) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"test.choice"]];
        return;
    }
    
    if (self.curretnModel.tag.integerValue < self.dataArr.count) {
        if (self.dicArr.count < self.dataArr.count) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:[NSString stringWithFormat:@"%d",self.curretnModel.tag.intValue+1] forKey:@"id"];
            [parm setObject:self.curretnModel.choiceName forKey:@"result"];
            [self.dicArr addObject:parm];
        }
        self.currentTag++;
        DRLog(@"%ld",self.dicArr.count);
    }
    
    if (self.curretnModel.tag.integerValue < self.dataArr.count-1) {
        self.curretnModel = self.dataArr[self.currentTag];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.curretnModel.tag.integerValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    if (self.curretnModel.tag.integerValue == self.dataArr.count-1) {
        [_nextBtn setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
        if (self.dicArr.count == 14) {
            [self showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject: [NoticeTools convertToJsonData:self.dicArr] forKey:@"personalityResult"];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"follow/personalityTest/result" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    if (self.isFromMain) {
                        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
                            if (success) {
                                __weak typeof(self) weakSelf = self;
                                NoticeTestFinishView *finishV = [[NoticeTestFinishView alloc] initWithShowUserInfo];
                                finishV.hideBlock = ^(BOOL hideToPush) {
                                    NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                                    [NoticeSaveModel saveUserInfo:userIn];
                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                };
                                [finishV showChoiceView];
                            }
                        } fail:^(NSError *error) {
                        }];
                    }else{
                        if (!self.isReg) {
                            [self.navigationController popViewControllerAnimated:YES];
                            return;
                        }
                        __weak typeof(self) weakSelf = self;
                        NoticeTestFinishView *finishV = [[NoticeTestFinishView alloc] initWithShowUserInfo];
                        finishV.hideBlock = ^(BOOL hideToPush) {
                            [weakSelf showHUD];
                            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
                                [weakSelf hideHUD];
                                if (success2) {
                                    NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                                    [NoticeSaveModel saveUserInfo:userIn];
                                    //执行引导页
                                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                                    //上传成功，执行引导页
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                                }
                            } fail:^(NSError *error) {
                                [weakSelf hideHUD];
                            }];
                        };
                        [finishV showChoiceView];
                    }
                }
                [self hideHUD];
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
        }
    }
}

- (void)choiceModel:(NoticePsyModel *)model{
    self.needAam = NO;
    [self.tableView reloadData];
    [self nextQuextionClick];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DRPsyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"psyCell"];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.psyM = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.needAam) {
        return;
    }
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 1);//渐变
    transform = CATransform3DTranslate(transform, -200, 0, 0);//左边水平移动
    //transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    
    cell.layer.transform = transform;
    cell.layer.opacity = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}

@end
