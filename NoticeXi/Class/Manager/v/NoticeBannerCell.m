//
//  NoticeBannerCell.m
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBannerCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"

@implementation NoticeBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30-50-10-50, 30)];
        self.titleL.font = SIXTEENTEXTFONTSIZE;
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:self.titleL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, DR_SCREEN_WIDTH-30, 30)];
        self.timeL.font = SIXTEENTEXTFONTSIZE;
        self.timeL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:self.timeL];
        
        self.changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-50, 5, 50, 25)];
        [self.changeBtn setTitle:@"修改" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        self.changeBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.changeBtn];
        self.changeBtn.layer.cornerRadius = 3;
        self.changeBtn.layer.masksToBounds = YES;
        self.changeBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-50-10-50, 5, 50, 25)];
        [self.deleteBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
        self.deleteBtn.layer.cornerRadius = 3;
        self.deleteBtn.layer.masksToBounds = YES;
        self.deleteBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        
        self.bannerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 60, DR_SCREEN_WIDTH-30, 40)];
        [self.contentView addSubview:self.bannerImageV];
        self.bannerImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTap)];
        [self.bannerImageV addGestureRecognizer:tap];
        self.bannerImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.bannerImageV.clipsToBounds = YES;
        self.bannerImageV.layer.cornerRadius = 5;
        self.bannerImageV.layer.masksToBounds = YES;
        
        self.contentImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 110, DR_SCREEN_WIDTH-30, DR_SCREEN_WIDTH)];
        [self.contentView addSubview:self.contentImageV];
        self.contentImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap)];
        [self.contentImageV addGestureRecognizer:tap1];
        self.contentImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImageV.clipsToBounds = YES;
        self.contentImageV.layer.cornerRadius = 5;
        self.contentImageV.layer.masksToBounds = YES;
    }
    return self;
}

- (void)changeClick{
    if (self.changeBlock) {
        self.changeBlock(self.bannerM.bannerId);
    }
}

- (void)deleteClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/banners/%@",self.bannerM.bannerId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.refreshBlock) {
                self.refreshBlock(YES);
            }
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)bannerTap{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.bannerImageV;
    item.largeImageURL     = [NSURL URLWithString:self.bannerM.title_image_url];

    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_bannerImageV toContainer:toView animated:YES completion:nil];
}

- (void)contentTap{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.contentImageV;
    item.largeImageURL     = [NSURL URLWithString:self.bannerM.content_image_url];

    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_contentImageV toContainer:toView animated:YES completion:nil];
}
- (void)setBannerM:(NoticeBannerModel *)bannerM{
    _bannerM = bannerM;
    self.titleL.text = [NSString stringWithFormat:@"定时任务%@",bannerM.bannerId];
    self.timeL.text = bannerM.started_at;
    [self.bannerImageV setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:bannerM.title_image_url]] placeholder:GETUIImageNamed(@"img_empty")];
    [self.contentImageV setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:bannerM.content_image_url]] placeholder:GETUIImageNamed(@"img_empty")];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
