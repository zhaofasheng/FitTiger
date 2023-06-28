//
//  NoticeFindSameCell.m
//  NoticeXi
//
//  Created by li lei on 2019/4/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFindSameCell.h"
#import "DDHAttributedMode.h"
@implementation NoticeFindSameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,9, 38, 38)];
        _iconImageView.layer.cornerRadius = 38/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(23+_iconImageView.frame.origin.x, 23+_iconImageView.frame.origin.y, 15, 15)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+15, 8,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-10-130,38)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-130,9,130,38)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_timeL];
        _timeL.textAlignment = NSTextAlignmentRight;
     
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_nickNameL.frame.origin.x,53 , DR_SCREEN_WIDTH-_nickNameL.frame.origin.x, 1)];
        line.backgroundColor = GetColorWithName(VlineColor);
        _line = line;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setSameModel:(NoticeFindSame *)sameModel{
    _sameModel = sameModel;
    
    if ([sameModel.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([sameModel.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([sameModel.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }else{
        self.markImage.hidden = YES;
    }
    
    _nickNameL.text = sameModel.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:sameModel.avatar_url]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    if (self.isSong) {
        NSString *str = [NoticeTools isSimpleLau]?@"首共同最爱的歌":@"首共同最愛的歌";
        _timeL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",sameModel.common_num,str] setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:sameModel.common_num beginSize:0];
    }else if (self.isBook){
        NSString *str = [NoticeTools isSimpleLau]?@"本共同喜欢的书":@"本共同喜歡的書";
        _timeL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",sameModel.common_num,str] setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:sameModel.common_num beginSize:0];
    }
    else{
       _timeL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",sameModel.common_num,GETTEXTWITE(@"listen.wdthdys")] setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:sameModel.common_num beginSize:0];
    }
    
}
@end
