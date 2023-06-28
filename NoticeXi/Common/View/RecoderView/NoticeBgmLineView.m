//
//  NoticeBgmLineView.m
//  NoticeXi
//
//  Created by li lei on 2021/8/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBgmLineView.h"

@implementation NoticeBgmLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.peopleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 92, 99)];
        [self addSubview:self.peopleImageView];
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17+99, 18, 246, 50)];
        imageView.image = UIImageNamed(@"Image_bgmlineimage");
        if (appdel.backImg) {
            imageView.alpha = 0.2;
        }else{
            imageView.alpha = 1;
        }
        [self addSubview:imageView];
        self.lineImageView = imageView;
        
        self.lineL = [[UILabel alloc] initWithFrame:CGRectMake(133, 18, 210, 50)];
        self.lineL.font = FOURTHTEENTEXTFONTSIZE;
        self.lineL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.lineL];
        
    }
    return self;
}

- (void)setMusicM:(NoticeTextZJMusicModel *)musicM{
    _musicM = musicM;
    [self.peopleImageView sd_setImageWithURL:[NSURL URLWithString:musicM.state_image_url]];
    self.lineL.text = musicM.lines;
    
    self.lineImageView.frame = CGRectMake(17+99, 18, GET_STRWIDTH(self.lineL.text, 14, 50)+34, 50);
    self.lineL.frame = CGRectMake(133, 18, GET_STRWIDTH(self.lineL.text, 14, 50), 50);
}
@end
