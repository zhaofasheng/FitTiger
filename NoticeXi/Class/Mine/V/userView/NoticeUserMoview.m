//
//  NoticeUserMoview.m
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserMoview.h"

@implementation NoticeUserMoview

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GetColorWithName(VBackColor);
        
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,100,140)];
        _postImageView.layer.cornerRadius = 5;
        _postImageView.layer.masksToBounds = YES;
        [self addSubview:_postImageView];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,7+15,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 16)];
        _nameL.textColor = GetColorWithName(VMainTextColor);
        _nameL.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:_nameL];
        
        _scroImagev = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+13, CGRectGetMaxY(_nameL.frame)+27, 44, 44)];
        [self addSubview:_scroImagev];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_scroImagev.frame)+7,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12)];
        _typeL.textColor = GetColorWithName(VDarkTextColor);
        _typeL.font = TWOTEXTFONTSIZE;
        [self addSubview:_typeL];
    
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_typeL.frame)+5,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12)];
        _infoL.font = TWOTEXTFONTSIZE;
        _infoL.textColor = GetColorWithName(VDarkTextColor);
        [self addSubview:_infoL];
      
    }
    return self;
}

- (void)setMovie:(NoticeMovie *)movie{
    _movie = movie;
    _nameL.text = movie.movie_title;
    _typeL.text = movie.movietype;
    _postImageView.frame = CGRectMake(15,15,100,140);
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,7+15,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 16);
    _scroImagev.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13, CGRectGetMaxY(_nameL.frame)+27, 44, 44);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_scroImagev.frame)+7,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _infoL.hidden = NO;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:movie.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _infoL.text = movie.movieStar;
}

- (void)setBook:(NoticeBook *)book{
    _book = book;
    _postImageView.frame = CGRectMake(15,15,100,140);
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,7+15,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 16);
    _scroImagev.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13, CGRectGetMaxY(_nameL.frame)+27, 44, 44);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_scroImagev.frame)+7,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _infoL.hidden = YES;
    _nameL.text = book.book_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@",book.book_author,book.book_publisher,book.published_date];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:book.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];

}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    _postImageView.frame = CGRectMake(15,15,100,100);
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,7+15,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 16);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+15,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _scroImagev.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13, CGRectGetMaxY(_typeL.frame)+16, 28, 28);
    _infoL.hidden = YES;
    _nameL.text = song.song_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@",song.album_singer,song.album_name];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
}

- (void)setSongScroe:(NSString *)songScroe{
    if ([songScroe isEqualToString:@"100"]) {
        _scroImagev.image = UIImageNamed(@"Image_cg100");
    }else if ([songScroe isEqualToString:@"150"]){
        _scroImagev.image = UIImageNamed(@"Image_cg150");
    }
    else{
        _scroImagev.image = UIImageNamed(@"Image_cg200");
    }
}

- (void)setUserScroe:(NSString *)userScroe{

    if ([userScroe isEqualToString:@"0"]) {
        _scroImagev.image = UIImageNamed(@"bad_select");
    }else if ([userScroe isEqualToString:@"50"]){
        _scroImagev.image = UIImageNamed(@"normal_select");
    }
    else{
        _scroImagev.image = UIImageNamed(@"good_select");
    }
}

@end
