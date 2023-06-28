//
//  NoticeLabelAndSwitchCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLabelAndSwitchCell.h"
#import "MySwitch.h"

@interface NoticeLabelAndSwitchCell()<MySwitchDelegate>

@end

@implementation NoticeLabelAndSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,DR_SCREEN_WIDTH-15-15-54, 55)];
        _mainL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _mainL.font = XGFourthBoldFontSize;
        [self.contentView addSubview:_mainL];
        
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-18-44,14,44,24)];
        _switchButton.onTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _switchButton.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _switchButton.tintColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_switchButton addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchButton];
        _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _line = line;
        [self.contentView addSubview:line];
        
    }
    return self;
}

- (void)onStatusDelegate{
    if(_mySwitch.OnStatus){
        [_mySwitch setBackgroundImage:[UIImage imageNamed:@"Imageonset"]];
    }else{
        [_mySwitch setBackgroundImage:[UIImage imageNamed:@"Imageoffset"]];
    }
}
- (void)changeVale:(UISwitch *)switchbutton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceTag:withIsOn: section:)]) {
        [self.delegate choiceTag:self.choiceTag withIsOn:switchbutton.isOn section:self.choiceSection];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
