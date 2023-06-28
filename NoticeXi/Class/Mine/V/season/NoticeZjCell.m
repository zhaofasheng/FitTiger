//
//  NoticeZjCell.m
//  NoticeXi
//
//  Created by li lei on 2019/8/13.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZjCell.h"

@implementation NoticeZjCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [GetColorWithName(VlistColor) colorWithAlphaComponent:0];
        _zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-60-16)/3, (DR_SCREEN_WIDTH-60-16)/3)];
        _zjImageView.layer.cornerRadius = 5;
        _zjImageView.layer.masksToBounds = YES;
        _zjImageView.backgroundColor = [NoticeTools getWhiteColor:@"#FAFAFA" NightColor:@"#222238"];

        [self.contentView addSubview:_zjImageView];
        
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _zjImageView.frame.size.width, _zjImageView.frame.size.height)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            [_zjImageView addSubview:mbView];
            self.mbView = mbView;
        }
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(8,_zjImageView.frame.size.height-8-11, _zjImageView.frame.size.width-16, 11)];
        _timeL.textColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#B2B2B2"];
        _timeL.font = ELEVENTEXTFONTSIZE;
        [_zjImageView addSubview:_timeL];
        
        _markImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0 )];
        [_zjImageView addSubview:_markImgV];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, _zjImageView.frame.size.width, _zjImageView.frame.size.height)];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.numberOfLines = 2;
        _titleL.textColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3E3E4A"];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        [_zjImageView addSubview:_titleL];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_zjImageView.frame)+10, _zjImageView.frame.size.width, 13)];
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.textColor = [NoticeTools getWhiteColor:@"#666666" NightColor:@"72727f"];
        _nameL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:_nameL];
    }
    return self;
}


- (void)setZjModel:(NoticeZjModel *)zjModel{
    _nameL.text = zjModel.defaultName;
    if (zjModel.defaultName.length) {
        NSString *str = [NSString stringWithFormat:@"%@%@",zjModel.defaultImage,[NoticeTools isWhiteTheme]?@"":@"y"];
        _zjImageView.image = UIImageNamed(str);
        _zjImageView.alpha = 1;
    }else{
        _zjImageView.image = GETUIImageNamed(@"img_empty");
        _zjImageView.alpha = 0;
    }
}

- (void)setUrlModel:(NoticeZjModel *)urlModel{
    _urlModel = urlModel;
    _timeL.text = urlModel.voice_total_mins;
    _zjImageView.alpha = 1;
    _nameL.text = urlModel.album_name;
    [_zjImageView sd_setImageWithURL:[NSURL URLWithString:urlModel.album_cover_url]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    if ([urlModel.album_type isEqualToString:@"2"]) {
        _markImgV.hidden = NO;
        _markImgV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_hylock":@"Image_hylocky");
        _markImgV.frame = CGRectMake(_zjImageView.frame.size.width-8-15, 8, 15, 14);
    }else if ([urlModel.album_type isEqualToString:@"3"]){
        _markImgV.hidden = NO;
        _markImgV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_similock":@"Image_similocky");
        _markImgV.frame = CGRectMake(_zjImageView.frame.size.width-8-11, 8, 15, 14);
    }else{
        _markImgV.hidden = YES;
    }
    
    if (self.isLimit) {
        _timeL.hidden = NO;
        _timeL.text = [NSString stringWithFormat:@"%@%@条",[NoticeTools getLocalStrWith:@"groupImg.g"],urlModel.dialog_num.intValue?urlModel.dialog_num:@"0"];
        if ([NoticeTools getLocalType] == 1) {
            _timeL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"groupImg.g"],urlModel.dialog_num.intValue?urlModel.dialog_num:@"0"];
        }
    }
    if (self.isText) {
        _timeL.text = urlModel.textNum;
    }
}

- (void)setNofirModel:(NoticeZjModel *)nofirModel{
    _nofirModel = nofirModel;
    if ([nofirModel.album_type isEqualToString:@"1"]) {
        _timeL.hidden = NO;
        _timeL.text = nofirModel.voice_total_mins;
        _nameL.text = nofirModel.album_name;
        [_zjImageView sd_setImageWithURL:[NSURL URLWithString:nofirModel.album_cover_url]
                          placeholderImage:GETUIImageNamed(@"img_empty")
                                   options:SDWebImageRefreshCached];
    }else{
        _timeL.hidden = YES;
        _markImgV.hidden = YES;
        _nameL.text = [nofirModel.album_type isEqualToString:@"3"]?[NoticeTools getLocalStrWith:@"zj.simizj"]:[NoticeTools getLocalStrWith:@"zj.justxueyou"];
        _zjImageView.image = [nofirModel.album_type isEqualToString:@"3"]?UIImageNamed([NoticeTools isWhiteTheme]?@"Image_yulansimi":@"Image_yulansimiy"):UIImageNamed([NoticeTools isWhiteTheme]?@"Image_yulanhy":@"Image_yulanhyy");//
    }
    if (self.isLimit) {
        _timeL.hidden = NO;
        _timeL.text = [NSString stringWithFormat:@"%@%@条",[NoticeTools getLocalStrWith:@"groupImg.g"],nofirModel.dialog_num.intValue?nofirModel.dialog_num:@"0"];
        if ([NoticeTools getLocalType] == 1) {
            _timeL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"groupImg.g"],nofirModel.dialog_num.intValue?nofirModel.dialog_num:@"0"];
        }
    }
    if (self.isText) {
        _timeL.text = nofirModel.textNum;
    }
}

- (void)setFirModel:(NoticeZjModel *)firModel{
    _firModel = firModel;
    if ([firModel.album_type isEqualToString:@"1"]) {
        _timeL.hidden = NO;
        _timeL.text = firModel.voice_total_mins;
        _nameL.text = firModel.album_name;
        [_zjImageView sd_setImageWithURL:[NSURL URLWithString:firModel.album_cover_url]
                        placeholderImage:GETUIImageNamed(@"img_empty")
                                 options:SDWebImageRefreshCached];
    }else if ([firModel.album_type isEqualToString:@"2"]){
        _markImgV.hidden = NO;
        _markImgV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_hylock":@"Image_hylocky");
        _markImgV.frame = CGRectMake(_zjImageView.frame.size.width-8-15, 8, 15, 14);
        _timeL.hidden = NO;
        _timeL.text = firModel.voice_total_mins;
        _nameL.text = firModel.album_name;
        [_zjImageView sd_setImageWithURL:[NSURL URLWithString:firModel.album_cover_url]
                        placeholderImage:GETUIImageNamed(@"img_empty")
                                 options:SDWebImageRefreshCached];
    }
    else{
        _timeL.hidden = YES;
        _markImgV.hidden = YES;
        _nameL.text = [NoticeTools getLocalStrWith:@"zj.simizj"];
        _zjImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_yulansimi":@"Image_yulansimiy");//
    }
    if (self.isLimit) {
        _timeL.hidden = NO;
        _timeL.text = [NSString stringWithFormat:@"%@%@条",[NoticeTools getLocalStrWith:@"groupImg.g"],firModel.dialog_num.intValue?firModel.dialog_num:@"0"];
        if ([NoticeTools getLocalType] == 1) {
            _timeL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"groupImg.g"],firModel.dialog_num.intValue?firModel.dialog_num:@"0"];
        }
    }
    if (self.isText) {
        _timeL.text = firModel.textNum;
    }
}
@end
