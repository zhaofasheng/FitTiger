//
//  NoticeMovieDetail.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMovieDetail.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "DDHAttributedMode.h"
@implementation NoticeMovieDetail
{
    UIButton *_button;
    UIView *_buttonV;
    UIButton *_sendBtn;
    UIButton *_sendSubBtn;
    UIImageView *_markImageView;
    UILabel *_markL;
    BOOL _isShowAll;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH, 149)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        [self addSubview:_backView];
        
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,88,124)];
        _postImageView.layer.cornerRadius = 8;
        _postImageView.layer.masksToBounds = YES;
        [_backView addSubview:_postImageView];
        
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 124)];
        mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_postImageView addSubview:mbView];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,12,_backView.frame.size.width-10-CGRectGetMaxX(_postImageView.frame)-10, 22)];
        _nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _nameL.font = SIXTEENTEXTFONTSIZE;
        [_backView addSubview:_nameL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+10,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,12)];
        _typeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _typeL.font = TWOTEXTFONTSIZE;
        [_backView addSubview:_typeL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_typeL.frame)+5,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13, 14)];
        _timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _timeL.font = TWOTEXTFONTSIZE;
        [_backView addSubview:_timeL];
        
        _scorTitleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_timeL.frame)+8,GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.sxpinfen"], 12, 12), 12)];
        _scorTitleL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _scorTitleL.font = TWOTEXTFONTSIZE;
        _scorTitleL.text = [NoticeTools getLocalStrWith:@"movie.sxpinfen"];
        [_backView addSubview:_scorTitleL];
        
        _scorL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_scorTitleL.frame)+3,_scorTitleL.frame.origin.y,60,12)];
        _scorL.font = TWOTEXTFONTSIZE;
        _scorL.textColor = [UIColor colorWithHexString:@"#E6C14D"];
        [_backView addSubview:_scorL];
        

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.postImageView.frame)+15, self.backView.frame.size.width-10, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        [_backView addSubview:line];
       
        UIButton *subbutton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_postImageView.frame)-28,100, 28)];
        subbutton.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        subbutton.titleLabel.font = THRETEENTEXTFONTSIZE;
        [subbutton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        subbutton.layer.cornerRadius = 14;
        subbutton.layer.masksToBounds = YES;
        subbutton.layer.borderWidth = 1;
        subbutton.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [subbutton addTarget:self action:@selector(sendSubClick) forControlEvents:UIControlEventTouchUpInside];

        [_backView addSubview:subbutton];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subbutton.frame)+10,CGRectGetMaxY(_postImageView.frame)-28,100, 28)];
        button.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        button.titleLabel.font = THRETEENTEXTFONTSIZE;
        [button setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        button.layer.cornerRadius = 14;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_backView addSubview:button];
        
        _sendBtn = subbutton;
        _sendSubBtn = button;
        
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(15,160,_backView.frame.size.width-30, 0)];
        _infoL.numberOfLines = 0;
        _infoL.font = THRETEENTEXTFONTSIZE;
        _infoL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        [_backView addSubview:_infoL];
        
        _button = [[UIButton alloc] initWithFrame: CGRectMake(_backView.frame.size.width-60, CGRectGetMaxY(_infoL.frame),60, 30)];
        [_button addTarget:self action:@selector(openmoreClick) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:[NoticeTools getLocalStrWith:@"movie.open"] forState:UIControlStateNormal];
        [_button setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        _button.titleLabel.font = ELEVENTEXTFONTSIZE;
        [_backView addSubview:_button];
        
        UIView *btnline = [[UIView alloc] initWithFrame:CGRectMake(38/2, 26, 22, 1)];
        btnline.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [_button addSubview:btnline];
    }
    return self;
}

- (void)setSendMovice:(NoticeMovie *)sendMovice{
    _sendMovice = sendMovice;
    _markImageView.hidden = YES;
    _buttonV.hidden = YES;
    _infoL.hidden = YES;
    _button.hidden = YES;
    _scorTitleL.text = sendMovice.movieStar;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:sendMovice.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];

    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@%@",sendMovice.movieAdress,sendMovice.movietype,sendMovice.movie_len,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    _nameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@(%@)",sendMovice.movie_title,sendMovice.releasedYear] setColor: [UIColor colorWithHexString:@"#A1A7B3"] setLengthString:[NSString stringWithFormat:@"(%@)",sendMovice.releasedYear] beginSize:sendMovice.movie_title.length];
    
    
}

