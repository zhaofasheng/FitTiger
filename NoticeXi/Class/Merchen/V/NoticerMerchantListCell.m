//
//  NoticerMerchantListCell.m
//  NoticeXi
//
//  Created by li lei on 2021/11/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticerMerchantListCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeWebViewController.h"
#import "NoticeMerchantImgCell.h"
@implementation NoticerMerchantListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 204)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 22)];
        self.titleL.font = SIXTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.titleL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-54, 15, 54, 24)];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        [button setTitle:[NoticeTools getLocalStrWith:@"qu.kankan"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        button.titleLabel.font = ELEVENTEXTFONTSIZE;
        button.layer.cornerRadius = 12;
        button.layer.masksToBounds = YES;
        [self.backView addSubview:button];
        [button addTarget:self action:@selector(merchClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(15,52,self.backView.frame.size.width-15, self.backView.frame.size.height-52-10);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.backView.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeMerchantImgCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 140+15;
        [self.backView addSubview:self.movieTableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.subModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMerchantImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.subModel = self.model.subModelArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (void)merchClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //店铺id，商品id，网页链接由后台返回
    //打开商品详情
    NSString *url = [NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@",self.model.skip_url];
    if (!self.model.skip_url) {//没有商品id就跳转到店铺
        url = @"taobao://shop.m.taobao.com/shop/shop_index.htm?shop_id=339691242";
    }
    NSURL *taobaoUrl = [NSURL URLWithString:url];

    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:taobaoUrl]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
         
                [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        DRLog(@"跳转成功");
                    }
                }];
            }
        } else {
            [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    DRLog(@"跳转成功");
                }
            }];
        }
    }else{

        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = self.model.skip_url?[NSString stringWithFormat:@"https://item.taobao.com/item.htm?spm=a1z10.3-c.w4002-23655650347.9.4a2a2f7dz5F2s1&id=%@",self.model.skip_url]:@"https://shop339691242.taobao.com/?spm=a230r.7195193.1997079397.2.34522aaazGyYlu";
        ctl.isFromShare = YES;
        ctl.isMerechant = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)setModel:(NoticeMerchantModel *)model{
    _model = model;
    self.titleL.text = model.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
