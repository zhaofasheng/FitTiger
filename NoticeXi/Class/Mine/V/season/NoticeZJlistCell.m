//
//  NoticeZJlistCell.m
//  NoticeXi
//
//  Created by li lei on 2019/8/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZJlistCell.h"

@implementation NoticeZJlistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 70)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backView];
        
        _zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8,54,54)];
        _zjImageView.layer.cornerRadius = 8;
        _zjImageView.layer.masksToBounds = YES;
        [backView addSubview:_zjImageView];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10,10,DR_SCREEN_WIDTH-40-10-8-54-15-24,22)];
        _nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _nameL.font = SIXTEENTEXTFONTSIZE;
        [backView addSubview:_nameL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+10,_nameL.frame.size.width, 18)];
        _typeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _typeL.font = TWOTEXTFONTSIZE;
        [backView addSubview:_typeL];
        
        self.lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-15-24, 23, 24, 24)];
        self.lockImageView.image = UIImageNamed(@"Image_zjsuonew");
        self.lockImageView.hidden = YES;
        [backView addSubview:self.lockImageView];
    }
    return self;
}

- (void)setZjModel:(NoticeZjModel *)zjModel{
    _zjModel = zjModel;
    _nameL.text = zjModel.album_name;
    [_zjImageView sd_setImageWithURL:[NSURL URLWithString:zjModel.album_cover_url]
                    placeholderImage:UIImageNamed(@"Image_addzjdefault")
                             options:SDWebImageRefreshCached];

    if (zjModel.album_type.intValue == 1) {
        self.lockImageView.hidden = YES;
    }else{
        self.lockImageView.hidden = NO;
    }
    if (self.isLimit) {
        _typeL.text = [NSString stringWithFormat:@"%@%@  %@",zjModel.dialog_num,[NoticeTools getLocalStrWith:@"zj.tyuyin"],[NoticeTools getLocalStrWith:@"zj.simi"]];
    }else{
        _typeL.text = [NSString stringWithFormat:@"%@%@  %@",zjModel.voice_num,[NoticeTools getLocalStrWith:@"zj.txinq"],self.lockImageView.hidden?@"":[NoticeTools getLocalStrWith:@"zj.simi"]];
    }
    
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
