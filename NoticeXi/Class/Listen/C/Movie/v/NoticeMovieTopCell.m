//
//  NoticeMovieTopCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMovieTopCell.h"
#import "DDHAttributedMode.h"
#import "NoticeMyMovieComController.h"
#import "NoticeBookComViewController.h"
#import "NoticeSongComController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeMovieTopCell
{
    UIButton *_myButton;
    UIView *_mbView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:appdel.backImg?0:1];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 144)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg? 0.2:1];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
  
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,88,124)];
        _postImageView.layer.cornerRadius = 8;
        _postImageView.layer.masksToBounds = YES;
        [backView addSubview:_postImageView];
        
        _mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 124)];
        _mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_postImageView addSubview:_mbView];
        
        _nameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+12,10,DR_SCREEN_WIDTH-40-10-CGRectGetMaxX(_postImageView.frame)-10, 22)];
        _nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _nameL.font = XGSIXBoldFontSize;
        [backView addSubview:_nameL];
        
        _scorTitleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+7,GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.sxpinfen"], 12, 12), 12)];
        _scorTitleL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _scorTitleL.font = TWOTEXTFONTSIZE;
        _scorTitleL.text = [NoticeTools getLocalStrWith:@"movie.sxpinfen"];
        [backView addSubview:_scorTitleL];
        
        _scorL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_scorTitleL.frame)+3,CGRectGetMaxY(_nameL.frame),50,25)];
        _scorL.font = XGEightBoldFontSize;
        _scorL.textColor = [UIColor colorWithHexString:@"#E6C14D"];
        [backView addSubview:_scorL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_scorTitleL.frame)+17,_nameL.frame.size.width,12)];
        _typeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _typeL.font = ELEVENTEXTFONTSIZE;
        [backView addSubview:_typeL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 12)];
        _timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.numberOfLines = 2;
        [backView addSubview:_timeL];
        
    }
    return self;
}

- (void)comClick{

    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        if (_myBook) {
            NoticeBookComViewController *ctlb = [[NoticeBookComViewController alloc] init];
            ctlb.book = _myBook;
            ctlb.userId = self.userId;
            [nav.topViewController.navigationController pushViewController:ctlb animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }else if (_song){
            NoticeSongComController *ctlb = [[NoticeSongComController alloc] init];
            ctlb.song = _song;
            ctlb.userId = self.userId;
            [nav.topViewController.navigationController pushViewController:ctlb animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        else{
            NoticeMyMovieComController *ctl = [[NoticeMyMovieComController alloc] init];
            ctl.movie = _myMovice;
            ctl.type = 1;
            ctl.userId = self.userId;
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)setMovice:(NoticeMovie *)movice{
    _movice = movice;
    _myButton.hidden = YES;
    _nameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@(%@)",movice.movie_title,movice.releasedYear] setColor:GetColorWithName(VDarkTextColor) setLengthString:[NSString stringWithFormat:@"(%@)",movice.releasedYear] beginSize:movice.movie_title.length];
    if ([movice.movieAdress isEqualToString:@"(null)"] || !movice.movieAdress) {
        movice.movieAdress = [NoticeTools getLocalStrWith:@"movie.noarea"];
    }
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@%@",movice.movieAdress,movice.movietype,movice.movie_len,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    _scorL.text = movice.movie_score;
    _timeL.text = movice.movieStar;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:movice.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    
    if (GET_STRHEIGHT(_timeL.text, 11, _timeL.frame.size.width) > 15) {
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 30);
    }else{
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 12);
    }
}

- (void)setBook:(NoticeBook *)book{
    _book = book;
    _myButton.hidden = YES;
    _nameL.text = book.book_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@",book.book_author,book.book_publisher,book.published_date];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
    _scorL.text = book.book_score;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:book.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    if (GET_STRHEIGHT(_timeL.text, 11, _timeL.frame.size.width) > 15) {
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 30);
    }else{
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 12);
    }
}