- (void)setSendBook:(NoticeBook *)sendBook{
    _sendBook = sendBook;
    _markImageView.hidden = YES;
    _buttonV.hidden = YES;
    _infoL.hidden = YES;
    _button.hidden = YES;
    _scorTitleL.hidden = YES;
    _nameL.font = XGFifthBoldFontSize;
    _nameL.text = sendBook.book_name;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:sendBook.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _typeL.font = TWOTEXTFONTSIZE;
    _typeL.textColor = GetColorWithName(VDarkTextColor);
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@",sendBook.book_author,sendBook.book_publisher,sendBook.published_date];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
}

- (void)setSendSong:(NoticeSong *)sendSong{
    _sendSong = sendSong;
    if (!_sendSong) {
        return;
    }
    _markImageView.hidden = YES;
    _buttonV.hidden = YES;
    _infoL.hidden = YES;
    _button.hidden = YES;
    _scorTitleL.hidden = YES;
    _postImageView.frame = CGRectMake(15,15,100,100);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+13,CGRectGetMaxY(_nameL.frame)+15,DR_SCREEN_WIDTH-10-CGRectGetMaxX(_postImageView.frame)-13,14);
    _nameL.font = XGFifthBoldFontSize;
    _nameL.text = sendSong.song_name;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:sendSong.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _typeL.font = TWOTEXTFONTSIZE;
    _typeL.textColor = GetColorWithName(VDarkTextColor);
    _typeL.text = [NSString stringWithFormat:@"%@/%@",sendSong.album_singer,sendSong.album_name];
    
}

- (void)openmoreClick{
    _isShowAll = !_isShowAll;
    if (self.book) {
        if (!_isShowAll) {
            self.infoL.attributedText = _book.fiveAttTextStr;
            self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, _book.fiveTextHeight);
            [_button setTitle:[NoticeTools getLocalStrWith:@"movie.open"] forState:UIControlStateNormal];
        }else{
            self.infoL.attributedText = _book.allTextAttStr;
            self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, _book.textHeight);
   
            [_button setTitle:[NoticeTools getLocalStrWith:@"movie.clo"] forState:UIControlStateNormal];
        }
        self.backView.frame = CGRectMake(20, 15, DR_SCREEN_WIDTH-40, 160+self.infoL.frame.size.height+(_book.isMoreLines?30:0));
        _button.frame = CGRectMake(_backView.frame.size.width-60, CGRectGetMaxY(_infoL.frame),60, 30);
    }else if(self.movice){
        if (!_isShowAll) {
            self.infoL.attributedText = _movice.fiveAttTextStr;
            self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, _movice.fiveTextHeight);
            [_button setTitle:[NoticeTools getLocalStrWith:@"movie.open"] forState:UIControlStateNormal];
        }else{
            self.infoL.attributedText = _movice.allTextAttStr;
            self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, _movice.textHeight);
            [_button setTitle:[NoticeTools getLocalStrWith:@"movie.clo"] forState:UIControlStateNormal];
        }
        self.backView.frame = CGRectMake(20, 15, DR_SCREEN_WIDTH-40, 160+self.infoL.frame.size.height+(_movice.isMoreLines?30:0));
        _button.frame = CGRectMake(_backView.frame.size.width-60, CGRectGetMaxY(_infoL.frame),60, 30);
    }

  
    if (self.delegate && [self.delegate respondsToSelector:@selector(openmoreClickDelegate)]) {
        [self.delegate openmoreClickDelegate];
    }
}



