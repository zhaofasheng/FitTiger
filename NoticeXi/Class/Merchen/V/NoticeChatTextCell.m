//
//  NoticeChatTextCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatTextCell.h"

@implementation NoticeChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backV1 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 64+15)];
        backV1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backV1];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(30, 0, DR_SCREEN_WIDTH-60, 64)];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backV];
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backV.frame.size.width-15-20, 22, 20, 20)];
        self.choiceImageView.image = UIImageNamed(@"Image_nochoicesh");
        [backV addSubview:self.choiceImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 48, 48)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        [backV addSubview:self.iconImageView];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(64, 28, 200, 28)];
        self.priceL.font = XGTwentyBoldFontSize;
        self.priceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [backV addSubview:self.priceL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(64, 8, backV.frame.size.width-64, 20)];
        self.markL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        [backV addSubview:self.markL];
        
    }
    return self;
}

- (void)setGoodModel:(NoticeGoodsModel *)goodModel{
    _goodModel = goodModel;
    self.choiceImageView.image = UIImageNamed(goodModel.choice.boolValue?@"Image_choicesh":@"Image_nochoicesh");
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_img_url]];
    NSString *allStr = [NSString stringWithFormat:@"%@鲸币(%@分钟)",goodModel.price,goodModel.duration];
    NSString *subStr = [NSString stringWithFormat:@"鲸币(%@分钟)",goodModel.duration];
    self.priceL.attributedText = [DDHAttributedMode setString:allStr setSize:12 setLengthString:subStr beginSize:goodModel.price.length];
    self.markL.text = goodModel.goods_name;
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
