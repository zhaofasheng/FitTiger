//
//  NoticePayRecodCell.m
//  NoticeXi
//
//  Created by li lei on 2021/12/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePayRecodCell.h"

@implementation NoticePayRecodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, DR_SCREEN_WIDTH-40, 114)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 60)];
        self.titleL.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.titleL.numberOfLines = 2;
        self.titleL.layer.cornerRadius = 5;
        self.titleL.layer.masksToBounds = YES;
        self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleL.font = SIXTEENTEXTFONTSIZE;
        self.titleL.attributedText = [self setLabelSpacewithValue:[NoticeTools getLocalStrWith:@"zb.jingyanzhi"] withFont:SIXTEENTEXTFONTSIZE];
        [backView addSubview:self.titleL];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        
        self.numL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(88, 15, 200, 21)];
        self.numL.font = FIFTHTEENTEXTFONTSIZE;
        self.numL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [backView addSubview:self.numL];
        
        self.moneyL = [[UILabel alloc] initWithFrame:CGRectMake(88, 40, 200, 19)];
        self.moneyL.font = XGSIXBoldFontSize;
        self.moneyL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.moneyL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(88, 63, 230, 16)];
        self.timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:0.6];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        [backView addSubview:self.timeL];
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, backView.frame.size.width-40, 16)];
        self.statusL.textAlignment = NSTextAlignmentRight;
        self.statusL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.statusL.font = ELEVENTEXTFONTSIZE;
        [backView addSubview:self.statusL];
        self.statusL.text = [NoticeTools getLocalStrWith:@"zb.fin"];
    }
    return self;
}

- (void)setModel:(NoticePayReodModel *)model{
    _model = model;
    self.numL.text = model.product_name;
    if (self.isSend) {
        self.numL.text = [NSString stringWithFormat:@"%@-赠给%@",model.product_name,model.nick_name];
        if ([NoticeTools getLocalType]==1) {
            self.numL.text = [NSString stringWithFormat:@"%@-Gift to%@",model.product_name,model.nick_name];
        }
        if ([NoticeTools getLocalType]==2) {
            self.numL.text = [NSString stringWithFormat:@"%@-送给%@",model.product_name,model.nick_name];
        }
    }
    self.timeL.text = model.pay_time;
    self.moneyL.text = [NSString stringWithFormat:@"¥%@",model.fee];
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    
    
    
    
    
    
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
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