- (void)setMovice:(NoticeMovie *)movice{
    _movice = movice;
    _nameL.text = movice.movie_title;
    _typeL.text = movice.movietype;
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    _scorL.text = movice.movie_score;
    _timeL.text = [NSString stringWithFormat:@"%@%@",movice.released_at,[NoticeTools getLocalStrWith:@"movie.shangying"]];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:movice.movie_poster]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    if (movice.isMoreLines) {
        self.infoL.attributedText = movice.fiveAttTextStr;
        self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, movice.fiveTextHeight);
        _button.hidden = NO;
    }else{
        self.infoL.attributedText = movice.allTextAttStr;
        self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, movice.textHeight);
        _button.hidden = YES;
    }
    self.backView.frame = CGRectMake(20, 15, DR_SCREEN_WIDTH-40, 160+self.infoL.frame.size.height+(movice.isMoreLines?30:0));
    _button.frame = CGRectMake(_backView.frame.size.width-60, CGRectGetMaxY(_infoL.frame),60, 30);
  
    [_sendBtn setTitle:[NSString stringWithFormat:@"  %@",[NoticeTools getLocalStrWith:@"movie.wantlook"]] forState:UIControlStateNormal];
    [_sendSubBtn setTitle:[NSString stringWithFormat:@"  %@",[NoticeTools getLocalStrWith:@"movie.looked"]] forState:UIControlStateNormal];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (movice.subscription_type.intValue == 1) {
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendSubBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [_sendBtn setImage:UIImageNamed(@"Image_dyyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_meikangdy") forState:UIControlStateNormal];
        
    }else if(movice.subscription_type.intValue == 2){
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        [_sendBtn setImage:UIImageNamed(@"Image_dyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_kangdy") forState:UIControlStateNormal];
        
    }else{
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendSubBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        _sendBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [_sendBtn setImage:UIImageNamed(@"Image_dyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_meikangdy") forState:UIControlStateNormal];
    }
}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    _nameL.text = song.song_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@",song.album_singer,song.album_name];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    [_sendBtn setTitle:[NSString stringWithFormat:@"  %@",[NoticeTools getLocalStrWith:@"movie.wantlisten"]] forState:UIControlStateNormal];
    [_sendSubBtn setTitle:[NSString stringWithFormat:@"  %@",[NoticeTools getLocalStrWith:@"movie.listened"]] forState:UIControlStateNormal];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (song.subscription_type.intValue == 1) {
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendSubBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [_sendBtn setImage:UIImageNamed(@"Image_dyyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_meikangdy") forState:UIControlStateNormal];
        
    }else if(song.subscription_type.intValue == 2){
        [_sendBtn setImage:UIImageNamed(@"Image_dyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_kangdy") forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
    }else{
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendSubBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        _sendBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [_sendBtn setImage:UIImageNamed(@"Image_dyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_meikangdy") forState:UIControlStateNormal];
    }

}

- (void)setBook:(NoticeBook *)book{
    _book = book;
    _nameL.text = book.book_name;
    _typeL.text = [NSString stringWithFormat:@"%@/%@/%@",book.book_author,book.book_publisher,book.published_date];
    _typeL.text = [_typeL.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
    _scorL.text = book.book_score;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:book.book_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    if (book.isMoreLines) {
        self.infoL.attributedText = book.fiveAttTextStr;
        self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, book.fiveTextHeight);
        _button.hidden = NO;
    }else{
        self.infoL.attributedText = book.allTextAttStr;
        self.infoL.frame = CGRectMake(15,160,_backView.frame.size.width-30, book.textHeight);
        _button.hidden = YES;
    }
    self.backView.frame = CGRectMake(20, 15, DR_SCREEN_WIDTH-40, 160+self.infoL.frame.size.height+(book.isMoreLines?30:0));
    _button.frame = CGRectMake(_backView.frame.size.width-60, CGRectGetMaxY(_infoL.frame),60, 30);
    
    [_sendBtn setTitle:[NSString stringWithFormat:@"  %@",[NoticeTools getLocalStrWith:@"movie.wantlook"]] forState:UIControlStateNormal];
    [_sendSubBtn setTitle:[NSString stringWithFormat:@"  %@",[NoticeTools getLocalStrWith:@"movie.looked"]] forState:UIControlStateNormal];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (book.subscription_type.intValue == 1) {
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendSubBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        
        [_sendBtn setImage:UIImageNamed(@"Image_dyyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_meikangdy") forState:UIControlStateNormal];
 
    }else if(book.subscription_type.intValue == 2){
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        [_sendBtn setImage:UIImageNamed(@"Image_dyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_kangdy") forState:UIControlStateNormal];
        
    }else{
        _sendSubBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0.0:1];
        _sendSubBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        _sendBtn.layer.borderColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.2:1].CGColor;
        [_sendBtn setImage:UIImageNamed(@"Image_dyxiangk") forState:UIControlStateNormal];
        [_sendSubBtn setImage:UIImageNamed(@"Image_meikangdy") forState:UIControlStateNormal];
    }
}


