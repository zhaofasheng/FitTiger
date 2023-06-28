//
//  NoticeChoiceVoiceStatusController.m
//  NoticeXi
//
//  Created by li lei on 2022/1/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceVoiceStatusController.h"
#import "NoticeChoiceVoiceStatusCell.h"
@interface NoticeChoiceVoiceStatusController ()
@property (nonatomic, strong) UIImageView *subImageView;
@end

@implementation NoticeChoiceVoiceStatusController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UILabel *backBtn = [[UILabel alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT,60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    backBtn.text = [NoticeTools getLocalStrWith:@"main.cancel"];
    backBtn.textColor = [UIColor colorWithHexString:@"#25262E"];
    backBtn.font = SIXTEENTEXTFONTSIZE;
    backBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
    [backBtn addGestureRecognizer:backTap];
    [self.view addSubview:backBtn];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-120, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = [NoticeTools getLocalStrWith:@"n.kjfanw"];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+30, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeChoiceVoiceStatusCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.needHideNavBar = YES;
    
    self.tableView.rowHeight = 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typeBlock) {
        self.typeBlock(indexPath.row);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChoiceVoiceStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.subImageV.hidden = YES;
    if (indexPath.row == self.type) {
        cell.subImageV.hidden = NO;
    }
    if (indexPath.row < 2) {
        cell.mainL.frame = CGRectMake(20, 10, DR_SCREEN_WIDTH-40, 20);
        if (indexPath.row == 0) {
            cell.mainL.text = [NoticeTools getLocalStrWith:@"n.open"];
            cell.subL.text = [NoticeTools getLocalStrWith:@"n.alljian"];
        }else{
            cell.mainL.text = [NoticeTools getLocalStrWith:@"n.tpkjian"];
            cell.subL.text = [NoticeTools getLocalStrWith:@"n.huxiangkejian"];
        }
    }else{
        cell.mainL.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 58);
        cell.subL.text = @"";
        cell.mainL.text = [NoticeTools getLocalStrWith:@"n.onlyself"];
    }

    return cell;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
@end
