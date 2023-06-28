//
//  NoticeTestResultViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/25.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTestResultViewController.h"
#import "NoticeReTestViewController.h"
#import "DDHAttributedMode.h"
#import "NoticePersonalityCell.h"
#import "NoticeAllPersonlity.h"
#import "NoticeLyCell.h"
#import "NoticeTestLy.h"
#import "YYImageCoder.h"
#import "NoticeNowViewController.h"
#import "UIImage+Color.h"
@interface NoticeTestResultViewController ()<NoticePersonlityDelegate,NoticeLYDELegate,UIGestureRecognizerDelegate,NoticeDeleteLiuYanDelegate>
@property (nonatomic, strong) NoticePersonality *personality;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NSMutableArray *lyArr;
@property (nonatomic, strong) NoticeTestLy *pipeiBackView;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL hasRfreshWeb;
@property (nonatomic, assign) BOOL canLoad;
@end

@implementation NoticeTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.lyArr = [NSMutableArray new];
    self.page = 1;
    self.navigationItem.title = GETTEXTWITE(@"listen.ccjieguo");
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    if ([NoticeTools isWhiteTheme]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToPageAction)];
    }else{
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 22, 44);
        [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 83)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = XGTwentyTwoBoldFontSize;
    
    _titleL = label;
    if (self.isAll) {
        label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#ece02c":@"#ae9c58"];
        label.text = self.name;
    }else{
        NSString *str = [NoticeTools isSimpleLau] ? @"你是" : @"妳是";
        NSString *allStr = [NSString stringWithFormat:@"%@%@",str,self.name];
        label.textColor = GetColorWithName(VMainThumeColor);
        label.text = allStr;
    }

    [self.view addSubview:label];
    self.tableView.tableHeaderView = label;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 10)];
    line.backgroundColor = GetColorWithName(VBigLineColor);
    [self.view addSubview:line];
    
    self.tableView.frame = CGRectMake(0,10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-10);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view bringSubviewToFront:self.tableView];
    [self.tableView registerClass:[NoticePersonalityCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeLyCell class] forCellReuseIdentifier:@"cell2"];
    
    [self requestInfo];
 
    [self createRefesh];
    self.isDown = YES;
    [self requestLy];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_pipeiBackView.textView resignFirstResponder];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFromShake || self.isFromStart) {
        //禁用右滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)backToPageAction{
    if (self.isFromShake) {
        __block UIViewController *pushVC;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NoticeNowViewController class]]) {//返回到指定界面
                pushVC = obj;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HASTESTNOTICATION" object:nil];
            }
        }];
        if (pushVC) {
            [self.navigationController popToViewController:pushVC animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return;
    }
    if (self.isFromStart) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    if (self.isOpen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLEFROMOPENRNOTICATION" object:nil];
        return ;
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)shareClick{
    if (!self.personality) {
        return;
    }
    if (!self.personality.img_url || [[self.personality.img_url substringFromIndex:self.personality.img_url.length-1] isEqualToString:@"/"]) {
        [self showToastWithText:@"图片下载失败"];
        return;
    }
 
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    [[SDWebImageDownloader sharedDownloader]  downloadImageWithURL:[NSURL URLWithString:self.personality.img_url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        hud.labelText = [NSString stringWithFormat:@"%.f%%",(CGFloat)receivedSize/expectedSize*100];
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            [image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                [hud hide:YES];
                [weakSelf showToastWithText:@"截图已保存到手机相册"];
            }];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 108;
    }
    return self.lyArr.count ? 0 : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,108)];
        view.backgroundColor = GetColorWithName(VlistColor);
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake((DR_SCREEN_WIDTH-335)/2,18,335, 72);
        [backButton setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"share_test_btnback":@"share_test_btnbacky") forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, backButton.frame.size.width, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FIFTHTEENTEXTFONTSIZE;
        label.textColor = GetColorWithName(VMainThumeWhiteColor);
        label.text = [NoticeTools isSimpleLau]?@"生成截图":@"生成截圖";
        [backButton addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame)+10, backButton.frame.size.width, 15)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = TWOTEXTFONTSIZE;
        label1.textColor = GetColorWithName(VMainThumeWhiteColor);
        label1.text = [NoticeTools isSimpleLau]?@"分享给更多人":@"分享給更多人";
        [backButton addSubview:label1];
        return view;
    }
    if (self.lyArr.count) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, view.frame.size.height)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFCAE"];
    [view addSubview:backView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,backView.frame.size.width-40,46)];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.numberOfLines = 0;
    label.text = self.isAll ? GETTEXTWITE(@"tt.nly2") : GETTEXTWITE(@"tt.nly1");
    [backView addSubview:label];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 38+15+12+10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 89)];
        view.backgroundColor =  GetColorWithName(VBackColor);

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, view.frame.size.width, 24)];
        label.textColor = GetColorWithName(VMainThumeColor);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = XGTwentyFifBoldFontSize;
        label.text = [NSString stringWithFormat:@"%@留言板",self.personality.personality_title];
        [view addSubview:label];
        
        UILabel *otherL1 = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(label.frame)+15,DR_SCREEN_WIDTH,30)];
        otherL1.backgroundColor = GetColorWithName(VBackColor);
        [view addSubview:otherL1];
        
        NSString *lyStr = [NoticeTools isSimpleLau]?@"给他们留言":@"給他們留言";
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(DR_SCREEN_WIDTH-25-105, CGRectGetMaxY(label.frame)+15,105, 30);
        backButton.titleLabel.font = XGTWOBoldFontSize;
        backButton.backgroundColor = GetColorWithName(VlistColor);
        backButton.layer.cornerRadius = 15;
        backButton.layer.masksToBounds = YES;
        [backButton setTitleColor:GetColorWithName(VMainTextColor)  forState:UIControlStateNormal];
        [backButton setTitle:self.isAll? lyStr: GETTEXTWITE(@"tt.ly") forState:UIControlStateNormal];
        [view addSubview:backButton];
        [backButton addTarget:self action:@selector(lyClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.isAll) {
            NSString *hasWord = [NoticeTools isSimpleLau]?@"有什么话想对":@"有什麽話想對";
            NSString *sayWord = [NoticeTools isSimpleLau]?@"们说?":@"們說?";
            NSString *otherStr = [NSString stringWithFormat:@"%@%@%@",hasWord,self.personality.personality_title,sayWord];
            UILabel *otherL = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(label.frame)+15,165,30)];
            otherL.font = TWOTEXTFONTSIZE;
            otherL.textColor = GetColorWithName(VMainTextColor);
            otherL.backgroundColor = GetColorWithName(VBackColor);
            otherL.text = otherStr;
            [view addSubview:otherL];
        }
        return view;
    }
    return nil;
}