- (void)setIsBook:(BOOL)isBook{
    _isBook = isBook;
    [_sendBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.sendpinglun"]:@"發評論" forState:UIControlStateNormal];
    _markL.text =[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.chatbook"]:@"聊聊這本書";
    _markImageView.image = UIImageNamed(@"Image_sjct");
    
}

- (void)setIsSong:(BOOL)isSong{
    _isSong = isSong;
    _scorTitleL.hidden = YES;
    self.backView.frame = CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 110);
    _postImageView.frame = CGRectMake(10,10,88,88);
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,12,_backView.frame.size.width-10-CGRectGetMaxX(_postImageView.frame)-10, 22);
    _typeL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10,CGRectGetMaxY(_nameL.frame)+4,_nameL.frame.size.width,17);
    
    _infoL.frame = CGRectMake(15,225, DR_SCREEN_WIDTH-30,0);
    _button.hidden = YES;

    _sendBtn.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+10, CGRectGetMaxY(_typeL.frame)+12, 100, 28);
    _sendSubBtn.frame = CGRectMake(CGRectGetMaxX(_sendBtn.frame)+10, CGRectGetMaxY(_typeL.frame)+12, 100, 28);
}

//标记看过读过听过
- (void)sendClick{
    if (_movice) {
        if (_movice.subscription_id && _movice.subscription_type.integerValue == 2) {
            [self cancelWant:_movice.subscription_id];
            return;
        }
        [self alreadLook:YES type:1 recouseId:_movice.movie_id];
    }else if (_book){
        if (_book.subscription_id && _book.subscription_type.integerValue == 2) {
            [self cancelWant:_book.subscription_id];
            return;
        }
        [self alreadLook:YES type:2 recouseId:_book.bookId];
    }
    else if (_song){
        if (_song.subscription_id && _song.subscription_type.integerValue == 2) {
            [self cancelWant:_song.subscription_id];
            return;
        }
        [self alreadLook:YES type:3 recouseId:_song.albumId];
    }

}

//取消订阅
- (void)cancelWant:(NSString *)subscriId{
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/resourceSubscription/%@",[NoticeTools getuserId],subscriId] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (self.movice) {
                self.movice.subscription_id = nil;
                self.movice.subscription_type = nil;
                self.movice = self.movice;
            }else if (self.book){
                self.book.subscription_id = nil;
                self.book.subscription_type = nil;
                self.book = self.book;
            }else{
                self.song.subscription_id = nil;
                self.song.subscription_type = nil;
                self.song = self.song;
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

//订阅
- (void)alreadLook:(BOOL)isAlready type:(NSInteger)type recouseId:(NSString *)recouseId{
    if (!recouseId) {
        return;
    }
    
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary  new];
    [parm setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"resourceType"];
    [parm setObject:recouseId forKey:@"resourceId"];
    [parm setObject:isAlready? @"2":@"1" forKey:@"subscriptionType"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/resourceSubscription",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (type == 1) {
                self.movice.subscription_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                self.movice.subscription_type = isAlready?@"2":@"1";
                self.movice = self.movice;
            }else if (type == 2){
                self.book.subscription_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                self.book.subscription_type = isAlready?@"2":@"1";
                self.book = self.book;
            }else{
                self.song.subscription_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                self.song.subscription_type = isAlready?@"2":@"1";
                self.song = self.song;
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)sendSubClick{
    if (_movice) {
        if (_movice.subscription_id && _movice.subscription_type.integerValue == 1) {
            [self cancelWant:_movice.subscription_id];
            return;
        }
        [self alreadLook:NO type:1 recouseId:_movice.movie_id];
    }else if (_book){
        if (_book.subscription_id && _book.subscription_type.integerValue == 1) {
            [self cancelWant:_book.subscription_id];
            return;
        }
        [self alreadLook:NO type:2 recouseId:_book.bookId];
    }
    else if (_song){
        if (_song.subscription_id && _song.subscription_type.integerValue == 1) {
            [self cancelWant:_song.subscription_id];
            return;
        }
        [self alreadLook:NO type:3 recouseId:_song.albumId];
    }
}
@end
