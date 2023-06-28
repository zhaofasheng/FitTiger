//
//  NoticeCustumeMusiceCell.m
//  NoticeXi
//
//  Created by li lei on 2021/8/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustumeMusiceCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeCustumeMusiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 36, 36)];
        self.iconImageView.layer.cornerRadius = 18;
        self.iconImageView.image = UIImageNamed(@"Image_whitemusicicon");
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 36, 36)];
        [self.playBtn setImage:UIImageNamed(@"Image_bfzdyyy") forState:UIControlStateNormal];
        self.playBtn.enabled = NO;
        [self.contentView addSubview:self.playBtn];
        
        self.songNameL = [[UILabel alloc] initWithFrame:CGRectMake(65, 9, DR_SCREEN_WIDTH-65-86, 20)];
        self.songNameL.font = FOURTHTEENTEXTFONTSIZE;
        self.songNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.songNameL];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(65, 29, DR_SCREEN_WIDTH-65-86, 14)];
        self.nameL.font = [UIFont systemFontOfSize:10];
        self.nameL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:0.6];
        [self.contentView addSubview:self.nameL];
        
        UIButton *useBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-86, 21, 36, 20)];
        useBtn.layer.cornerRadius = 4;
        useBtn.layer.masksToBounds = YES;
        useBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [useBtn setTitle:[NoticeTools getLocalStrWith:@"songList.use"] forState:UIControlStateNormal];
        [useBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        useBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        useBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:useBtn];
        [useBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        self.useButton = useBtn;
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(useBtn.frame)+10,18, 20, 20)];
        [moreBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreBtn];
        [moreBtn setImage:UIImageNamed(@"ly_sczdiy") forState:UIControlStateNormal];
        self.addBtn = moreBtn;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)deleteClick{
    if (self.isOther) {
        if (self.musicModel.is_like.boolValue) {
            [[NoticeTools getTopViewController] showToastWithText:[NoticeTools chinese:@"这首歌已经喜欢过啦" english:@"Already liked" japan:@"すでに気に入った"]];
            return;
        }
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.musicModel.songId forKey:@"musicId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/musicLike",self.userId] Accept:@"application/vnd.shengxi.v5.3.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                self.musicModel.is_like = @"1";
                [self.addBtn setImage:UIImageNamed(self.musicModel.is_like.boolValue?@"likemusic_img":@"nolikemusic_img") forState:UIControlStateNormal];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        return;
    }
    if (self.deletesMusicBlock) {
        self.deletesMusicBlock(self.musicModel);
    }
}

- (void)addClick{
    
    if (self.isSend) {
        if (self.useMusicBlock) {
            self.useMusicBlock(self.musicModel);
        }
        return;
    }
    
    if (self.isAddToMusicList) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showHUD];
        
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"joinOnly/%@",self.musicModel.songId] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                self.musicModel.is_only = self.musicModel.is_only.boolValue?@"0":@"1";
                [self.useButton setImage:UIImageNamed(self.musicModel.is_only.boolValue?@"Image_hasaddmusic":@"Image_addtomusic") forState:UIControlStateNormal];
                if (self.addMusicBlock) {
                    self.addMusicBlock(YES);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEREFRESHMUSIC" object:nil];
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }

}

- (void)setMusicModel:(NoticeCustumMusiceModel *)musicModel{
    
    _musicModel = musicModel;
    
    if (musicModel.status == 1) {
        [self.playBtn setImage:UIImageNamed(@"Image_ztzdyyy") forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:UIImageNamed(@"Image_bfzdyyy") forState:UIControlStateNormal];
    }
    
    if (!self.isSend) {
        if (self.isAddToMusicList) {
            self.useButton.userInteractionEnabled = YES;
            self.useButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            [self.useButton setTitle:@"" forState:UIControlStateNormal];
            [self.useButton setImage:UIImageNamed(musicModel.is_only.boolValue?@"Image_hasaddmusic":@"Image_addtomusic") forState:UIControlStateNormal];
        }else{
            if (musicModel.isSelect) {
                [self.useButton setTitle:[NoticeTools getLocalStrWith:@"songList.useing"] forState:UIControlStateNormal];
                self.useButton.backgroundColor = [UIColor colorWithHexString:@"#B8BECC"];
            }else{
                [self.useButton setTitle:[NoticeTools getLocalStrWith:@"songList.use"] forState:UIControlStateNormal];
                self.useButton.backgroundColor = [UIColor colorWithHexString:@"#65AFE6"];
            }
        }
    }else{
        self.useButton.userInteractionEnabled = YES;
    }

    
    if (self.isMyMusicList) {
        self.useButton.hidden = YES;
    }
    
    if (musicModel.status != 0) {
        //Image_bfzdyyy
        self.songNameL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        self.nameL.textColor = [[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:0.6];
        self.iconImageView.image = UIImageNamed(@"Image_playcusicon");
    }else{
        self.songNameL.textColor = [UIColor colorWithHexString:self.isSend?@"#25262E":@"#25262E"];
        self.nameL.textColor = [[UIColor colorWithHexString:self.isSend?@"#25262E":@"#8A8F99"] colorWithAlphaComponent:0.6];
        self.iconImageView.image = UIImageNamed(@"Image_whitemusicicon");
    }

    self.songNameL.text = musicModel.song_tile;
    self.nameL.text = musicModel.song_author;
    
    if (self.isOther) {
        [self.addBtn setImage:UIImageNamed(musicModel.is_like.boolValue?@"likemusic_img":@"nolikemusic_img") forState:UIControlStateNormal];
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
