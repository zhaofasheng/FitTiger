//
//  NoticeListenPriSetController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/27.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeListenPriSetController.h"
#import "NoticeMoveBookSonPrivayController.h"
#import "NoticePrivacySetViewController.h"
#import "NoticeNoticenterModel.h"
@interface NoticeListenPriSetController ()
@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@end

@implementation NoticeListenPriSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getTextWithSim:@"俱乐部隐私设置" fantText:@"俱乐部隱私設置"];
    self.view.backgroundColor = GetColorWithName(VlistColor);
    self.titArr = @[[NoticeTools getTextWithSim:@"电影社" fantText:@"電影社"],[NoticeTools getTextWithSim:@"读书社" fantText:@"讀書社"],[NoticeTools getTextWithSim:@"音乐社" fantText:@"音乐社"],[NoticeTools getTextWithSim:@"话题搜索结果是否显示我的心情" fantText:@"話題搜索結果是否顯示我的心情"]];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0,65, 25);
    [btn1 setTitle:@" 开发者" forState:UIControlStateNormal];
    [btn1 setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_listenkf_b":@"Image_listenkf_y") forState:UIControlStateNormal];
    [btn1 setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    btn1.titleLabel.font = THRETEENTEXTFONTSIZE;
    [btn1 addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    [self requestData];
}

- (void)kefuClick{
    [NoticeComTools connectXiaoer];
}

- (void)requestData{

    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.noticeM.display_same_topic = self.noticeM.display_same_topic?self.noticeM.display_same_topic:@"1";
            [self.tableView reloadData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.row==0){
        NoticeMoveBookSonPrivayController *ctl = [[NoticeMoveBookSonPrivayController alloc] init];
        ctl.type = 0;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row==1){
        NoticeMoveBookSonPrivayController *ctl = [[NoticeMoveBookSonPrivayController alloc] init];
        ctl.type = 1;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row==2){
        NoticeMoveBookSonPrivayController *ctl = [[NoticeMoveBookSonPrivayController alloc] init];
        ctl.type = 2;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 3){
        NoticePrivacySetViewController *ctl = [[NoticePrivacySetViewController alloc] init];
        ctl.titArr = @[[NoticeTools isSimpleLau]?@"显示":@"顯示",[NoticeTools isSimpleLau]?@"隐藏":@"隱藏"];
        ctl.headerTitle = [NoticeTools isSimpleLau]?@"俱乐部搜索话题时显示我的同话题心情":@"俱乐部搜索話題時顯示我的同話題心情";
        ctl.keyString = @"displaySameTopic";
        ctl.boolStr = self.noticeM.display_same_topic;
        ctl.tag = 5;
        __weak typeof(self) weakSelf = self;
        ctl.openBlock = ^(BOOL open) {
            if (open) {
                weakSelf.noticeM.display_same_topic = @"1";
            }else{
                weakSelf.noticeM.display_same_topic = @"0";
            }
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    cell.subL.text = @"";
    if (indexPath.row == 4) {
        cell.subL.text = self.noticeM.displayName;
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return  self.titArr.count;
}

@end
