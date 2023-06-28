//
//  NoticeMerchantImgCell.m
//  NoticeXi
//
//  Created by li lei on 2021/11/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeMerchantImgCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeMerchantImgCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.merchantImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 105)];
        self.merchantImgV.contentMode = UIViewContentModeScaleAspectFill;
        self.merchantImgV.clipsToBounds = YES;
        self.merchantImgV.layer.cornerRadius = 10;
        self.merchantImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.merchantImgV];
        self.merchantImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.merchantImgV addGestureRecognizer:tap];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,110, 130, 40)];
        self.titleL.font = ELEVENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.titleL];
        self.titleL.numberOfLines = 2;

    }
    return self;
}

- (void)tapAction{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.merchantImgV;
    item.largeImageURL = [NSURL URLWithString:self.subModel.image];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.merchantImgV
                   toContainer:toView
                      animated:YES completion:nil];
}

- (void)setSubModel:(NoticeOpenTbModel *)subModel{
    _subModel = subModel;
    self.titleL.text = subModel.synopsis;
    [self.merchantImgV sd_setImageWithURL:[NSURL URLWithString:subModel.image]];
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
