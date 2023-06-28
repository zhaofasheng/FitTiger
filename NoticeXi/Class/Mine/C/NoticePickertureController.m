//
//  NoticePickertureController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticePickertureController.h"

@interface NoticePickertureController ()
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *titImageView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation NoticePickertureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 1;
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.dataArr = [NSMutableArray new];
    self.btn = [[UIButton alloc] init];
    [self.btn addTarget:self action:@selector(lookImage) forControlEvents:UIControlEventTouchUpInside];
    //296*940
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    [self.tableView registerClass:[BaseCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView reloadData];
    _titImageView = [[UIImageView alloc] init];
    [_titImageView addSubview:self.btn];
    _titImageView.userInteractionEnabled = YES;
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
    if (!self.isheader) {
        UIButton *tgBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-12-65, STATUS_BAR_HEIGHT+10, 65, 30)];
        [tgBtn setBackgroundImage:UIImageNamed(@"Image_tg_btn") forState:UIControlStateNormal];
        [tgBtn addTarget:self action:@selector(tgClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tgBtn];
    }
}

- (void)tgClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lookImage{
    if (self.isheader) {
        if ([NoticeTools Showpic2]) {
            [self.navigationController popViewControllerAnimated:NO];
             return;
        }
        [NoticeTools setFirstShowpic2];
        if ([NoticeTools Showpic] == 0) {
            [NoticeTools setFirstShowpic:@"1"];
        }else if ([NoticeTools Showpic] == 1){
            [NoticeTools setFirstShowpic:@"2"];
        }
        [self.navigationController popViewControllerAnimated:NO];

        return;
    }
    if (self.num > 4) {
        if ([NoticeTools Showpic1]) {
            [self.navigationController popViewControllerAnimated:NO];
             return;
        }
        [NoticeTools setFirstShowpic1];
        if ([NoticeTools Showpic] == 0) {
            [NoticeTools setFirstShowpic:@"1"];
        }else if ([NoticeTools Showpic] == 1){
            [NoticeTools setFirstShowpic:@"2"];
        }
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.num++;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isheader) {
        return 693;
    }
    if (self.num == 1) {
        return 580;
    }
    return 1097;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 1);//渐变
    transform = CATransform3DTranslate(transform, DR_SCREEN_WIDTH, 0, 0);//左边水平移动
    //transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    
    cell.layer.transform = transform;
    cell.layer.opacity = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = self.view.backgroundColor;
    cell.contentView.backgroundColor = self.view.backgroundColor;
    [self.titImageView removeFromSuperview];
    [cell addSubview:self.titImageView];
    NSString *imgName = [NSString stringWithFormat:@"manhua%ld",self.num];
    _titImageView.image = UIImageNamed(imgName);
    if (self.num == 1) {
        self.btn.frame = CGRectMake(0, 580-44, 320, 44);
        _titImageView.frame = CGRectMake((DR_SCREEN_WIDTH-320)/2, 0, 320, 580);
    }
    else{
        self.btn.frame = CGRectMake(0, 1097-44,296, 44);
        _titImageView.frame = CGRectMake((DR_SCREEN_WIDTH-310)/2, 0, 310, 1097);
    }
    if (self.isheader) {
        self.btn.frame = CGRectMake(0, 693-44,310, 44);
        _titImageView.frame = CGRectMake((DR_SCREEN_WIDTH-310)/2, 0, 310, 693);
        _titImageView.image = UIImageNamed(@"Image_llookheader");
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
