//
//  NoticeTextZJDetailCell.m
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextZJDetailCell.h"

@implementation NoticeTextZJDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 35)];
        self.titleL.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:self.titleL];
        
        _lockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-18,(35-18)/2, 18, 18)];
        _lockImageV.image = UIImageNamed(@"Imagelock");
        _lockImageV.hidden = YES;
        [self.contentView addSubview: _lockImageV];
    }
    return self;
}

- (void)setVocieM:(NoticeVoiceListModel *)vocieM{
    _vocieM = vocieM;
    self.lockImageV.hidden = _vocieM.is_private.integerValue?NO:YES;
    self.titleL.text = [NSString stringWithFormat:@"%@   %@",_vocieM.textListTime,_vocieM.title?_vocieM.title:_vocieM.textContent];
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
