//
//  NoticeTopicCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTopicCell.h"
#import "DDHAttributedMode.h"
@implementation NoticeTopicCell
{
    UILabel *_mainL;
    UILabel *_numL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 55.5)];
        label.text = @"#";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = XGTwentyTwoBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:label];
        
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(80, 10,DR_SCREEN_WIDTH-80, 18)];
        _mainL.font = SIXTEENTEXTFONTSIZE;
        _mainL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_mainL ];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(80,CGRectGetMaxY(_mainL.frame)+10,DR_SCREEN_WIDTH-80, 16)];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        [self.contentView addSubview:_numL ];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80, 55.5, DR_SCREEN_WIDTH-80, 0.5)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        _line = line;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setTopicM:(NoticeTopicModel *)topicM{
    _topicM = topicM;
    if ([topicM.voice_num isEqualToString:@"0"] || topicM.voice_num.integerValue) {
        _numL.text = [NSString stringWithFormat:@"%@%@",self.isDraw?topicM.artwork_num : topicM.voice_num,self.isDraw?@"": [NoticeTools getLocalStrWith:@"yl.topics"]];
    }else{
        _numL.text = [NoticeTools getLocalStrWith:@"topic.makeNew"];
    }
    
    NSRange rang = [topicM.topic_name rangeOfString:topicM.keyTitle];
    if (rang.length) {
        _mainL.attributedText = [DDHAttributedMode setColorString:topicM.topic_name setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:topicM.keyTitle beginSize:rang.location];
    }else{
        _mainL.text = topicM.topic_name;
    }

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
