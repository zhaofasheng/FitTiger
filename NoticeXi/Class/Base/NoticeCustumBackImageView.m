//
//  NoticeCustumBackImageView.m
//  NoticeXi
//
//  Created by li lei on 2021/8/12.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustumBackImageView.h"

@implementation NoticeCustumBackImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.svagPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        _svagPlayer.userInteractionEnabled = YES;
        _svagPlayer.loops = INT16_MAX;
        _svagPlayer.clearsAfterStop = YES;
        _svagPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _svagPlayer.clipsToBounds = YES;
        self.parser = [[SVGAParser alloc] init];
        //bottombig
        [self.parser parseWithNamed:@"paopao" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:self.svagPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:@"NOTICECHANGESKINNOTICIONHS" object:nil];
        [self changeSkin];

    }
    return self;
}


- (void)setNoNeedPaopao:(BOOL)noNeedPaopao{
    _noNeedPaopao = noNeedPaopao;
    self.svagPlayer.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTICECHANGESKINNOTICIONHS" object:nil];
}

- (void)changeSkin{
    if (self.noNeedPaopao) {
        return;
    }
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (userM.spec_bg_type.intValue == 1) {
        [self.parser parseWithNamed:@"paopao" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];
        self.svagPlayer.hidden = NO;

    }else if (userM.spec_bg_type.intValue == 4){
        [self.parser parseWithURL:[NSURL URLWithString:userM.spec_bg_svg_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];
        self.svagPlayer.hidden = NO;

        
    }
    else{
        [self.svagPlayer pauseAnimation];
        self.svagPlayer.hidden = YES;
    }

}

@end