//留言
- (void)lyClick{
    [self.navigationController.view addSubview:self.pipeiBackView];
    [self.pipeiBackView.textView becomeFirstResponder];
}

//删除留言
- (void)deleteLiuYanWith:(NSInteger)index{
    __weak typeof(self) weakSelf = self;
    NoticeTestLyModel *model = self.lyArr[index];
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定要删除留言吗？" message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index1) {
        if (index1 == 1) {
   
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"messageCover/1/%@/%@",weakSelf.personalityId,model.lyId] Accept:@"application/vnd.shengxi.v3.0+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [weakSelf.lyArr removeObjectAtIndex:index];
                    [weakSelf.tableView reloadData];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 206+(self.personality.isAll ? self.personality.webHeight : 280);
    }
    if (indexPath.section == 1 && self.lyArr.count) {
        NoticeTestLyModel *model = self.lyArr[indexPath.row];
        return (model.cellHeight > 20 ? (model.cellHeight-10+69) : 69)+10+([model.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? 30 : 0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NoticePersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
      
        if (self.personality) {
            cell.personality = self.personality;
        }
        if (self.dataArr.count) {
            cell.dataArr = self.dataArr;
        }
        self.webView = cell.webView;
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.contentView.backgroundColor = cell.backgroundColor;
        cell.delegate = self;
        if (!self.hasRfreshWeb) {
            self.hasRfreshWeb = YES;
            self.personality.hasLoad = self.hasRfreshWeb;
        }
        return cell;
    }else{
        NoticeLyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.index = indexPath.row;
        cell.isOpen = self.isOpen;
        cell.delegate = self;
        cell.lyModel = self.lyArr[indexPath.row];
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  section == 0 ? 1 : self.lyArr.count;
}

- (void)lookAllPersonlityDescDelegate{
    if (self.personality) {
        self.personality.isAll = !self.personality.isAll;
        [self.tableView reloadData];
    }
}

- (void)requestInfo{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"personalityRole/%@",self.personalityId] Accept:@"application/vnd.shengxi.v3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
 
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAllPersonlity *per = [NoticeAllPersonlity mj_objectWithKeyValues:dic];
                [self.dataArr addObject:per];
            }
        }
        [self requestWeb];
    } fail:^(NSError *error) {
        [self requestWeb];
    }];
}

