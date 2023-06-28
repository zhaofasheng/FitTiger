//
//  NoticeUserCenterCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserCenterCell.h"

@implementation NoticeUserCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, (65-22)/2, 22, 22)];
        _titleImageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_titleImageV];
        
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleImageV.frame)+15, 0, (DR_SCREEN_WIDTH-15-CGRectGetMaxX(_titleImageV.frame)-10-15-16)/2+70, 65)];
        _mainL.textColor = GetColorWithName(VMainTextColor);
        _mainL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:_mainL];
        
        _subL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-9-10-60, 0,60, 65)];
        _subL.textColor = GetColorWithName(VDarkTextColor);
        _subL.font = FOURTHTEENTEXTFONTSIZE;
        _subL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subL];
        
        _subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-9, (65-16)/2, 9, 16)];
        _subImageV.image = GETUIImageNamed(@"cellnextbutton");
        [self.contentView addSubview:_subImageV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64.5, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        _line = line;
        [self.contentView addSubview:line];
        //30+22+28+25
        _photosArr = [NSMutableArray new];
        for (int i = 0; i < 4; i++) {
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(30+22+28+25+52*i,23/2, 42, 42)];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
            photoView.layer.cornerRadius = 7;
            photoView.layer.masksToBounds = YES;
            photoView.tag = i;
            photoView.userInteractionEnabled = YES;
            [self.photosArr addObject:photoView];
        }
    }
    return self;
}

- (void)setPhotosUrlArr:(NSMutableArray *)photosUrlArr{
    _photosUrlArr = photosUrlArr;
    for (UIImageView *imageViews in _photosArr) {
        [imageViews removeFromSuperview];
    }
    for (int i = 0; i < photosUrlArr.count;i++) {
        UIImageView *imageV = _photosArr[i];
        NSArray *array = [photosUrlArr[i] componentsSeparatedByString:@"?"];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:array[0]]] placeholderImage:GETUIImageNamed(@"img_empty")];
        [self.contentView addSubview:imageV];
    }
}

- (void)changeColor{
    self.backgroundColor = GetColorWithName(VBackColor);
   _mainL.textColor = GetColorWithName(VMainTextColor);
   _subL.textColor = GetColorWithName(VDarkTextColor);
    _line.backgroundColor = GetColorWithName(VlineColor);
    _subImageV.image = GETUIImageNamed(@"cellnextbutton");
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
