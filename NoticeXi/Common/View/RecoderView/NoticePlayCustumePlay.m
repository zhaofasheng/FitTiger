//
//  NoticePlayCustumePlay.m
//  NoticeXi
//
//  Created by li lei on 2021/8/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePlayCustumePlay.h"

@implementation NoticePlayCustumePlay

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 36, 36)];
        self.iconImageView.layer.cornerRadius = 18;
        self.iconImageView.layer.masksToBounds = YES;
        [self addSubview:self.iconImageView];
        
        self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 13, 36, 36)];
        [self.playBtn setImage:UIImageNamed(@"Image_bfzdyyy") forState:UIControlStateNormal];
        [self addSubview:self.playBtn];
        [self.playBtn setBackgroundImage:UIImageNamed(@"Image_playcusicon") forState:UIControlStateNormal];
        
        self.songNameL = [[UILabel alloc] initWithFrame:CGRectMake(65, 16, DR_SCREEN_WIDTH-65-86, 21)];
        self.songNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.songNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.songNameL];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(65, 39, DR_SCREEN_WIDTH-65-86, 17)];
        self.nameL.font = [UIFont systemFontOfSize:12];
        self.nameL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [self addSubview:self.nameL];
        
        UIButton *musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-36, 17, 36, 36)];
        musicBtn.layer.cornerRadius = 18;
        musicBtn.layer.masksToBounds = YES;
        musicBtn.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [musicBtn setImage:UIImageNamed(@"Image_musiccubg") forState:UIControlStateNormal];
        self.musicBtn = musicBtn;
        [self addSubview:musicBtn];
    }
    return self;
}

- (void)setMusicModel:(NoticeCustumMusiceModel *)musicModel{
    
    _musicModel = musicModel;
    
    if (musicModel.status == 1) {
        [self.playBtn setImage:UIImageNamed(@"Image_ztzdyyy") forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:UIImageNamed(@"Image_bfzdyyy") forState:UIControlStateNormal];
    }
    
    if (musicModel.status != 0) {
        self.songNameL.textColor = [UIColor colorWithHexString:@"#B0DEFF"];
        self.nameL.textColor = [[UIColor colorWithHexString:@"#B0DEFF"] colorWithAlphaComponent:0.6];
    }else{
        self.songNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.nameL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
    }
    
    self.songNameL.text = musicModel.song_tile;
    self.nameL.text = musicModel.song_author;
}
@end
