//
//  NoticeNewUserOrderCell.m
//  NoticeXi
//
//  Created by li lei on 2021/8/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewUserOrderCell.h"

@implementation NoticeNewUserOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, DR_SCREEN_WIDTH-40, 56)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 32, 32)];
        imageView.image = UIImageNamed(@"Image_mp4");
        [backView addSubview:imageView];
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(11, 12, 8, 8)];
        self.redView.backgroundColor = [UIColor colorWithHexString:@"#E6C14D"];
        self.redView.layer.cornerRadius = 4;
        self.redView.layer.masksToBounds = YES;
        [backView addSubview:self.redView];
        
        UIImageView *intoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-20, 18, 20, 20)];
        intoImageV.image = UIImageNamed(@"Image_intomp4");
        [backView addSubview:intoImageV];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(54, 17, backView.frame.size.width-54-30, 21)];
        self.titleL.font = FIFTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        [backView addSubview:self.titleL];
    }
    return self;
}

- (void)setOrderM:(NoticeNewUserModel *)orderM{
    _orderM = orderM;
    self.titleL.text = orderM.title;
    self.redView.hidden = orderM.hasLook?YES:NO;
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
