//
//  NoticeFindBookFriendController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFindBookFriendController.h"
#import "NoticeFindSameCell.h"
#import "NoticeSameLikeBookController.h"
#import "NoticeNoDataView.h"
@interface NoticeFindBookFriendController ()
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation NoticeFindBookFriendController
{
    UILabel *_label;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?@"找书友":@"找書友";
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44);
    self.tableView.rowHeight = 54;
    [self.tableView registerClass:[NoticeFindSameCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-44-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,44)];
    view.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,-5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
    view.backgroundColor = GetColorWithName(VBackColor);
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    _backView = view;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-44-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    label.text = [NoticeTools isSimpleLau]?@"记录你读过的书，帮你发现更多书友":@"妳讀過的書，幫妳發現更多書友";
    _label = label;
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    self.dataArr = [NSMutableArray new];
    [self requestData];
    
    [self.view bringSubviewToFront:self.line];
}

- (void)requestData{
    
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"hobby/common/2" Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFindSame *model = [NoticeFindSame mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                
            }
            if (!self.dataArr.count) {
                self.tableView.tableFooterView = self.footView;
                self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
                
            }else{
                self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44);
                self.tableView.tableFooterView = nil;
                
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSameLikeBookController *ctl = [[NoticeSameLikeBookController alloc] init];
    NoticeFindSame *model = self.dataArr[indexPath.row];
    ctl.name = model.nick_name;
    ctl.withUserId = model.userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeFindSameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isBook = YES;
    cell.sameModel = self.dataArr[indexPath.row];
    
    if (indexPath.row == self.dataArr.count-1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NoticeNoDataView *)footView{
    if (!_footView) {//
        _footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        _footView.titleImageV.image = UIImageNamed(@"img_nobook_list");
        _footView.titleImageV.frame = CGRectMake((DR_SCREEN_WIDTH-80)/2, 150,110, 58);
        _footView.backgroundColor = GetColorWithName(VBackColor);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:GETTEXTWITE(@"listen.likesamebook")];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [GETTEXTWITE(@"listen.likesamebook") length])];
        _footView.titleL.attributedText = attributedString;
        _footView.titleL.textAlignment = NSTextAlignmentCenter;
        _footView.titleL.frame = CGRectMake(35, CGRectGetMaxY(_footView.titleImageV.frame)+61, DR_SCREEN_WIDTH-70, GET_STRHEIGHT(GETTEXTWITE(@"listen.likesamebook"), 15, DR_SCREEN_WIDTH-70)+20);
        _footView.actionButton.hidden = YES;
        
    }
    return _footView;
}


@end
