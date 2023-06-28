//
//  DRPsyCell.m
//  NoticeXi
//
//  Created by li lei on 2019/1/22.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "DRPsyCell.h"

@implementation DRPsyCell
{
    UILabel *_titleL;
    NSMutableArray *_buttonArr;
    NSMutableArray *_labelArr;
    UILabel *_pageL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 100)];
        topBackView.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        [self.contentView addSubview:topBackView];
        topBackView.layer.cornerRadius = 15;
        topBackView.layer.masksToBounds = YES;
        
        UIView *bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(20,DR_SCREEN_HEIGHT < 667 ? (446-80-100) : 446-100, DR_SCREEN_WIDTH-40, 100)];
        bottomBackView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        [self.contentView addSubview:bottomBackView];
        bottomBackView.layer.cornerRadius = 15;
        bottomBackView.layer.masksToBounds = YES;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT < 667 ? 65 : 75, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT < 667 ? (446-80-65-61) : (446-75-66))];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        [self.contentView addSubview:contentView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_HEIGHT < 667 ? 10 : 20, 0, DR_SCREEN_WIDTH- (DR_SCREEN_HEIGHT < 667 ? 60 : 80), DR_SCREEN_HEIGHT < 667 ? 65 : 75)];
        _titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleL.font = SIXTEENTEXTFONTSIZE;
        _titleL.numberOfLines = 2;
        _titleL.textAlignment = NSTextAlignmentCenter;
        [topBackView addSubview:_titleL];
        
        _buttonArr = [NSMutableArray new];
        _labelArr = [NSMutableArray new];
        for (int i = 0; i < 4; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_HEIGHT < 667 ? 15 : 20, (DR_SCREEN_HEIGHT < 667 ? 30 : 40) + ((DR_SCREEN_HEIGHT < 667 ? 45 : 55)+(DR_SCREEN_HEIGHT < 667 ? 10 : 15))*i, DR_SCREEN_HEIGHT < 667 ? (DR_SCREEN_WIDTH-30-40):(DR_SCREEN_WIDTH-40-40), DR_SCREEN_HEIGHT < 667 ? 45 : 55)];
            button.tag = i;
            button.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
            button.layer.cornerRadius = 10;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(choiceQues:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:button];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_HEIGHT < 667 ? 0 : 20, 0, button.frame.size.width - (DR_SCREEN_HEIGHT < 667 ? 0 : 40), button.frame.size.height)];
            label.numberOfLines = 0;
            label.font = DR_SCREEN_HEIGHT < 667 ? THRETEENTEXTFONTSIZE : FOURTHTEENTEXTFONTSIZE;
            label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [button addSubview:label];
            [_labelArr addObject:label];
            [_buttonArr addObject:button];
        }
        
        _pageL = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomBackView.frame.size.height-30, bottomBackView.frame.size.width, 15)];
        _pageL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _pageL.textAlignment = NSTextAlignmentCenter;
        _pageL.font = FIFTHTEENTEXTFONTSIZE;
        [bottomBackView addSubview:_pageL];
    }
    
    return self;
}

- (void)choiceQues:(UIButton *)button{
    _psyM.choiceTag = button.tag;
    if (button.tag == 0) {
        _psyM.choiceName = @"A";
    }else if(button.tag == 1){
        _psyM.choiceName = @"B";
    }else if(button.tag == 2){
        _psyM.choiceName = @"C";
    }else if(button.tag == 3){
        _psyM.choiceName = @"D";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceModel:)]) {
        [self.delegate choiceModel:_psyM];
    }
}

- (void)setPsyM:(NoticePsyModel *)psyM{
    _psyM = psyM;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:psyM.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [psyM.title length])];
    _titleL.attributedText = attributedString;
    _titleL.textAlignment = NSTextAlignmentCenter;
    
    for (UIButton *button in _buttonArr) {
        if (button.tag > psyM.answers.count-1) {
            button.hidden = YES;
        }else{
            button.hidden = NO;
        }
    }
    
    for (int i = 0; i < psyM.answers.count; i++) {
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:psyM.answers[i]];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:4];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [psyM.answers[i] length])];
        UILabel *label = _labelArr[i];
        label.attributedText = attributedString1;
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton *btn = _buttonArr[i];
        if (psyM.choiceTag <= 3 && psyM.choiceTag >= 0) {
            if (btn.tag == psyM.choiceTag) {
                btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            }else{
                label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
                btn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
            }
        }else{
            label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            btn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        }
    }
    _pageL.text = [NSString stringWithFormat:@"%d/%ld",psyM.tag.intValue+1,[[NoticeTools getPsychologyArrary] count]];
}

@end
