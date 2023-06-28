//
//  NoticeMoivceInCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoivceInCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMovieDetailViewController.h"
#import "NoticeBookDetailController.h"
#import "NoticeSongDetailController.h"

@implementation NoticeMoivceInCell
{
    UIImageView *_postImageView;
    UILabel *_nameL;
    UILabel *_titleL;
    
    UIView *_mbView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        self.userInteractionEnabled = YES;
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 58, 58)];
        _postImageView.layer.cornerRadius = 3;
        _postImageView.layer.masksToBounds = YES;
        [self addSubview:_postImageView];
        
        _mbView = [[UIView alloc] initWithFrame:_postImageView.bounds];
        _mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_postImageView addSubview:_mbView];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10, 18, frame.size.width-10-12-24-CGRectGetMaxX(_postImageView.frame), 20)];
        _nameL.font = FOURTHTEENTEXTFONTSIZE;
        _nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:_nameL];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_nameL.frame.origin.x, CGRectGetMaxY(_nameL.frame)+4, _nameL.frame.size.width, 17)];
        _titleL.font = ELEVENTEXTFONTSIZE;
        _titleL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        _titleL.numberOfLines = 1;
        [self addSubview:_titleL];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        _scoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-10-24, 27, 24, 24)];
        [self addSubview:_scoreImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTodetail)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (void)setUserScro:(NSString *)userScro{
    _userScro = userScro;

    if ([userScro isEqualToString:@"0"]) {
        _scoreImageView.image = UIImageNamed(@"bad_select");
    }else if ([userScro isEqualToString:@"50"]){
        _scoreImageView.image = UIImageNamed(@"normal_select");
    }else{
        _scoreImageView.image = UIImageNamed(@"good_select");
    }
}

- (void)setSongScro:(NSString *)songScro{
    _songScro = songScro;
    if ([songScro isEqualToString:@"100"]) {
        _scoreImageView.image = UIImageNamed(@"Image_cg100");
    }else if ([songScro isEqualToString:@"150"]){
        _scoreImageView.image = UIImageNamed(@"Image_cg150");
    }
    else{
        _scoreImageView.image = UIImageNamed(@"Image_cg200");
    }
}

- (void)setMovie:(NoticeMovie *)movie{
    _movie = movie;
    _nameL.text = movie.movie_title;
    _titleL.text = [NSString stringWithFormat:@"%@%@/%@(%@)",movie.movie_score,[NoticeTools getLocalStrWith:@"movie.fen"],movie.released_at,movie.movieAdress];
    _titleL.text = [_titleL.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    _titleL.text = [_titleL.text stringByReplacingOccurrencesOfString:@"()" withString:@""];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:movie.movie_poster]
              placeholderImage:GETUIImageNamed(@"img_empty")
                       options:SDWebImageRefreshCached];
    
    _postImageView.frame = CGRectMake(12, 10, 40, 58);
    _mbView.frame = _postImageView.bounds;
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10, 18, self.frame.size.width-10-12-24-CGRectGetMaxX(_postImageView.frame), 20);
    _titleL.frame = CGRectMake(_nameL.frame.origin.x, CGRectGetMaxY(_nameL.frame)+4, _nameL.frame.size.width, 17);

}

- (void)setBook:(NoticeBook *)book{
    _book = book;
    _nameL.text = book.book_name;
    _titleL.text =[NSString stringWithFormat:@"%@%@/%@",book.book_score,[NoticeTools getLocalStrWith:@"movie.fen"], book.book_author];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:book.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _postImageView.frame = CGRectMake(12, 10, 40, 58);
    _mbView.frame = _postImageView.bounds;
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10, 18, self.frame.size.width-10-12-24-CGRectGetMaxX(_postImageView.frame), 20);
    _titleL.frame = CGRectMake(_nameL.frame.origin.x, CGRectGetMaxY(_nameL.frame)+4, _nameL.frame.size.width, 17);
}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    _nameL.text = song.song_name;
    _titleL.text = song.album_singer;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _postImageView.frame = CGRectMake(12, 10, 58, 58);
    _mbView.frame = _postImageView.bounds;
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10, 18, self.frame.size.width-10-12-24-CGRectGetMaxX(_postImageView.frame), 20);
    _titleL.frame = CGRectMake(_nameL.frame.origin.x, CGRectGetMaxY(_nameL.frame)+4, _nameL.frame.size.width, 17);
}

- (void)tapTodetail{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if ([self.type isEqualToString:@"2"]) {
        NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
        ctl.book = _book;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else if ([self.type isEqualToString:@"3"]){
        NoticeSongDetailController *ctl = [[NoticeSongDetailController alloc] init];
        ctl.song = _song;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
    else if ([self.type isEqualToString:@"1"]){
        NoticeMovieDetailViewController *ctl = [[NoticeMovieDetailViewController alloc] init];
        ctl.movie = _movie;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
 
}

- (void)refreshUI{

}
@end
