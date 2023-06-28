//
//  NoticeSetLikeTopicController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/22.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSetLikeTopicController.h"
#import "NoticeNoticenterModel.h"
#import "NoticeMBSViewController.h"
#import "NoticeTopicViewController.h"
@interface NoticeSetLikeTopicController ()
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, strong) UIButton *topicBack1;
@property (nonatomic, strong) UIButton *topicBack2;
@property (nonatomic, strong) UIButton *topicBack3;
@property (nonatomic, strong) UIButton *topicBtn1;
@property (nonatomic, strong) UIButton *topicBtn2;
@property (nonatomic, strong) UIButton *topicBtn3;
@property (nonatomic, strong) NoticeTopicModel *top1;
@property (nonatomic, strong) NoticeTopicModel *top2;
@property (nonatomic, strong) NoticeTopicModel *top3;
@property (nonatomic, strong) NoticeTopicModel *oldTop1;
@property (nonatomic, strong) NoticeTopicModel *oldTop2;
@property (nonatomic, strong) NoticeTopicModel *oldTop3;
@end

@implementation NoticeSetLikeTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getTextWithSim:@"最喜欢的话题设置" fantText:@"最喜歡的話題設置"];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell1"];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-65*2-40-BOTTOM_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, DR_SCREEN_WIDTH,12)];
    label.font = TWOTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    NSString *str = [NoticeTools isSimpleLau]?@"最喜欢的话题会在个人信息小卡片显示":@"最喜歡的話題會在個人信息小卡片顯示";
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:label];
    self.tableView.tableFooterView = footView;
    CGFloat imgHeight = 305;
    CGFloat imgWidth = 215;
    
    UIImageView *showImgView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-imgWidth)/2, CGRectGetMaxY(label.frame)+20, imgWidth, imgHeight)];
    
    [footView addSubview:showImgView];
    showImgView.image = UIImageNamed(@"Image_setliketopicm");
    
    for (int i = 0; i < 3; i++) {
        UIButton *btnb = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-13-112,25/2, 112, 40)];
        [btnb setBackgroundImage:UIImageNamed(@"Ima_about_bt") forState:UIControlStateNormal];
        
        UIButton *topB = [[UIButton alloc] initWithFrame:btnb.frame];
        [topB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [topB setTitle:GETTEXTWITE(@"sendv.insert") forState:UIControlStateNormal];
        topB.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        topB.tag = i;
        [topB addTarget:self action:@selector(insertTop:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.topicBtn1 = topB;
            self.topicBack1 = btnb;
        }else if (i == 1){
            self.topicBtn2 = topB;
            self.topicBack2 = btnb;
        }else{
            self.topicBtn3 = topB;
            self.topicBack3 = btnb;
        }
    }
    [self requestSet];
    [self requestTopic];
}

