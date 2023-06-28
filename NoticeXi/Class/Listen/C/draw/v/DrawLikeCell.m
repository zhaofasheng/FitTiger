//
//  DrawLikeCell.m
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "DrawLikeCell.h"

@implementation DrawLikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,(65-38)/2, 38, 38)];
        self.iconImageView.layer.cornerRadius = 19;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.backgroundColor = GetColorWithName(VBackColor);
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(26+_iconImageView.frame.origin.x, 26+_iconImageView.frame.origin.y, 15, 15)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+15,0, DR_SCREEN_WIDTH-15-66-10-CGRectGetMaxX(self.iconImageView.frame), 65)];
        self.nickNameL.textColor = GetColorWithName(VMainTextColor);
        self.nickNameL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nickNameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH(@"昨立刻就天14点11分", 11, 11)-15-20,0,GET_STRWIDTH(@"昨立刻就天14点11分", 11, 11)+20,65)];
        self.timeL.textColor = GetColorWithName(VDarkTextColor);
        self.timeL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.timeL];
        self.timeL.textAlignment = NSTextAlignmentRight;
        

        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.nickNameL.frame.origin.x,64, DR_SCREEN_WIDTH-self.nickNameL.frame.origin.x, 1)];
        line1.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:line1];
    }
    
    return self;
}

- (void)setLikeModel:(DrawLikeModel *)likeModel{
    _likeModel = likeModel;
    if ([likeModel.like_type isEqualToString:@"1"]) {
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:likeModel.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    }
    
    
    if ([likeModel.identity_type isEqualToString:@"0"] || [likeModel.like_type isEqualToString:@"2"]) {
        self.markImage.hidden = YES;
    }else if ([likeModel.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([likeModel.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }else{
        self.markImage.hidden = YES;
    }
    
    if ([likeModel.from_user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    
    if ([likeModel.like_type isEqualToString:@"2"]) {
        self.markImage.hidden = YES;
    }
    _nickNameL.text = likeModel.nick_name;
    _timeL.text = likeModel.created_at;
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
