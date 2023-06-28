//
//  NoticeUserQuestionCell.m
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserQuestionCell.h"

@implementation NoticeUserQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(60, 20,DR_SCREEN_WIDTH-60-10, 17)];
        _nickNameL.font = THRETEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:_nickNameL];

        //
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(60,CGRectGetMaxY(_nickNameL.frame)+5,DR_SCREEN_WIDTH-60-10, 18)];
        _infoL.font = FOURTHTEENTEXTFONTSIZE;
        _infoL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.contentView addSubview:_infoL];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 79)];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.textAlignment = NSTextAlignmentCenter;
        _numL.textColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:_numL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60, 79, DR_SCREEN_WIDTH-60, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setQuestionM:(NoticeUserQuestionModel *)questionM{
    _questionM = questionM;
    self.numL.text = questionM.msgM.supply;
    self.nickNameL.text = questionM.userM.nick_name;
    self.infoL.text = questionM.describe;
    if (self.needMark) {
        if (!questionM.read_at.intValue) {//未读
            NSString *str = [NSString stringWithFormat:@"(未读)%@",questionM.userM.nick_name];
            self.nickNameL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor redColor] setLengthString:@"(未读)" beginSize:0];
        }else if(questionM.sign.intValue){//已标记
            NSString *str = [NSString stringWithFormat:@"(已标记)%@",questionM.userM.nick_name];
            self.nickNameL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:@"(已标记)" beginSize:0];
        }
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
