//
//  NoticeSearchBookResultController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchBookResultController.h"
#import "NoticeAllHotCell.h"
#import "NoticeNoDataView.h"
#import "NoticeBookDetailController.h"
#import "NoticeSearFootMovie.h"
#import "DDHAttributedMode.h"
#import "NoticeHandAddBookController.h"
#import "NoticeScanBookController.h"
@interface NoticeSearchBookResultController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeSearFootMovie *searFootView;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, strong) UITextField *topicField;
@end

@implementation NoticeSearchBookResultController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, (STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-36)/2), DR_SCREEN_WIDTH-67-20, 36)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    backView.layer.cornerRadius = 18;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(40,0,DR_SCREEN_WIDTH-67-20-40, 36)];
    self.topicField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.topicField.font = SIXTEENTEXTFONTSIZE;
    self.topicField.text = self.nameT;
    self.topicField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.topicField.returnKeyType = UIReturnKeySearch;
    self.topicField.enabled = YES;
    self.topicField.delegate = self;
    self.topicField.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:self.topicField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-67, STATUS_BAR_HEIGHT, 67, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0,-20);
    [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(10,8,20, 20)];
    imageViewPwd.image= UIImageNamed(@"Imagesbt");
    [backView addSubview:imageViewPwd];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 10)];
    self.tableView.tableHeaderView = headerV;

    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeAllHotCell class] forCellReuseIdentifier:@"hotCell"];
    self.tableView.rowHeight = 125;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    [self.footView.actionButton addTarget:self action:@selector(sxClick) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!textField.text.length) {
        return YES;
    }
    self.name = [textField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}


- (void)sxClick{
    NoticeHandAddBookController *ctl = [[NoticeHandAddBookController alloc] init];
     [self.navigationController pushViewController:ctl animated:YES];

}

- (void)callKf{
    [NoticeComTools connectXiaoer];

}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
    ctl.book = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAllHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    cell.book = self.dataArr[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeSearchBookResultController *ctl = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        ctl.isDown = NO;
        [ctl request];
    }];
}
- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url =[NSString stringWithFormat:@"resources/2/search/%@",self.name];
    }else{
        url = [NSString stringWithFormat:@"resources/2/search/%@?lastId=%@",self.name,self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeBook *model = [NoticeBook mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                if (self.dataArr.count) {
                    self.canLoad = YES;
                }
            }
            
            if (self.dataArr.count) {
                NoticeBook *book = self.dataArr[self.dataArr.count-1];
                self.lastId = book.bookId;
            }
            
            self.tableView.tableFooterView = self.dataArr.count ? self.searFootView : self.footView;
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NoticeNoDataView *)footView{
    if (!_footView) {
        _footView =  [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];

        _footView.titleImageV.image = UIImageNamed(@"Image_quesy5");
        _footView.titleStr = [NoticeTools getLocalStrWith:@"book.nosearchd"];
        _footView.actionButton.frame = CGRectMake((DR_SCREEN_WIDTH-240)/2,_footView.frame.size.height-56-40-42-30,240, 56);
        [_footView.actionButton setBackgroundImage:UIImageNamed(@"img_buttonback") forState:UIControlStateNormal];
        _footView.actionButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        _footView.actionButton.layer.cornerRadius = 56/2;
        _footView.actionButton.layer.masksToBounds = YES;
        [_footView.actionButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_footView.actionButton setTitle:[NoticeTools getLocalStrWith:@"movie.shoudongaddbook"] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_footView.actionButton.frame)+20, DR_SCREEN_WIDTH, 42)];
        label.textColor = GetColorWithName(VDarkTextColor);
        label.font = TWOTEXTFONTSIZE;
        label.text =[NoticeTools getLocalStrWith:@"movie.fankuitogf"];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callKf)];
        [label addGestureRecognizer:tap];
        [_footView addSubview:label];
    }
    return _footView;
}

- (void)sacnClick{
    NoticeScanBookController *ctl = [[NoticeScanBookController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NoticeSearFootMovie *)searFootView{
    if (!_searFootView) {
        _searFootView = [[NoticeSearFootMovie alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 108+BOTTOM_HEIGHT+15)];
        _searFootView.type = 1;
    }
    return _searFootView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 5;
    
    if(y > h + reload_distance) {
        if (self.canLoad) {
            self.canLoad = NO;
            [self.tableView.mj_footer beginRefreshing];
        }
        
    }
}
@end
