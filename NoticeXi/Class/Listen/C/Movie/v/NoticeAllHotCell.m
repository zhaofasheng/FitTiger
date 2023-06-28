//
//  NoticeAllHotCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAllHotCell.h"

@implementation NoticeAllHotCell
{
    UIView *_mbView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 110)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        self.backV = backView;
        
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,64,90)];
        _postImageView.layer.cornerRadius = 8;
        _postImageView.layer.masksToBounds = YES;
        [backView addSubview:_postImageView];
                
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,20,backView.frame.size.width-10-CGRectGetMaxX(_postImageView.frame)-50, 22)];
        _nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _nameL.font = SIXTEENTEXTFONTSIZE;
        [backView addSubview:_nameL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+12,DR_SCREEN_WIDTH-40-10-CGRectGetMaxX(_postImageView.frame)-15,12)];
        _typeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _typeL.font = ELEVENTEXTFONTSIZE;
        [backView addSubview:_typeL];
        
        _scorL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-70,20,70,22)];
        _scorL.font = SIXTEENTEXTFONTSIZE;
        _scorL.textAlignment = NSTextAlignmentRight;
        _scorL.textColor = [UIColor colorWithHexString:@"#E6C14D"];
        [backView addSubview:_scorL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+5,DR_SCREEN_WIDTH-40-10-CGRectGetMaxX(_postImageView.frame)-15, 12)];
        _timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _timeL.font = ELEVENTEXTFONTSIZE;
        [backView addSubview:_timeL];

    }
    return self;
}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    self.backV.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 84);
    _postImageView.frame = CGRectMake(10,10,64,64);
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,20,DR_SCREEN_WIDTH-40-20-CGRectGetMaxX(_postImageView.frame), 22);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+8,_nameL.frame.size.width,18);
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = song.song_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@",song.album_singer,song.album_name];
}

- (void)setBook:(NoticeBook *)book{
    _book = book;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:book.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = book.book_name;
    _typeL.text = book.book_author;
    _scorL.text = [NSString stringWithFormat:@"%@%@",book.book_score,[NoticeTools getLocalStrWith:@"movie.fen"]];
}

- (void)setMovice:(NoticeMovie *)movice{
    _movice = movice;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:movice.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = movice.movie_title;
    _typeL.text = [[NSString stringWithFormat:@"%@/%@/%@%@",movice.movieAdress,movice.movietype,movice.movie_len,[NoticeTools getLocalStrWith:@"movie.fenzhong"]] stringByReplacingOccurrencesOfString:@"(null)/" withString:@""];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"/0分钟" withString:@""];
    _timeL.text = movice.movieStar;
    _scorL.text = [NSString stringWithFormat:@"%@%@",movice.movie_score,[NoticeTools getLocalStrWith:@"movie.fen"]];
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
