//
//  NoticeSonglikeCell.m
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSonglikeCell.h"

@implementation NoticeSonglikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 37, 37)];
        [self.contentView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17,17,33, 33)];
        _iconImageView.layer.cornerRadius = 33/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,0,180, 65)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-15, 21, 66, 24)];
        label.textColor = [UIColor whiteColor];
        label.font = ELEVENTEXTFONTSIZE;
        label.text = [NoticeTools chinese:@"看看Ta" english:@"View" japan:@"見る"];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        label.layer.cornerRadius = 12;
        label.layer.masksToBounds = YES;
        [self.contentView addSubview:label];
        self.markL = label;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setLikeModel:(NoticeMusicLikeModel *)likeModel{
    _likeModel = likeModel;
    
    if (self.isHistory) {
        if (likeModel.song_tile && likeModel.song_tile.length) {
            NSString *Str = [NSString stringWithFormat:@" %@%@",[NoticeTools chinese:@"喜欢这首" english:@"liked " japan:@"が気に入る"],likeModel.song_tile];
            _nickNameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",likeModel.nick_name,Str] setColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7] setLengthString:Str beginSize:likeModel.nick_name.length];
        }else{
            NSString *Str = @"喜欢了你的歌单";
            _nickNameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",likeModel.nick_name,Str] setColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7] setLengthString:Str beginSize:likeModel.nick_name.length];
        }
        self.markL.frame = CGRectMake(15, 41, 200, 16);
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.backgroundColor = [UIColor whiteColor];
        self.markL.textAlignment = NSTextAlignmentLeft;
        self.markL.text = likeModel.created_at;
        self.markL.layer.masksToBounds = NO;
        self.nickNameL.frame = CGRectMake(15, 17, DR_SCREEN_WIDTH-30, 21);
        self.iconMarkView.hidden = YES;
        self.iconImageView.hidden = YES;
    }else{
        self.nickNameL.text = likeModel.nick_name;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:likeModel.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
        self.iconMarkView.image = UIImageNamed(likeModel.levelImgIconName);
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