- (void)requestWeb{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"personality/%@",self.personalityId] Accept:@"application/vnd.shengxi.v3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            self.personality = [NoticePersonality mj_objectWithKeyValues:dict[@"data"]];
            self.personality.allDesc = [NSString stringWithFormat:@"%@\n\n%@",self.personality.personality_feature,self.personality.personality_desc_long];
            
            if (self.isAll) {
                self->_titleL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#ece02c":@"#ae9c58"];
                self->_titleL.text = self.personality.personality_title;
            }else{
                self->_titleL.textColor = GetColorWithName(VMainThumeColor);
                NSString *str = [NoticeTools isSimpleLau] ? @"你是" : @"妳是";
                NSString *allStr = [NSString stringWithFormat:@"%@%@",str,self.personality.personality_title];
                self->_titleL.text = allStr;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (NoticeTestLy *)pipeiBackView{
    if (!_pipeiBackView ) {
        _pipeiBackView = [[NoticeTestLy alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _pipeiBackView.tostController = self;
        _pipeiBackView.delegate = self;
        [_pipeiBackView.sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pipeiBackView;
}

- (void)liuyan{
    if (!self.pipeiBackView.textView.text.length) {
        return;
    }
    
    [self sendClick];
}

- (void)sendClick{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.pipeiBackView.textView.text.length > 100) {
        self.pipeiBackView.textView.text = [self.pipeiBackView.textView.text substringToIndex:100];
    }
    [parm setObject:self.pipeiBackView.textView.text forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messageCover/1/%@",self.personalityId] Accept:@"application/vnd.shengxi.v3.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.isTongzu = YES;
            self.pipeiBackView.sendBtn.enabled =  NO;
            self.pipeiBackView.sendBtn.backgroundColor = [UIColor colorWithHexString: @"#CCCCCC"];
            self.pipeiBackView.numL.text = @"0/100";
            [self.pipeiBackView removeFromSuperview];
            self.pipeiBackView.textView.text = @"";
            [self.pipeiBackView.textView resignFirstResponder];
            self.page = 1;
            self.isDown = YES;
            [self requestLy];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestLy{
    
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"messageCover/1/%@?page=1",self.personalityId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messageCover/1/%@?page=%ld&lastId=%@",self.personalityId,(long)self.page,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messageCover/1/%@?page=%ld",self.personalityId,(long)self.page];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                [self.lyArr removeAllObjects];
                self.isDown = NO;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTestLyModel *model = [NoticeTestLyModel mj_objectWithKeyValues:dic];
                [self.lyArr addObject:model];
            }
            self.canLoad = YES;
            if (self.lyArr.count) {
                NoticeTestLyModel *lastM = self.lyArr[self.lyArr.count-1];
                self.lastId = lastM.lyId;
            }
            if (self.page == 1) {
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView reloadData];
            }

            if (self.isTongzu) {
                self.isTongzu = NO;
                if (self.lyArr.count) {
                    if (self.page == 1) {
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        [self.tableView reloadData];
                    }
                }
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHUD];
    }];
    
}


- (void)createRefesh{
    
    __weak NoticeTestResultViewController *ctl = self;
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        ctl.isDown = YES;
//        ctl.page = 1;
//        [ctl requestLy];
//    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.page++;
        ctl.isDown = NO;
        [ctl requestLy];
    }];
    // 设置颜色
//    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
//    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
//    self.tableView.mj_header = header;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.webView setNeedsLayout];
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
