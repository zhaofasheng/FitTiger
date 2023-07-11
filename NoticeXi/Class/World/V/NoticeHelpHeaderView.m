//
//  NoticeHelpHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2022/8/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpHeaderView.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeHelpHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, DR_SCREEN_WIDTH-40, 25)];
        self.titleL.font = XGEightBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.titleL];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 20, 20)];
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.layer.masksToBounds = YES;
        [self addSubview:self.iconImageView];
        self.iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
        self.userInteractionEnabled = YES;
        self.iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
        [self.iconImageView addGestureRecognizer:tap];
        
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(44, 50, 200, 20)];
        self.nickNameL.font = TWOTEXTFONTSIZE;
        self.nickNameL.text = [NoticeTools getLocalStrWith:@"help.am"];
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self addSubview:self.nickNameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, DR_SCREEN_WIDTH-40, 0)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self addSubview:self.contentL];
    }
    return self;
}

- (void)iconTap{
    if ([NoticeTools isManager]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        if (![self.helpModel.userM.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            ctl.isOther = YES;
            ctl.userId = self.helpModel.userM.userId;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)setHelpModel:(NoticeHelpListModel *)helpModel{
    _helpModel = helpModel;

    self.titleL.text = helpModel.title;
    if ([NoticeTools isManager]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:helpModel.userM.avatar_url]];
        self.nickNameL.text = helpModel.userM.nick_name;
    }
    
    self.contentL.attributedText = helpModel.allTextAttStr;
    self.contentL.frame = CGRectMake(20, 84, DR_SCREEN_WIDTH-40, helpModel.allTextHeight);
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight);
    _imageView1.hidden = YES;
    _imageView2.hidden = YES;
    _imageView3.hidden = YES;
    
    if (helpModel.img_list.count == 1) {
        self.imageView1.hidden = NO;
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:helpModel.img_list[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(image){
                self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (image.size.height/image.size.width));
                self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight+20+self.imageView1.frame.size.height);
            }
            
        }];
    }else if (helpModel.img_list.count == 2){
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:helpModel.img_list[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(image){
                self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (image.size.height/image.size.width));
                self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight+20+self.imageView1.frame.size.height);
                
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:helpModel.img_list[1]] completed:^(UIImage * _Nullable image1, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if(image1){
                        self.imageView2.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (image1.size.height/image1.size.width));
                        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight+30+self.imageView2.frame.size.height+self.imageView1.frame.size.height);
                    }
                }];
            }
        }];
    }else if (helpModel.img_list.count == 3){
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:helpModel.img_list[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(image){
                self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (image.size.height/image.size.width));
                self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight+20+self.imageView1.frame.size.height);
                
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:helpModel.img_list[1]] completed:^(UIImage * _Nullable image1, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    self.imageView2.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (image1.size.height/image1.size.width));
                    if(image1){
                        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight+30+self.imageView2.frame.size.height+self.imageView1.frame.size.height);
                    
                        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:helpModel.img_list[2]] completed:^(UIImage * _Nullable image2, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if(image2){
                                self.imageView3.frame = CGRectMake(20, CGRectGetMaxY(self.imageView2.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (image2.size.height/image2.size.width));
                                self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 84+helpModel.allTextHeight+40+self.imageView2.frame.size.height+self.imageView1.frame.size.height+self.imageView3.frame.size.height);
                            }
             
                        }];
                    }
               
                }];
            }

        }];
    }
}

- (UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-40, 0)];
        [self addSubview:_imageView1];
        _imageView1.layer.cornerRadius = 5;
        _imageView1.layer.masksToBounds = YES;
        _imageView1.hidden = YES;
        _imageView1.userInteractionEnabled = YES;
        _imageView1.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook:)];
        [_imageView1 addGestureRecognizer:tap];

    }
    return _imageView1;
}

- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_imageView1.frame)+10, DR_SCREEN_WIDTH-40, 0)];
        [self addSubview:_imageView2];
        _imageView2.layer.cornerRadius = 5;
        _imageView2.layer.masksToBounds = YES;
        _imageView2.hidden = YES;
        _imageView2.tag = 1;
        _imageView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook:)];
        [_imageView2 addGestureRecognizer:tap];

    }
    return _imageView2;
}

- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_imageView2.frame)+10, DR_SCREEN_WIDTH-40, 0)];
        [self addSubview:_imageView3];
        _imageView3.layer.cornerRadius = 5;
        _imageView3.layer.masksToBounds = YES;
        _imageView3.hidden = YES;
        _imageView3.tag = 2;
        _imageView3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook:)];
        [_imageView3 addGestureRecognizer:tap];

    }
    return _imageView3;
}

- (void)bigLook:(UITapGestureRecognizer *)tap{
    UIImageView *tapImg = (UIImageView *)tap.view;
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = tapImg;
    item.largeImageURL = [NSURL URLWithString:self.helpModel.img_list[tapImg.tag]];
    NSMutableArray *_photosItemArr = [[NSMutableArray alloc] init];
    [_photosItemArr addObject:item];
    
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:_photosItemArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [view presentFromImageView:tapImg
                   toContainer:toView
                      animated:YES completion:nil];
}

@end
