//
//  NoticeMusicLikeShowCell.m
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMusicLikeShowCell.h"

@implementation NoticeMusicLikeShowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 65)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        
        self.songNameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30-74-15, 20)];
        self.songNameL.font = XGFourthBoldFontSize;
        self.songNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.songNameL];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, DR_SCREEN_WIDTH-30-74, 14)];
        self.nameL.font = [UIFont systemFontOfSize:10];
        self.nameL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [backView addSubview:self.nameL];

        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-74, 19, 24, 24)];
        [backView addSubview:self.likeImageView];
        
        self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-50, 19, 50, 25)];
        self.likeNumL.font = EIGHTEENTEXTFONTSIZE;
        self.likeNumL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.likeNumL];
        
        self.unreadNumL = [[UILabel alloc] init];
        self.unreadNumL.font = TWOTEXTFONTSIZE;
        self.unreadNumL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [backView addSubview:self.unreadNumL];
        
        self.likeNumL.userInteractionEnabled = YES;
        self.likeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likesTap)];
        [self.likeNumL addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likesTap)];
        [self.likeImageView addGestureRecognizer:tap2];
        
        self.playMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 16)];
        self.playMarkImageView.image = UIImageNamed(@"playmark_img");
        [backView addSubview:self.playMarkImageView];
        self.playMarkImageView.hidden = YES;
        
        self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,42, 30)];
        self.topImageView.image = UIImageNamed(@"topmark_img");
        [self.contentView addSubview:self.topImageView];
        self.topImageView.hidden = YES;
    }
    return self;
}

- (void)likesTap{
    if (!self.likeModel.likeNum.intValue) {
        [[NoticeTools getTopViewController] showToastWithText:@"这首歌还没有被喜欢过"];
        return;
    }
    if (self.gotoLikeTapBlock) {
        self.gotoLikeTapBlock(self.likeModel);
    }
}

- (void)setLikeModel:(NoticeMusicLikeModel *)likeModel{
    _likeModel = likeModel;
    self.songNameL.text = likeModel.song_tile;
    self.nameL.text = likeModel.song_author;
    self.likeNumL.text = likeModel.likeNum.intValue?likeModel.likeNum:@"0";
    self.likeImageView.image = UIImageNamed(likeModel.likeNum.intValue?@"likemusic_img":@"nolikemusic_img");
    self.unreadNumL.hidden = likeModel.readNum.intValue?NO:YES;
    self.unreadNumL.text = [NSString stringWithFormat:@"+%@",likeModel.readNum];
    self.unreadNumL.frame = CGRectMake(self.likeNumL.frame.origin.x+GET_STRWIDTH(self.likeNumL.text, 18, 25), 11, 50, 17);
    
    if (likeModel.status != 0) {
        self.playMarkImageView.hidden = NO;
        self.songNameL.frame = CGRectMake(CGRectGetMaxX(self.playMarkImageView.frame)+2, 15, DR_SCREEN_WIDTH-30-74, 20);
    }else{
        self.playMarkImageView.hidden = YES;
        self.songNameL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30-74, 20);
    }
    
    if (self.index == 0 && likeModel.likeNum.intValue) {
        self.topImageView.hidden = NO;
    }else{
        self.topImageView.hidden = YES;
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
