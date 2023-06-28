//
//  NoticeZJCollectionCell.m
//  NoticeXi
//
//  Created by li lei on 2019/12/23.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeZJCollectionCell.h"

@implementation NoticeZJCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        //
        CGFloat imgWidth = (DR_SCREEN_WIDTH-55)/2;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        _zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, imgWidth, imgWidth)];
        _zjImageView.layer.cornerRadius = 12;
        _zjImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_zjImageView];
        
                    
        _markImgV = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth-6-24, 6, 24, 24)];
        _markImgV.image = UIImageNamed(@"Image_zjsuo");
        [_zjImageView addSubview:_markImgV];
                
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_zjImageView.frame)+10, _zjImageView.frame.size.width, 20)];
        _nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _nameL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:_nameL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_nameL.frame)+2,40, 11)];
        _timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        _timeL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timeL];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame)+2,CGRectGetMaxY(_nameL.frame)+2,40, 11)];
        _titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleL.font = [UIFont systemFontOfSize:10];
        _titleL.text = [NoticeTools getLocalStrWith:@"zj.simi"];
        [self.contentView addSubview:_titleL];
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue > 0 && appdel.alphaValue < 0.9){
            self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        }
        _zjImageView.backgroundColor = self.backgroundColor;
    }
    return self;
}

- (void)setUrlModel:(NoticeZjModel *)urlModel{
    _urlModel = urlModel;
    _zjImageView.image = UIImageNamed(self.isLimit?[NoticeTools getLocalImageNameCN:@"Image_addduihuazj"]: [NoticeTools getLocalImageNameCN:@"Image_newzjaddd"]);
    if (self.index == 0 && !self.isOther && !self.isNoshowSimi) {
        _timeL.text = @"";
        _nameL.text = @"";
        self.markImgV.hidden = YES;
        _titleL.hidden = self.markImgV.hidden;
        _zjImageView.layer.cornerRadius = 10;
    }else{
        _zjImageView.layer.cornerRadius = 0;
        if (urlModel.album_cover_url.length > 9) {
            _zjImageView.layer.cornerRadius = 5;
        }
        _timeL.text = [NSString stringWithFormat:@"%@%@",self.isLimit?urlModel.dialog_num: urlModel.voice_num,[NoticeTools chinese:@"条" english:@"posts" japan:@"投稿"]];
      
        _timeL.frame = CGRectMake(0,CGRectGetMaxY(_nameL.frame)+2,GET_STRWIDTH(_timeL.text, 10, 11), 11);
        _titleL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+10,CGRectGetMaxY(_nameL.frame)+2,40, 11);
        _nameL.text = urlModel.album_name;
        [_zjImageView sd_setImageWithURL:[NSURL URLWithString:urlModel.album_cover_url]
                          placeholderImage:UIImageNamed(@"Image_addzjdefault")
                                   options:SDWebImageRefreshCached];
        self.markImgV.hidden = urlModel.album_type.intValue == 1?YES:NO;
        _titleL.hidden = self.markImgV.hidden;
    }
    if (self.isLimit) {
        self.markImgV.hidden = YES;
        self.titleL.hidden = YES;
    }
}

@end
