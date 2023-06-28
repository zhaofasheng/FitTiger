//
//  NoticeNewTopicCell.m
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewTopicCell.h"

@implementation NoticeNewTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 24)];
        self.topicL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.topicL.font = ELEVENTEXTFONTSIZE;
        self.topicL.textAlignment = NSTextAlignmentCenter;
        self.topicL.layer.cornerRadius = 12;
        self.topicL.layer.masksToBounds = YES;
        self.topicL.layer.borderWidth = 1;
        self.topicL.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        [self.contentView addSubview:self.topicL];
    }
    return self;
}

- (void)setTopicM:(NoticeTopicModel *)topicM{
    _topicM = topicM;
    self.topicL.text = topicM.name;
    self.topicL.frame = CGRectMake(0, 0, GET_STRWIDTH(topicM.name, 11, 24)+30, 24);
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
