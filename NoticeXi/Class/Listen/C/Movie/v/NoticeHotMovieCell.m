//
//  NoticeHotMovieCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHotMovieCell.h"

@implementation NoticeHotMovieCell
{
    UIView *_backV;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,87,122)];
        [self.contentView addSubview:_postImageView];
        _postImageView.layer.cornerRadius = 5;
        _postImageView.layer.masksToBounds = YES;
        
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 87, 122)];
        mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_postImageView addSubview:mbView];
    
        UIView *bacKv = [[UIView alloc] initWithFrame:CGRectMake(0, 122-20, 87, 20)];
        bacKv.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
        [_postImageView addSubview:bacKv];
        _backV = bacKv;
        
        _scorL = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 97, 20)];
        _scorL.font = TWOTEXTFONTSIZE;
        _scorL.textColor = [UIColor colorWithHexString:@"#E6C14D"];
        [bacKv addSubview:_scorL];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_postImageView.frame)+10, 87-5, 13)];
        _nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _nameL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:_nameL];
    }
    return self;
}

- (void)setMovie:(NoticeMovie *)movie{
    _movie = movie;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:movie.movie_poster]
              placeholderImage:GETUIImageNamed(@"img_empty")
                       options:SDWebImageRefreshCached];
    _nameL.text = movie.movie_title;
    _scorL.text = [NSString stringWithFormat:@"%@%@",movie.movie_score,[NoticeTools getLocalStrWith:@"movie.fen"]];
}

- (void)setBook:(NoticeBook *)book{
    _book = book;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:book.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = book.book_name;
    _scorL.text = [NSString stringWithFormat:@"%@%@",book.book_score,[NoticeTools getLocalStrWith:@"movie.fen"]];
}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    _postImageView.frame = CGRectMake(0,0,87,87);
    _backV.hidden = YES;
    _nameL.frame = CGRectMake(0, CGRectGetMaxY(_postImageView.frame)+10, 87, 13);
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = song.song_name;
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
