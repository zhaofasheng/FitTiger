//
//  NoticeChoiceJieyouChatCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceJieyouChatCell.h"

@implementation NoticeChoiceJieyouChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 108)];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backV];
        self.backView = backV;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(85, 15,backV.frame.size.width-85-35, 22)];
        titleL.font = XGSIXBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backV addSubview:titleL];
        self.titleL = titleL;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        self.iconImageView.layer.cornerRadius = 2;
        self.iconImageView.layer.masksToBounds = YES;
        [backV addSubview:self.iconImageView];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(85, 68, 200, 30)];
        self.priceL.font = XGTwentyTwoBoldFontSize;
        self.priceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [backV addSubview:self.priceL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(85, 41, backV.frame.size.width-81, 17)];
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.text = @"仅支持连麦 | 聊天记录不保存";
        [backV addSubview:self.markL];
        
        self.changePriceBtn = [[UIImageView alloc] initWithFrame:CGRectMake(backV.frame.size.width-15-20, 15, 20, 20)];
        self.changePriceBtn.image = UIImageNamed(@"Image_changevoiceprice");
        [backV addSubview:self.changePriceBtn];
    }
    return self;
}

- (void)setGoodModel:(NoticeGoodsModel *)goodModel{
    _goodModel = goodModel;

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_img_url]];
    if(goodModel.type.intValue == 1){
        self.markL.text = [NSString stringWithFormat:@"限时%@分钟 | 不支持连麦 | 聊天记录不保存",goodModel.duration];
        self.titleL.text = [NSString stringWithFormat:@"文字聊天·%@",goodModel.goods_name];
        self.priceL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@鲸币",goodModel.price] setSize:12 setLengthString:@"鲸币" beginSize:goodModel.price.length];
    }else{
        self.markL.text = @"仅支持连麦 | 聊天记录不保存";
        self.titleL.text = @"语音通话";
        self.priceL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@鲸币/分钟",goodModel.price] setSize:12 setLengthString:@"鲸币/分钟" beginSize:goodModel.price.length];
    }
    if (self.isUserLookShop) {
        self.changePriceBtn.hidden = YES;
        self.buyButton.hidden = NO;
    }else{
        _buyButton.hidden = YES;
        self.changePriceBtn.hidden = NO;
    }
    
}

- (void)buyClick{
    if (self.buyGoodsBlock) {
        self.buyGoodsBlock(self.goodModel);
    }
}

- (UIButton *)buyButton{
    if(!_buyButton){
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-60-15, 71, 60, 24)];
        _buyButton.layer.cornerRadius = 12;
        _buyButton.layer.masksToBounds = YES;
        _buyButton.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        [_buyButton setTitle:@"下单" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.backView addSubview:_buyButton];
        [_buyButton addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
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
