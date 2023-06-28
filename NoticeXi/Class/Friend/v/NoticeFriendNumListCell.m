//
//  NoticeFriendNumListCell.m
//  NoticeXi
//
//  Created by li lei on 2019/3/6.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFriendNumListCell.h"

@implementation NoticeFriendNumListCell
{
    UIImageView *_backImageView;
    UILabel *_listL;
    UILabel *_friendNumL;
    UILabel *_nameLabeL;
    UILabel *_infoL;
    UIButton *_button;
    UIView *_mbView;
    UIImageView *_recodImageView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [NoticeTools isWhiteTheme] ? GetColorWithName(VBackColor) : GetColorWithName(VlistColor);
        
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(15,7.5, DR_SCREEN_WIDTH-30, 180)];
        shadowView.userInteractionEnabled = YES;
        shadowView.layer.shadowOffset = CGSizeZero;
        shadowView.layer.shadowOpacity = 0.7;
        shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        [self.contentView addSubview:shadowView];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 180)];
        _backImageView.layer.cornerRadius = 15;
        _backImageView.layer.masksToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        _backImageView.backgroundColor = self.backgroundColor;
        _backImageView.userInteractionEnabled = YES;
        [shadowView addSubview:_backImageView];
        
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 180)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [_backImageView addSubview:mbView];
        }
        
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backImageView.frame.size.width, _backImageView.frame.size.height)];
        mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_backImageView addSubview:mbView];
        mbView.hidden = YES;
        _mbView = mbView;
        
        _listL = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 65, 15)];
        _listL.font = FIFTHTEENTEXTFONTSIZE;
        _listL.textColor = [NoticeTools isWhiteTheme] ? [UIColor whiteColor]:[UIColor colorWithHexString:@"#cccccc"];
        _listL.textAlignment = NSTextAlignmentCenter;
        [_backImageView addSubview:_listL];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(_listL.frame)+24,71,71)];
        whiteView.layer.cornerRadius = 71/2;
        whiteView.layer.masksToBounds = YES;
        whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        [_backImageView addSubview:whiteView];
        _whiteV = whiteView;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 65, 65)];
        _iconImageView.layer.cornerRadius = 65/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        [whiteView addSubview:_iconImageView];
        
        UIImageView *voiceImag = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(whiteView.frame)-24,CGRectGetMaxY(whiteView.frame)-24,24,24)];
        voiceImag.image = UIImageNamed(@"Image_voice_hy");
        voiceImag.userInteractionEnabled = YES;
        [_backImageView addSubview:voiceImag];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlay)];
        [voiceImag addGestureRecognizer:tap];
        
        _nameLabeL = [[UILabel alloc] initWithFrame:CGRectMake(30,_backImageView.frame.size.height-20-17,GET_STRWIDTH(@"是个文字是个文字是个文字", 15, 15), 17)];
        _nameLabeL.textColor = _listL.textColor;
        _nameLabeL.font = FIFTHTEENTEXTFONTSIZE;
        [_backImageView addSubview:_nameLabeL];
        
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(whiteView.frame)+45, whiteView.frame.origin.y, _backImageView.frame.size.width-CGRectGetMaxX(whiteView.frame)-75, 68)];
        _infoL.textColor = _listL.textColor;
        _infoL.numberOfLines = 0;
        _infoL.font = FIFTHTEENTEXTFONTSIZE;
        _infoL.textAlignment = NSTextAlignmentRight;
        [_backImageView addSubview:_infoL];
        
        _friendNumL = [[UILabel alloc] initWithFrame:CGRectMake(_backImageView.frame.size.width-30-75-40, _nameLabeL.frame.origin.y+1.5, 75+40, 12)];
        _friendNumL.textColor = _listL.textColor;
        _friendNumL.font = TWOTEXTFONTSIZE;
        _friendNumL.textAlignment = NSTextAlignmentRight;
        [_backImageView addSubview:_friendNumL];
    
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button addTarget:self action:@selector(addOrChangeClick) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [_backImageView addSubview:_button];
        
        _recodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 54)];
        [_backImageView addSubview:_recodImageView];
    }
    return self;
}

- (void)tapPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVoiceWith:)]) {
        [self.delegate playVoiceWith:self.index];
    }
}

- (void)addOrChangeClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonInCellWith:)]) {
        [self.delegate clickButtonInCellWith:self.index];
    }
}

- (void)setPeople:(NoticeFriendNum *)people{
    _listL.text = people.paiHang;
    if ([people.userId isEqualToString:[NoticeTools getuserId]] && people.paiHang.integerValue > 50) {
        _listL.text = @"";
    }
    NSString *imagName = [NSString stringWithFormat:@"Image_hy%@",people.yushu];
    _backImageView.image = UIImageNamed(imagName);
    if (people.friend_card_url && people.friend_card_url.length > 8) {
        _mbView.hidden = NO;
    }else{
        _mbView.hidden = YES;
    }
   
    if (people.paiHang.integerValue > 3) {
        _listL.hidden = NO;
        _recodImageView.hidden = YES;
    }else{
        _recodImageView.hidden =  NO;
        _listL.hidden = YES;
        _recodImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Image_recode_%@",people.paiHang]];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:people.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    _nameLabeL.text = people.nick_name;
    
    if (GET_STRWIDTH(people.nick_name, 15, 17) <= 65) {
        _nameLabeL.frame = CGRectMake(30,_backImageView.frame.size.height-20-17,65, 17);
        _nameLabeL.textAlignment = NSTextAlignmentCenter;
    }else{
        _nameLabeL.frame = CGRectMake(30,_backImageView.frame.size.height-20-17,GET_STRWIDTH(@"是个文字是个文字是个文字", 15, 15), 17);
        _nameLabeL.textAlignment = NSTextAlignmentLeft;
    }
    
    _infoL.text = (people.self_intro.length && people.self_intro) ? people.self_intro:GETTEXTWITE(@"set.nojianjie");
    
    NSString *str = [NoticeTools isSimpleLau]?@"首唱回忆":@"首唱回憶";
    
    _friendNumL.text = [NSString stringWithFormat:@"有%@%@",people.song_num,str];
    
    if ([people.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        _button.frame = CGRectMake(_backImageView.frame.size.width-30-25, 20, 65, 20);
        [_button setBackgroundImage:nil forState:UIControlStateNormal];
        [_button setImage:UIImageNamed(@"self_card_chimg") forState:UIControlStateNormal];
        [_button setTitle:@"  " forState:UIControlStateNormal];
        _button.hidden = NO;
        _button.enabled = YES;
        if (people.cardImage) {
            _backImageView.image = people.cardImage;
        }else{
            [_backImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:people.friend_card_url]]
                              placeholderImage:UIImageNamed(imagName)
                                       options:SDWebImageRefreshCached];
        }
        _button.hidden = NO;
    }else{
        _button.hidden = YES;
        [_backImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:people.friend_card_url]]
                          placeholderImage:UIImageNamed(imagName)
                                   options:SDWebImageRefreshCached];
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
