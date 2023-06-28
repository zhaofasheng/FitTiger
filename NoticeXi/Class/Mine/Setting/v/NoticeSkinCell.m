//
//  NoticeSkinCell.m
//  NoticeXi
//
//  Created by li lei on 2021/9/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSkinCell.h"

@implementation NoticeSkinCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-70)/3, (DR_SCREEN_WIDTH-70)/3*150/102)];
        self.backImageView.layer.cornerRadius = 8;
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.backImageView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backImageView.frame)+10, self.backImageView.frame.size.width, 17)];
        self.titleL.font = TWOTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.titleL];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(-3, -3, self.backImageView.frame.size.width+6, self.backImageView.frame.size.height+6)];
        self.lineView.layer.cornerRadius = 8;
        self.lineView.layer.masksToBounds = YES;
        self.lineView.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        self.lineView.layer.borderWidth = 2;
        self.lineView.hidden = YES;
        [self.contentView addSubview:self.lineView];
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineView.frame)-12, -10, 20, 20)];
        self.choiceImageView.image = UIImageNamed(@"Image_choiceadd_b");
        [self.contentView addSubview:self.choiceImageView];
        self.choiceImageView.hidden = YES;
        
        self.lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backImageView.frame.size.width-16, self.backImageView.frame.size.height-16, 14, 14)];
        self.lockImageView.image = UIImageNamed(@"Image_skinLock");
        [self.backImageView addSubview:self.lockImageView];
        self.lockImageView.hidden = YES;
        
        self.lelveL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 39, 20)];
        self.lelveL.textColor = [UIColor whiteColor];
        self.lelveL.font = ELEVENTEXTFONTSIZE;
        self.lelveL.textAlignment = NSTextAlignmentCenter;
        self.lelveL.layer.cornerRadius = 8;
        self.lelveL.layer.masksToBounds = YES;
        [self.backImageView addSubview:self.lelveL];
        self.lelveL.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    }
    return self;
}

- (void)setSkinModel:(NoticeSkinModel *)skinModel{
    _skinModel = skinModel;
    self.lineView.hidden = !skinModel.isSelect;
    self.choiceImageView.hidden = self.lineView.hidden;
    self.titleL.text = skinModel.title;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:skinModel.image_url] placeholderImage:UIImageNamed(skinModel.defaultImg)];
    
    self.lockImageView.hidden = YES;
    if (skinModel.is_own.boolValue) {
        self.lockImageView.hidden = YES;
    }else{
        self.lockImageView.hidden = NO;
    }
    
    self.lelveL.hidden = skinModel.level.intValue > 0?NO:YES;
    self.lelveL.text = [NSString stringWithFormat:@"Lv%@",skinModel.level];
}

@end
