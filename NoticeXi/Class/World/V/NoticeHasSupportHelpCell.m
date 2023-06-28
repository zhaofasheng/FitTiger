//
//  NoticeHasSupportHelpCell.m
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasSupportHelpCell.h"
#import "UIView+CLSetRect.h"
@implementation NoticeHasSupportHelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.userInteractionEnabled = YES;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 40)];
        backV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backV];
        
        UIView *backV1 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-70, 36)];
        backV1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [backV addSubview:backV1];
        backV1.layer.cornerRadius = 8;
        backV1.layer.masksToBounds = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
        _iconImageView.layer.cornerRadius = 10;
        _iconImageView.layer.masksToBounds = YES;
        [backV1 addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
    
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, DR_SCREEN_WIDTH-70-30-5, 36)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [backV1 addSubview:self.contentL];
    
    }
    return self;
}

- (void)setSupportModel:(NoticeHelpCommentModel *)supportModel{
    _supportModel = supportModel;
    if([self.tieFromUserId isEqualToString:supportModel.from_user_id]){
        self.iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
    }else{
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.avaturl]];
    }
    self.contentL.text = supportModel.content_type.intValue == 1?supportModel.content:@"「图片」";
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
