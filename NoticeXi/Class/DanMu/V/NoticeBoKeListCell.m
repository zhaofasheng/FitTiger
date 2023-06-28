//
//  NoticeBoKeListCell.m
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeListCell.h"

@implementation NoticeBoKeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,DR_SCREEN_WIDTH-40, 50)];
        self.titleL.font = FIFTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.titleL];
        self.titleL.numberOfLines = 0;
        
        self.likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,15, 20, 20)];
        self.likeImage.image = UIImageNamed(@"Image_curentbk");
        [self.contentView addSubview:self.likeImage];
        self.likeImage.hidden = YES;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;
    self.titleL.text = model.podcast_title;
}

- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    self.titleL.frame = CGRectMake(isChoice?44:20, 0, DR_SCREEN_WIDTH-40-24, 50);
    self.titleL.textColor = [UIColor colorWithHexString:isChoice?@"#0099E6":@"#25262E"];
    self.likeImage.hidden = isChoice?NO:YES;
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
