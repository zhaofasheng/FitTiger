//
//  NoticeReTestViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeReTestViewController.h"
#import "NoticeRetestHeaderView.h"
#import "NoticePersonality.h"
#import "NoticeAllPersonlity.h"
#import "DRPsychologyViewController.h"
#import "NoticeTestResultViewController.h"
@interface NoticeReTestViewController ()<NoticeTestDetailDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) NoticeRetestHeaderView *headerView;
@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UILabel *sectionL;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NoticePersonality *personLity;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@end

@implementation NoticeReTestViewController
{
    CGFloat imgWidth;
    CGFloat cellHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *titArr = @[[NoticeSaveModel isNounE] ?@"listen.qfenxiE":@"listen.qfenxi",@"listen.csjg"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = self.buttonArr[i];
        [btn setTitle:GETTEXTWITE(titArr[i]) forState:UIControlStateNormal];
    }
    
    [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"personality/%@/lastLog",[[NoticeSaveModel getUserInfo]user_id]] Accept:@"application/vnd.shengxi.v3.0+json" parmaer:nil success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict[@"data"][@"personality_id"] isEqual:[NSNull null]]) {
                return ;
            }
            self.personalityId = [NSString stringWithFormat:@"%@",dict[@"data"][@"personality_id"]];
            [self requestTextInfo];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = GETTEXTWITE(@"listen.cyc");

    self.dataArr = [NSMutableArray new];
    self.labelArr = [NSMutableArray new];
    self.imageArr = [NSMutableArray new];
    
    if ([NoticeTools isWhiteTheme]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToPageAction)];
    }else{
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 22, 44);
        [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.backImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_retest":@"Image_retesty");
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    [self.view addSubview:self.backImageView];
    
    [self.view bringSubviewToFront:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self.tableView registerClass:[BaseCell class] forCellReuseIdentifier:@"cell1"];
    
    imgWidth = (DR_SCREEN_WIDTH-40-90)/4;
    cellHeight = imgWidth + 47+12+3;
    self.tableView.rowHeight = cellHeight*4;
    //
    self.buttonArr = [NSMutableArray new];
    NSArray *titArr = @[[NoticeSaveModel isNounE] ?@"listen.qfenxiE":@"listen.qfenxi",@"listen.csjg"];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 160+50-25)];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 4+75*i, DR_SCREEN_WIDTH-30, 55)];
        [btn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_retest_label":@"Image_retest_labely") forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        [btn setTitle:GETTEXTWITE(titArr[i]) forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:btn];
        [footView addSubview:btn];
    }
    self.tableView.tableFooterView = footView;
    
    self.headerView = [[NoticeRetestHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 301-16)];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.delegate = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 66)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = GetColorWithName(VMainThumeWhiteColor);
    label.font = XGSIXBoldFontSize;
    label.text = GETTEXTWITE(@"listen.allecylx");
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.sectionL = label;
    
    NSInteger tag = 0;
    self.cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, cellHeight*4)];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(imgWidth+30)*j,cellHeight*i, imgWidth, imgWidth)];
            imageView.layer.cornerRadius =10;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            imageView.tag = tag;
            [self.cellView addSubview:imageView];
            
            if (![NoticeTools isWhiteTheme]) {
                UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth)];
                mbView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
                [imageView addSubview:mbView];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWithImage:)];
            [imageView addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-5, CGRectGetMaxY(imageView.frame)+10, imgWidth+10, 12+3+12)];
            label.textColor = GetColorWithName(VMainThumeWhiteColor);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = TWOTEXTFONTSIZE;
            [self.cellView addSubview:label];
            
            [self.imageArr addObject:imageView];
            [self.labelArr addObject:label];
            tag++;
        }
    }
    
    [self requestTextInfo];
}

- (void)backToPageAction{
    if (self.isFromStart) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.sectionL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50+16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    [self.cellView removeFromSuperview];
    [cell.contentView addSubview:self.cellView];
    return cell;
}

- (void)requestTextInfo{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"personality/%@",self.personalityId] Accept:@"application/vnd.shengxi.v3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticePersonality *person = [NoticePersonality mj_objectWithKeyValues:dict[@"data"]];
            person.allDesc = [NSString stringWithFormat:@"%@\n\n%@",person.personality_feature,person.personality_desc_long];
            self.headerView.nameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@  %@(%@)",GETTEXTWITE(@"listen.yourlx"),person.personality_no,person.personality_title] setColor:GetColorWithName(VMainThumeColor) setLengthString:[NSString stringWithFormat:@"%@(%@)",person.personality_no,person.personality_title] beginSize:[GETTEXTWITE(@"listen.yourlx") length]+2];
            self.headerView.addnums = person.today_join;
            self.shareUrl = person.share_url;
            self.personLity = person;
        }
    } fail:^(NSError *error) {
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"personalityRole" Accept:@"application/vnd.shengxi.v3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAllPersonlity *person = [NoticeAllPersonlity mj_objectWithKeyValues:dic];
                [self.dataArr addObject:person];
            }
            if (self.dataArr.count) {
                [self refresh];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)refresh{
    if (self.dataArr.count >= 16) {
        for (int i = 0; i < 16; i++) {
            UIImageView *imageView = self.imageArr[i];
            NoticeAllPersonlity *person = self.dataArr[i];
            UILabel *label = self.labelArr[i];
            label.text = [NSString stringWithFormat:@"%@\n%@",person.personality_title,person.personality_no];
            [imageView sd_setImageWithURL:[NSURL URLWithString:person.role_pic_url]
                              placeholderImage:GETUIImageNamed(@"img_empty")
                                       options:SDWebImageRefreshCached];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 285) {
        self.sectionL.alpha = 0;
    }else{
        self.sectionL.alpha = 1;
        self.sectionL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
}

- (void)tapWithImage:(UITapGestureRecognizer *)tap{
    if (!self.dataArr.count) {
        return;
    }
    UIImageView *tapView = (UIImageView *)tap.view;
    NoticeAllPersonlity *person = self.dataArr[tapView.tag];
    NoticeTestResultViewController *ctl = [[NoticeTestResultViewController alloc] init];
    ctl.personalityId = person.personality_id;
    ctl.name = person.personality_title;
    if ([person.personality_title isEqualToString:self.personLity.personality_title]) {
        ctl.isAll = NO;
    }else{
        ctl.isAll = YES;
    }
    
     [self.navigationController pushViewController:ctl animated:YES];
}

- (void)tapWithTypeOrNum:(BOOL)isType{
    NoticeTestResultViewController *ctl = [[NoticeTestResultViewController alloc] init];
    ctl.name = self.personLity.personality_title;
    ctl.personalityId = self.personalityId;
    if (!isType) {
        ctl.isTongzu = YES;
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag) {
        DRPsychologyViewController *ctl = [[DRPsychologyViewController alloc] init];
         [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    if (!self.personLity) {
        return;
    }
    if (!self.personLity.img_url || [[self.personLity.img_url substringFromIndex:self.personLity.img_url.length-1] isEqualToString:@"/"]) {
        [self showToastWithText:@"图片下载失败"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.personLity.img_url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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

@end
