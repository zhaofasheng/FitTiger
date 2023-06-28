//
//  NoticeJoinTextAlbumController.m
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeJoinTextAlbumController.h"
#import "NoticeAddZjController.h"
#import "NoticeTextZJDetailView.h"
#import "NoticeTextZJContentView.h"
#import "NoticeVoiceImageView.h"
#import "NoticeTextZJMusicView.h"
@interface NoticeJoinTextAlbumController ()
@property (nonatomic, strong) NoticeTextZJDetailView *listView;
@property (nonatomic, strong) NoticeTextZJContentView *contentView;
@property (nonatomic, strong) NoticeVoiceImageView *imageViewS;
@property (nonatomic, strong) NoticeTextZJMusicView *musicView;

@property (nonatomic, assign) NSInteger playTag;
@property (nonatomic, assign) BOOL contuine;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UILabel *nameL;
@end

@implementation NoticeJoinTextAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView removeFromSuperview];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
    [self.view addSubview:backImageView];
    [backImageView sd_setImageWithURL:[NSURL URLWithString:self.zjModel.album_cover_url]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    
    self.imageViewS = [[NoticeVoiceImageView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
    [self.view addSubview:self.imageViewS];
    self.imageViewS.isOther = YES;
    //self.imageViewS.delegate = self;
    self.imageViewS.hidden = YES;

    self.musicView.hidden = YES;
    self.listView.hidden = YES;
    self.contentView.hidden = NO;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textzjb_b":@"Image_textzjb_y") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    if (!self.isOther) {
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [setBtn setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"img_textzjset_b":@"img_textzjset_y") forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:setBtn];
    }
    
    self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backImageView.frame)-40, DR_SCREEN_WIDTH-15-5, 40)];
    self.nameL.textColor = GetColorWithName(VMainThumeWhiteColor);
    self.nameL.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.nameL];
    // 阴影颜色
    self.nameL.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    // 阴影偏移
    self.nameL.shadowOffset = CGSizeMake(1, 1);
    self.nameL.text = self.zjModel.album_name;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setClick{
    NoticeAddZjController *ctl = [[NoticeAddZjController alloc] init];
    ctl.isEditAblum = YES;
    ctl.isText = YES;
    ctl.zjmodel = self.zjModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.contuine = NO;
    [self.audioPlayer stopPlaying];
    [self stopAnimtion];
}


- (NoticeTextZJDetailView *)listView{
    if (!_listView) {
        _listView = [[NoticeTextZJDetailView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH)];
        _listView.userId = self.userId?self.userId:[NoticeTools getuserId];
        _listView.zjModel = self.zjModel;
        [_listView.musicBtn addTarget:self action:@selector(musicClick) forControlEvents:UIControlEventTouchUpInside];
        [_listView.contentBtn addTarget:self action:@selector(contentClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_listView];
        _listView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _listView.getDataBlock = ^(NSMutableArray * _Nonnull arr) {
            weakSelf.contentView.dataArr = arr;

        };
        
        _listView.choiceDataBlock = ^(NoticeVoiceListModel * _Nonnull model) {
            weakSelf.contentView.currentModel = model;
            weakSelf.imageViewS.imgArr = model.img_list;
            weakSelf.imageViewS.hidden = model.img_list.count?NO:YES;
            [weakSelf contentClick];
        };
        _listView.getFirstBlock = ^(NoticeVoiceListModel * _Nonnull model) {
            weakSelf.imageViewS.imgArr = model.img_list;
            weakSelf.imageViewS.hidden = model.img_list.count?NO:YES;
        };
    }
    return _listView;
}

- (NoticeTextZJContentView *)contentView{
    if (!_contentView) {
        _contentView = [[NoticeTextZJContentView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH)];
        _contentView.userId = self.userId?self.userId:[NoticeTools getuserId];
        _contentView.zjModel = self.zjModel;
        [_contentView.musicBtn addTarget:self action:@selector(musicClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.listBtn addTarget:self action:@selector(listClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_contentView];
        __weak typeof(self) weakSelf = self;
        _contentView.getCurrentBlock = ^(NoticeVoiceListModel * _Nonnull model) {
            weakSelf.imageViewS.imgArr = model.img_list;
            weakSelf.imageViewS.hidden = model.img_list.count?NO:YES;
        };
        _contentView.hidden = YES;
    }
    return _contentView;
}

- (NoticeTextZJMusicView *)musicView{
    if (!_musicView) {
        _musicView = [[NoticeTextZJMusicView alloc] initWithFrame:self.contentView.frame];
        [self.view addSubview:_musicView];
        __weak typeof(self) weakSelf = self;
        _musicView.musicTapBlock = ^(NSInteger tap) {
            [weakSelf.contentView.musicBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textmusicp_b":@"Image_textmusicp_y") forState:UIControlStateNormal];
            [weakSelf.listView.musicBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textmusicp_b":@"Image_textmusicp_y") forState:UIControlStateNormal];
            weakSelf.playTag = tap;
            weakSelf.contuine = YES;
            [weakSelf playClick:tap];
            [weakSelf startAnimation];
        };
        _musicView.stopMusicTapBlock = ^(BOOL stop) {
            weakSelf.contuine = NO;
            [weakSelf.audioPlayer stopPlaying];
        };
        [_musicView.musicBtn addTarget:self action:@selector(backMusicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _musicView;
}

- (void)startAnimation{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;

    [self.contentView.musicBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self.listView.musicBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimtion{
    [self.contentView.musicBtn.layer removeAllAnimations];
    [self.listView.musicBtn.layer removeAllAnimations];
}

- (void)playClick:(NSInteger)tag{
    
    [self.audioPlayer startPlayWithUrl:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"music%ld",tag] ofType:@"mp3"] isLocalFile:YES];
    
    __weak typeof(self) weakSelf = self;

    self.audioPlayer.playComplete = ^{
        if (weakSelf.contuine) {
            [weakSelf playClick:weakSelf.playTag];
        }
    };
}

- (void)backMusicClick{
    self.musicView.hidden = YES;
}

- (void)musicClick{
    self.musicView.hidden = NO;
    [self.view bringSubviewToFront:self.musicView];
}

- (void)listClick{
    self.listView.hidden = NO;
    self.contentView.hidden = YES;
}

- (void)contentClick{
    self.listView.hidden = YES;
    self.contentView.hidden = NO;
}

@end
