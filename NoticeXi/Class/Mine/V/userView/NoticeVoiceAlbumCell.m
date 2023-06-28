//
//  NoticeVoiceAlbumCell.m
//  NoticeXi
//
//  Created by li lei on 2023/3/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceAlbumCell.h"

@implementation NoticeVoiceAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 88)];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        _zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,88,88)];
        [backView addSubview:_zjImageView];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10,10,DR_SCREEN_WIDTH-88-10-30-30,21)];
        _nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _nameL.font = XGFifthBoldFontSize;
        [backView addSubview:_nameL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+4,_nameL.frame.size.width, 17)];
        _typeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _typeL.font = TWOTEXTFONTSIZE;
        [backView addSubview:_typeL];
        
        self.lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-16, 13, 16, 16)];
        self.lockImageView.image = UIImageNamed(@"Image_zjsuonew");
        self.lockImageView.hidden = YES;
        [backView addSubview:self.lockImageView];
        
        self.lastJoinL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10, 64, _nameL.frame.size.width, 14)];
        self.lastJoinL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.lastJoinL.font = [UIFont systemFontOfSize:10];
        [backView addSubview:self.lastJoinL];
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
    if (self.isdialog) {
        _typeL.text = [NSString stringWithFormat:@"%@%@",zjModel.dialog_num,[NoticeTools chinese:@"条" english:@"posts" japan:@"投稿"]];
    }else{
        _typeL.text = [NSString stringWithFormat:@"%@%@",zjModel.voice_num,[NoticeTools chinese:@"条" english:@"posts" japan:@"投稿"]];
    }
    if (zjModel.last_join_time.intValue) {
        self.lastJoinL.text = zjModel.last_join_timeName;
        self.lastJoinL.hidden = NO;
    }else{
        self.lastJoinL.hidden = YES;
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
