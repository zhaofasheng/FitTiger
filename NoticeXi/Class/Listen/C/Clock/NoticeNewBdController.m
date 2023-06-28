//
//  NoticeNewBdController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewBdController.h"
#import "NoticeClockBdCell.h"
#import "NoticeTcPageController.h"
#import "NoticePyComController.h"
@interface NoticeNewBdController ()

@property (nonatomic, strong) UIView *bestPyV;
@property (nonatomic, strong) UIView *bestTcV;

@property (nonatomic, strong) UIImageView *pyIconImageV;
@property (nonatomic, strong) UILabel *bgL;

@property (nonatomic, strong) UIImageView *tcIconImageV;
@property (nonatomic, strong) UILabel *tcL;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIImageView *markImageView1;
@property (nonatomic, strong) UIImageView *markImageView2;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation NoticeNewBdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-50-NAVIGATION_BAR_HEIGHT);
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 134+57+50)];
    headerView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    self.needBackGroundView = YES;
    
    NSArray *arr = @[[NoticeTools getLocalStrWith:@"py.paiming"],[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"py.tc"]];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60+((DR_SCREEN_WIDTH-40-60*3-80)/2+60)*i,headerView.frame.size.height-50, 60, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        label.text = arr[i];
        [headerView addSubview:label];
    }
    
    [self.tableView registerClass:[NoticeClockBdCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 75;
    
    UILabel *footL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 38)];
    footL.font = ELEVENTEXTFONTSIZE;
    footL.text = [NoticeTools getLocalStrWith:@"py.pmRul"];
    footL.textAlignment = NSTextAlignmentCenter;
    footL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
    self.tableView.tableFooterView = footL;
    
    NSArray *imgArr = @[@"Image_zuijiapiey",@"Image_zuijiataici"];
    for (int i = 0; i < 2; i++) {
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20+(15+(DR_SCREEN_WIDTH-55)/2)*i,0,(DR_SCREEN_WIDTH-55)/2, 134+57)];
        [headerView addSubview:backV];
        backV.hidden = YES;
        backV.userInteractionEnabled = YES;
        if (i == 0) {
            self.bestPyV = backV;
        }else{
            self.bestTcV = backV;
        }
        backV.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTap:)];
        [backV addGestureRecognizer:tap];
        
        UIImageView *iamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 57,(DR_SCREEN_WIDTH-55)/2, 134)];
        [backV addSubview:iamgeV];
        iamgeV.userInteractionEnabled = YES;
        iamgeV.image = UIImageNamed(imgArr[i]);
        
        UIImageView *markImageV = [[UIImageView alloc] initWithFrame:CGRectMake((backV.frame.size.width-20)/2, iamgeV.frame.origin.y-40, 20, 20)];
        markImageV.image = UIImageNamed(@"nImage_huanguan");
        [backV addSubview:markImageV];

        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((backV.frame.size.width-50)/2, CGRectGetMaxY(markImageV.frame)+1, 50, 50)];
        line.layer.cornerRadius = 50/2;
        line.layer.masksToBounds = YES;
        line.backgroundColor = [UIColor colorWithHexString:@"#E6C14D"];
        [backV addSubview:line];
        
        if (i == 0) {
            self.markImageView1 = markImageV;
            self.line1 = line;
        }else{
            self.markImageView2 = markImageV;
            self.line2 = line;
        }
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        iconImageView.layer.cornerRadius = 25;
        iconImageView.image = UIImageNamed(@"noImage_jynohe");
        iconImageView.layer.masksToBounds = YES;
        [line addSubview:iconImageView];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+20, backV.frame.size.width, 22)];
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.font = SIXTEENTEXTFONTSIZE;
        nameL.text = [NoticeTools getLocalStrWith:@"py.zw"];
        nameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backV addSubview:nameL];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameL.frame)+10, backV.frame.size.width, 25)];
        titleL.textColor = [UIColor colorWithHexString:@"#84CAE5"];
        titleL.font = EIGHTEENTEXTFONTSIZE;
        titleL.textAlignment = NSTextAlignmentCenter;
        [backV addSubview:titleL];
        
        if (i == 0) {
            titleL.text = [NoticeTools getLocalStrWith:@"py.bestpy"];
            self.bgL = nameL;
            self.pyIconImageV = iconImageView;
        }else{
            titleL.text = [NoticeTools getLocalStrWith:@"py.besttc"];
            self.tcL = nameL;
            self.tcIconImageV = iconImageView;
        }
    }
    self.dataArr = [NSMutableArray new];
    [self request];
}