- (void)requestSet{
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting/favoriteTopic",[[NoticeSaveModel getUserInfo]user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestTopic{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/favorite/topic",[[NoticeSaveModel getUserInfo]user_id]] Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *model = [NoticeTopicModel mj_objectWithKeyValues:dic];
                if ([model.weight isEqualToString:@"1"]) {
                    self.top1 = model;
                }else if ([model.weight isEqualToString:@"2"]){
                    self.top2 = model;
                }else if ([model.weight isEqualToString:@"3"]){
                    self.top3 = model;
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)insertTop:(UIButton *)button{
    
    if (button.tag == 0) {
        if (self.top1.topic_name && ![self.top1.topic_name isEqualToString:@"null"]) {
            [self deleteTopicWithHeight:@"1" tag:0];
            return;
        }
    }else if (button.tag == 1){
        if (self.top2.topic_name && ![self.top2.topic_name isEqualToString:@"null"]) {
            [self deleteTopicWithHeight:@"2" tag:1];
            return;
        }
    }else{
        if (self.top3.topic_name && ![self.top3.topic_name isEqualToString:@"null"]) {
            [self deleteTopicWithHeight:@"3" tag:2];
            return;
        }
    }
    
    NoticeTopicViewController *ctl = [[NoticeTopicViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.topicBlock = ^(NoticeTopicModel * _Nonnull topic) {
        if (topic.topic_id) {
            [weakSelf setTopiceWithHeight:[NSString stringWithFormat:@"%ld",button.tag+1] topiceId:topic.topic_id topicName:topic.topic_name tag:button.tag];
        }else{
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:topic.topic_name forKey:@"topicName"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    [weakSelf setTopiceWithHeight:[NSString stringWithFormat:@"%ld",button.tag+1] topiceId:topicId topicName:topic.topic_name tag:button.tag];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
        
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)setTopiceWithHeight:(NSString *)height topiceId:(NSString *)topiceId topicName:(NSString *)topiceName tag:(NSInteger)tag{
    if (!topiceId) {
        return;
    }
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:topiceId forKey:@"topicId"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/favorite/topic/weight/%@",[[NoticeSaveModel getUserInfo]user_id],height] Accept:@"application/vnd.shengxi.v3.2+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (tag == 0) {
                self.top1.topic_name = topiceName;
            }else if (tag == 1){
                self.top2.topic_name = topiceName;
            }else{
                self.top3.topic_name = topiceName;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)deleteTopicWithHeight:(NSString *)height tag:(NSInteger)tag{
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/favorite/topic/weight/%@",[[NoticeSaveModel getUserInfo]user_id],height] Accept:@"application/vnd.shengxi.v3.2+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (tag == 0) {
                self.top1.topic_name = nil;
            }else if (tag == 1){
                self.top2.topic_name = nil;
            }else{
                self.top3.topic_name = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (indexPath.row == 0) {
        cell.mainL.text = [NoticeTools isSimpleLau]?@"谁可以看到我设置的话题":@"誰可以看到我設置的話題";
        cell.subL.text = self.noticeM.favorite_topic.integerValue ? ([NoticeTools isSimpleLau]?@"仅限学友":@"僅限学友"):@"所有人";
        cell.mainL.frame = CGRectMake(10, 0,GET_STRWIDTH(cell.mainL.text, 14, 65)+10, 65);
        cell.subImageV.hidden = NO;
    }else{
        if (indexPath.row == 1) {
            [self.topicBack1 removeFromSuperview];
            [cell.contentView addSubview:self.topicBack1];
            [self.topicBtn1 removeFromSuperview];
            [cell.contentView addSubview:self.topicBtn1];
            if (self.top1.topic_name && ![self.top1.topic_name isEqualToString:@"null"]) {
                NSString *str = [NSString stringWithFormat:@"#%@#  x",self.top1.topic_name];
                self.topicBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [self.topicBtn1 setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
                [self.topicBtn1 setTitle:str forState:UIControlStateNormal];
                self.topicBtn1.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(str, 14, 40), 25/2, GET_STRWIDTH(str, 14, 40), 40);
                self.topicBack1.hidden = YES;
            }else{
                self.topicBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.topicBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.topicBtn1 setTitle:GETTEXTWITE(@"sendv.insert") forState:UIControlStateNormal];
                self.topicBtn1.frame = CGRectMake(DR_SCREEN_WIDTH-13-112,25/2, 112, 40);
                self.topicBack1.hidden = NO;
            }
         
        }else if (indexPath.row == 2){
            [self.topicBack2 removeFromSuperview];
            [cell.contentView addSubview:self.topicBack2];
            [self.topicBtn2 removeFromSuperview];
            [cell.contentView addSubview:self.topicBtn2];
            
            if (self.top2.topic_name && ![self.top2.topic_name isEqualToString:@"null"]) {
                NSString *str = [NSString stringWithFormat:@"#%@#  x",self.top2.topic_name];
                self.topicBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [self.topicBtn2 setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
                [self.topicBtn2 setTitle:str forState:UIControlStateNormal];
                self.topicBtn2.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(str, 14, 40), 25/2, GET_STRWIDTH(str, 14, 40), 40);
                self.topicBack2.hidden = YES;
            }else{
                self.topicBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.topicBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.topicBtn2 setTitle:GETTEXTWITE(@"sendv.insert") forState:UIControlStateNormal];
                self.topicBtn2.frame = CGRectMake(DR_SCREEN_WIDTH-13-112,25/2, 112, 40);
                self.topicBack2.hidden = NO;
            }
        }else{
            [self.topicBack3 removeFromSuperview];
            [cell.contentView addSubview:self.topicBack3];
            [self.topicBtn3 removeFromSuperview];
            [cell.contentView addSubview:self.topicBtn3];
            if (self.top3.topic_name && ![self.top3.topic_name isEqualToString:@"null"]) {
                NSString *str = [NSString stringWithFormat:@"#%@#  x",self.top3.topic_name];
                self.topicBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [self.topicBtn3 setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
                [self.topicBtn3 setTitle:str forState:UIControlStateNormal];
                self.topicBtn3.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(str, 14, 40), 25/2, GET_STRWIDTH(str, 14, 40), 40);
                self.topicBack3.hidden = YES;
            }else{
                self.topicBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.topicBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.topicBtn3 setTitle:GETTEXTWITE(@"sendv.insert") forState:UIControlStateNormal];
                self.topicBtn3.frame = CGRectMake(DR_SCREEN_WIDTH-13-112,25/2, 112, 40);
                self.topicBack3.hidden = NO;
            }
        }
       
        cell.subImageV.hidden = YES;
        cell.mainL.text = [NoticeTools isSimpleLau]?[NSString stringWithFormat:@"最喜欢的话题%ld",indexPath.row]:[NSString stringWithFormat:@"最喜歡的話題%ld",indexPath.row];
    }
    cell.line.hidden = indexPath.row == 3?YES:NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeMBSViewController *ctl = [[NoticeMBSViewController alloc] init];
        ctl.isTopic = YES;
        ctl.type = 3;
        ctl.isAll = !self.noticeM.favorite_topic.integerValue;
        __weak typeof(self) weakSelf = self;
        ctl.openBlock = ^(BOOL open) {
           
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:open?@"0":@"1" forKey:@"favoriteTopic"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    if (open) {
                        weakSelf.noticeM.favorite_topic = @"0";
                    }else{
                        weakSelf.noticeM.favorite_topic = @"1";
                    }
                    [weakSelf.tableView reloadData];
                }else{
                    [weakSelf showToastWithText:dict[@"msg"]];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (NoticeTopicModel *)top1{
    if (!_top1) {
        _top1 = [[NoticeTopicModel alloc] init];
    }
    return _top1;
}
- (NoticeTopicModel *)top2{
    if (!_top2) {
        _top2 = [[NoticeTopicModel alloc] init];
    }
    return _top2;
}
- (NoticeTopicModel *)top3{
    if (!_top3) {
        _top3 = [[NoticeTopicModel alloc] init];
    }
    return _top3;
}
@end