- (void)setMyMovice:(NoticeMovie *)myMovice{
    _myMovice = myMovice;
    _scorL.hidden = YES;
    _scorTitleL.hidden = YES;
    _myButton.hidden = NO;
    [_myButton setTitle:self.isOther ? ([NoticeTools isSimpleLau]?@"Ta的电影心情":@"Ta的電影心情") : ([NoticeTools isSimpleLau]?@"我的电影心情":@"我的電影心情") forState:UIControlStateNormal];
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+14,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_typeL.frame)+6,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 12);
    
    _nameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@(%@)",myMovice.movie_title,myMovice.releasedYear] setColor:GetColorWithName(VDarkTextColor) setLengthString:[NSString stringWithFormat:@"(%@)",myMovice.releasedYear] beginSize:myMovice.movie_title.length];
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@%@",myMovice.movieAdress,myMovice.movietype,myMovice.movie_len,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
    _timeL.text = myMovice.movieStar;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:myMovice.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    if (GET_STRHEIGHT(_timeL.text, 11, _timeL.frame.size.width) > 15) {
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 30);
    }else{
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 12);
    }
    
    
}
- (void)setMyBook:(NoticeBook *)myBook{
    _myBook = myBook;
    _scorL.hidden = YES;
    _scorTitleL.hidden = YES;
    _myButton.hidden = NO;
    [_myButton setTitle:self.isOther ?([NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.hisbook"]:@"Ta的書籍心情") : ([NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.mybook"]:@"我的書籍心情") forState:UIControlStateNormal];
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+14,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _nameL.text = myBook.book_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@",myBook.book_author,myBook.book_publisher,myBook.published_date];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
    _scorL.text = myBook.book_score;
    
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:myBook.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    if (GET_STRHEIGHT(_timeL.text, 11, _timeL.frame.size.width) > 15) {
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 30);
    }else{
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 12);
    }
}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    _scorL.hidden = YES;
    _scorTitleL.hidden = YES;
    _myButton.hidden = NO;
    
    _myButton.layer.cornerRadius = 29/2;
    [_myButton setTitle:self.isOther ?[NoticeTools getLocalStrWith:@"movie.hisbanb"]:[NoticeTools getLocalStrWith:@"movie.mybanb"] forState:UIControlStateNormal];
    _postImageView.frame = CGRectMake(15, 15, 100, 100);
    _postImageView.layer.cornerRadius = 5;
    _postImageView.layer.masksToBounds = YES;
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,22,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 16);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+14,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _nameL.text = song.song_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@",song.album_singer,song.album_name];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    
    _myButton.frame =  CGRectMake(CGRectGetMaxX(_postImageView.frame)+13, CGRectGetMaxY(_nameL.frame)+40, 85, 29);
    _line.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,129.5,DR_SCREEN_WIDTH-13-CGRectGetMaxX(_postImageView.frame), 0.5);
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    if (GET_STRHEIGHT(_timeL.text, 11, _timeL.frame.size.width) > 15) {
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 30);
    }else{
        _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+6,_nameL.frame.size.width-6, 12);
    }
}

- (void)setFirstMovice:(NoticeMovie *)firstMovice{
    _firstMovice = firstMovice;

    _myButton.hidden = YES;
    _nameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@(%@)",firstMovice.movie_title,firstMovice.releasedYear] setColor:GetColorWithName(VDarkTextColor) setLengthString:[NSString stringWithFormat:@"(%@)",firstMovice.releasedYear] beginSize:firstMovice.movie_title.length];
    if ([firstMovice.movieAdress isEqualToString:@"(null)"] || !firstMovice.movieAdress) {
        firstMovice.movieAdress = [NoticeTools getLocalStrWith:@"movie.noarea"];
    }
    _scorTitleL.hidden = YES;
    if (!firstMovice.movie_len) {
        firstMovice.movie_len = [NoticeTools getLocalStrWith:@"movie.knowtime"];
    }
    if (!firstMovice.movietype || [firstMovice.movietype isEqualToString:@"(null)"]) {
        firstMovice.movietype = [NoticeTools getLocalStrWith:@"movie.knowtype"];
    }
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@%@",firstMovice.movieAdress,firstMovice.movietype,firstMovice.movie_len,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+14,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _scorL.hidden = YES;
    _timeL.text = firstMovice.movieStar;
    _timeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_typeL.frame)+6,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 12);
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:firstMovice.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    self.moreL.hidden = NO;
    self.moreL.text = [NSString stringWithFormat:@"%@%@",firstMovice.voice_num,[NoticeTools getLocalStrWith:@"movie.voicedata"]];
}

- (void)setFirstbook:(NoticeBook *)firstbook{
    _firstbook = firstbook;
    _myButton.hidden = YES;
    _nameL.text = firstbook.book_name;
    _scorTitleL.hidden = YES;
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+14,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12);
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@",firstbook.book_author,firstbook.book_publisher,firstbook.published_date];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:firstbook.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _mbView.frame = CGRectMake(0, 0, _postImageView.frame.size.width, _postImageView.frame.size.height);
    self.moreL.hidden = NO;
    self.moreL.text = [NSString stringWithFormat:@"%@%@",firstbook.voice_num,[NoticeTools getLocalStrWith:@"movie.voicedata"]];
}

- (void)clickPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMBSPlayButton:)]) {
        [self.delegate clickMBSPlayButton:self.index];
    }
}

- (void)clickMoreTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMBSMoreButton:)]) {
          [self.delegate clickMBSMoreButton:self.index];
      }
    
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+13, CGRectGetMaxY(_postImageView.frame)-5-44, 44, 44)];
        [_playButton setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_dyplay":@"Image_dyplayy") forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
    }
    return _playButton;
}

- (UILabel *)moreL{
    if (!_moreL) {
        _moreL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.postImageView.frame)+15, 170-52,160,52)];
        _moreL.font = FOURTHTEENTEXTFONTSIZE;
        _moreL.textColor = GetColorWithName(VMainThumeColor);
        _moreL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreTap)];
        [_moreL addGestureRecognizer:tap];
        [self.contentView addSubview:_moreL];
    }
    return _moreL;
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
