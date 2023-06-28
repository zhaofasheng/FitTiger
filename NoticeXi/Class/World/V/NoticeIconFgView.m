//
//  NoticeIconFgView.m
//  NoticeXi
//
//  Created by li lei on 2023/2/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeIconFgView.h"
#import "NoticeHelpCommentModel.h"
#import "NoticeMusicLikeModel.h"
@implementation NoticeIconFgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.viewArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16*i, 0, frame.size.height, frame.size.height)];
            imageView.layer.cornerRadius = frame.size.height/2;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
            if (i==0) {
                self.imageV1 = imageView;
            }else if (i == 1){
                self.imageV2 = imageView;
            }else if (i == 2){
                self.imageV3 = imageView;
            }
            else if (i == 3){
                self.imageV4 = imageView;
            }
            else if (i == 4){
                self.imageV5 = imageView;
            }
            [self.viewArr addObject:imageView];
        }
    }
    return self;
}

- (void)setIconSongArr:(NSMutableArray *)iconSongArr{
    _iconSongArr = iconSongArr;
    self.imageV1.hidden = YES;
    self.imageV2.hidden = YES;
    self.imageV3.hidden = YES;
    self.imageV4.hidden = YES;
    self.imageV5.hidden = YES;
    if (iconSongArr.count) {
        for (int i = 0; i < iconSongArr.count; i++) {
            if (i <= self.viewArr.count -1) {
                NoticeMusicLikeModel *model = iconSongArr[i];
                UIImageView *imageV = self.viewArr[i];
                imageV.hidden = NO;
                [imageV sd_setImageWithURL:[NSURL URLWithString:model.avatar_url]];
            }else{
                break;
            }
        }
    }
}

- (void)setIconArr:(NSArray *)iconArr{
    _iconArr = iconArr;
    self.imageV1.hidden = YES;
    self.imageV2.hidden = YES;
    self.imageV3.hidden = YES;
    self.imageV4.hidden = YES;
    self.imageV5.hidden = YES;
    if (iconArr.count) {
        for (int i = 0; i < iconArr.count; i++) {
            if (i <= self.viewArr.count -1) {
                UIImageView *imageV = self.viewArr[i];
                imageV.hidden = NO;
                [imageV sd_setImageWithURL:[NSURL URLWithString:iconArr[i]]];
            }else{
                break;
            }
        }
    }

}
@end
