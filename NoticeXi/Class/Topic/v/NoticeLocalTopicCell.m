//
//  NoticeLocalTopicCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLocalTopicCell.h"

@implementation NoticeLocalTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imgView.image = UIImageNamed(@"Image_zbtm");
        [self.contentView addSubview:imgView];
        
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(52,0,DR_SCREEN_WIDTH-52-44,43.5)];
        _mainL .font = SIXTEENTEXTFONTSIZE;
        _mainL .textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_mainL ];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-43.5, 0, 43.5, 43.5)];
        [button setImage:UIImageNamed(@"Image_cancellocaltm") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleHisClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20,43.5, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.1];
        _line = line;
        [self.contentView addSubview:line];
        
    }
    return self;
}

- (void)setTopicM:(NoticeTopicModel *)topicM{
    _mainL.text = [NSString stringWithFormat:@"#%@#",topicM.topic_name];
}

- (void)deleHisClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelHistoryTipicIn:)]) {
        [self.delegate cancelHistoryTipicIn:self.index];
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
