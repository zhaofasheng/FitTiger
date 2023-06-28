//
//  NoticeChatVoiceShopCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatVoiceShopCell.h"
#import "NoticeXi-Swift.h"
@implementation NoticeChatVoiceShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 141)];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backV];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
        titleL.font = XGFourthBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.text = @"语音通话";
        [backV addSubview:titleL];
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backV.frame.size.width-15-20, 15, 20, 20)];
        self.choiceImageView.image = UIImageNamed(@"Image_nochoicesh");
        [backV addSubview:self.choiceImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 56, 56)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        [backV addSubview:self.iconImageView];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(81, 45, 200, 30)];
        self.priceL.font = XGTwentyTwoBoldFontSize;
        self.priceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [backV addSubview:self.priceL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(81, 75, backV.frame.size.width-81, 17)];
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.text = @"仅支持连麦 | 聊天记录不保存";
        [backV addSubview:self.markL];
        
        self.changePriceBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(backV.frame.size.width-15-22-GET_STRWIDTH(@"改价", 12, 20), 111, 22+GET_STRWIDTH(@"改价", 12, 20), 20)];
        [self.changePriceBtn setTitle:@"改价" forState:UIControlStateNormal];
        [self.changePriceBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.changePriceBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.changePriceBtn setImage:UIImageNamed(@"Image_changevoiceprice") forState:UIControlStateNormal];
        self.changePriceBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [backV addSubview:self.changePriceBtn];
        [self.changePriceBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setGoodModel:(NoticeGoodsModel *)goodModel{
    _goodModel = goodModel;
    self.choiceImageView.image = UIImageNamed(goodModel.choice.boolValue?@"Image_choicesh":@"Image_nochoicesh");
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_img_url]];
    self.priceL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@鲸币/分钟",goodModel.price] setSize:12 setLengthString:@"鲸币/分钟" beginSize:goodModel.price.length];
    
}

- (void)changeClick{
    __weak typeof(self) weakSelf = self;

    NoticeChangePriceView *nameVieww = [[NoticeChangePriceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    nameVieww.nameBlock = ^(NSString * _Nullable name) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
  
        [parm setObject:name forKey:@"price"];
        
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"shop/setPrice/%@/%@",self.shopId,self.goodModel.goodId] Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if(success){
                weakSelf.goodModel.price = name;
                weakSelf.priceL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@鲸币/分钟",weakSelf.goodModel.price] setSize:12 setLengthString:@"鲸币/分钟" beginSize:weakSelf.goodModel.price.length];
                if(weakSelf.changePriceBlock){
                    weakSelf.changePriceBlock(weakSelf.goodModel.price);
                }
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    };
    [nameVieww showView];
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
