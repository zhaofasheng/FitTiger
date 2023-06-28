//
//  NoticeDrawTopicListController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawTopicListController.h"
#import "NoticeNewStyleDrawCell.h"
#import "NoticeDrawViewController.h"
#import "UIImage+Color.h"
@interface NoticeDrawTopicListController ()<NoticeNewDrawEditDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UIImageView *footView;
@property (nonatomic, strong) UIView *buttonV;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) FSCustomButton *choiceBtn;
@end

@implementation NoticeDrawTopicListController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 70+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-70);
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView registerClass:[NoticeNewStyleDrawCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 124+DR_SCREEN_WIDTH-70+15;
    [self requestCount];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,10+NAVIGATION_BAR_HEIGHT, 20, 20)];
    imageView.image = UIImageNamed(@"Image_huatitu");
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+2, 10+NAVIGATION_BAR_HEIGHT, 200, 20)];
    label.text = self.topicName;
    label.font = XGSIXBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:label];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+2,CGRectGetMaxY(label.frame)+6,200, 17)];
    self.numL.font = TWOTEXTFONTSIZE;
    self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [self.view addSubview:self.numL];
    self.needBackGroundView = YES;
    
}

- (void)sendClick{
    if ([NoticeComTools canDraw:[[NoticeSaveModel getUserInfo] created_at]]) {
        NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithWarnTostViewContent:[NSString stringWithFormat:@"绘画功能仅对来到声昔超过24小时的用户开放，当前帐号再过%@就可以使用了",[NoticeComTools canDraw:[[NoticeSaveModel getUserInfo] created_at]]]];
        [pinV showTostView];
        return;
    }
    NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
    NoticeTopicModel *topM = [[NoticeTopicModel alloc] init];
    topM.topic_id = self.topicId;
    topM.topic_name = self.topicName;
    ctl.topicM = topM;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewStyleDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.noPushTopic = YES;
    cell.drawM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)deleteNewDrawSucessWith:(NSInteger)index{
    if (self.dataArr.count-1 < index) {
        return;
    }
    [self.dataArr removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"users/0/artwork?topicName=%@",[self.topicName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"users/0/artwork?topicName=%@&lastId=%@",[self.topicName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/0/artwork?topicName=%@",[self.topicName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
        }

    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
      
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dic];
                if (model.user) {
                    NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.user];
                    model.avatar_url = userM.avatar_url;
                    model.nick_name = userM.nick_name;
                    model.identity_type = userM.identity_type;
                    model.levelName = userM.levelName;
                    model.levelImgName = userM.levelImgName;
                    model.levelImgIconName = userM.levelImgIconName;
                }
                if (model.isSelf) {
                    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
                    model.avatar_url = userM.avatar_url;
                    model.nick_name = userM.nick_name;
                    model.identity_type = userM.identity_type;
                    model.levelName = userM.levelName;
                    model.levelImgName = userM.levelImgName;
                    model.levelImgIconName = userM.levelImgIconName;
                }
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeDrawList *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.drawId;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    __weak NoticeDrawTopicListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestCount];
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (UIImageView *)footView{
    if (!_footView) {
        _footView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
            [_footView addSubview:mbView];
        }
        _footView.image = UIImageNamed(@"Imamzp");
    }
    return _footView;
}

- (void)requestCount{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"topics/0?topicName=%@&topicType=1",[self.topicName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            self.numL.text = [NSString stringWithFormat:@"%@%@幅包含此话题的作品",[NoticeTools getLocalStrWith:@"groupImg.g"],[NSString stringWithFormat:@"%@",dict[@"data"][@"artwork_num"]]];
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