- (void)detailTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (!self.dataArr.count) {
        return;
    }
    NoticeClockBdUser *firstM = self.dataArr[0];

    if (tapV.tag == 0) {
        if (!firstM.didding_id.intValue) {
            return;
        }
        NoticePyComController *ctl = [[NoticePyComController alloc] init];
        ctl.pyId = firstM.didding_id;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        if (!firstM.line_id.intValue) {
            return;
        }
        NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
        ctl.tcId = firstM.line_id;
        ctl.tcSendUser = firstM.line_userM;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeClockBdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    if (self.dataArr.count && indexPath.row < self.dataArr.count) {
        cell.bdModel = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)waitMessage{
    if (self.allBd) {
        if ([self.hud.labelText isEqualToString:[NSString stringWithFormat:@"%@ ...",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]]]) {
            self.hud.labelText = [NSString stringWithFormat:@"%@ .",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
        }else if ([self.hud.labelText isEqualToString:[NSString stringWithFormat:@"%@ .",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]]]){
            self.hud.labelText =  [NSString stringWithFormat:@"%@ ..",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
        }else{
            self.hud.labelText =  [NSString stringWithFormat:@"%@ ...",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
        }
    }else{
        if ([self.hud.labelText isEqualToString:[NSString stringWithFormat:@"%@ ...",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]]]) {
            self.hud.labelText = [NSString stringWithFormat:@"%@ .",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
        }else if ([self.hud.labelText isEqualToString:[NSString stringWithFormat:@"%@ .",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]]]){
            self.hud.labelText =  [NSString stringWithFormat:@"%@ ..",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
        }else{
            self.hud.labelText =  [NSString stringWithFormat:@"%@ ...",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
        }
    }
}

- (void)request{
    NSString *url = nil;
    url = @"leaderboard/dubbings?type=day";
    if (self.allBd) {
        url = @"leaderboard/dubbings";
    }

    self.hud =  [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText =self.allBd?  [NSString stringWithFormat:@"%@ ...",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]]:[NSString stringWithFormat:@"%@ ...",[NoticeTools getLocalStrWith:@"py.knowtodaybest"]];
    [self.view addSubview:self.hud];
    [_hud show:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitMessage) userInfo:nil repeats:YES];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.hud removeFromSuperview];
        [self.hud hide:YES];
        [self.timer invalidate];
        self.timer = nil;
        if (success) {
            for (NSDictionary *dic  in dict[@"data"]) {
                NoticeClockBdUser *bdM = [NoticeClockBdUser mj_objectWithKeyValues:dic];
                [self.dataArr addObject:bdM];
            }
            if (self.dataArr.count) {
                NoticeClockBdUser *firstM = self.dataArr[0];
                if (firstM.didding_userM) {
                    self.pyIconImageV.frame = CGRectMake(2, 2, 46, 46);
                    self.pyIconImageV.layer.cornerRadius = 23;
                    self.markImageView1.image = UIImageNamed(@"Image_huanguan");
                    self.bgL.text = firstM.didding_userM.nick_name;
                    [self.pyIconImageV sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:firstM.didding_userM.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
                }
                if (firstM.line_userM) {
                    self.tcIconImageV.frame = CGRectMake(2, 2, 46, 46);
                    self.tcIconImageV.layer.cornerRadius = 23;
                    self.markImageView2.image = UIImageNamed(@"Image_huanguan");
                    self.tcL.text = firstM.line_userM.nick_name;
                    [self.tcIconImageV sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:firstM.line_userM.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
                }
            }
            self.bestTcV.hidden = NO;
            self.bestPyV.hidden = NO;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.hud removeFromSuperview];
        [self.hud hide:YES];
        [self.timer invalidate];
        self.timer = nil;
    }];
}


@end
