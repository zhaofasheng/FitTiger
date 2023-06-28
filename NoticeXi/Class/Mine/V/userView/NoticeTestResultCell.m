//
//  NoticeTestResultCell.m
//  NoticeXi
//
//  Created by li lei on 2021/5/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTestResultCell.h"

@implementation NoticeTestResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        self.userInteractionEnabled = YES;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 68)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        [self.contentView addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.backView.frame.size.width-20, 60)];
        self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleL.font = SIXTEENTEXTFONTSIZE;
        [self.backView addSubview:self.titleL];
        
        self.labelArr = [NSMutableArray new];
        for (int i = 0; i < 4; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 60+60*i, self.backView.frame.size.width-40, 48)];
            label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            label.font = FIFTHTEENTEXTFONTSIZE;
            label.layer.cornerRadius = 8;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
            [self.backView addSubview:label];
            label.tag = i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap:)];
            [label addGestureRecognizer:tap];
            if (i == 0) {
                self.choiceAL = label;
            }else if (i == 1){
                self.choiceBL = label;
            }else if (i == 2){
                self.choiceCL = label;
            }else if (i == 3){
                self.choiceDL = label;
            }
            [self.labelArr addObject:label];
        }
    }
    return self;
}

- (UIImageView *)sameImageView{
    if (!_sameImageView) {
        _sameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self.backView addSubview:_sameImageView];
        _sameImageView.hidden = YES;
        _sameImageView.image = UIImageNamed([NoticeTools getLocalType]?@"Image_sametesten":@"Image_sametest");
    }
    return _sameImageView;
}

- (void)choiceTap:(UITapGestureRecognizer *)tap{
    if (self.noTap) {
        return;
    }
    UILabel *tapV = (UILabel *)tap.view;
    _testM.choiceTag = tapV.tag;
    if (tapV.tag == 0) {
        _testM.choiceName = @"A";
    }else if(tapV.tag == 1){
        _testM.choiceName = @"B";
    }else if(tapV.tag == 2){
        _testM.choiceName = @"C";
    }else if(tapV.tag == 3){
        _testM.choiceName = @"D";
    }
    
    for (UILabel *label in self.labelArr) {
        if (label.tag == tapV.tag) {
            label.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            label.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        }else{
            label.backgroundColor = self.backView.backgroundColor;
            label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            label.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
        }
    }
    if (self.choiceBlock) {
        self.choiceBlock(_testM);
    }
}

- (void)setTestM:(NoticePsyModel *)testM{
    _testM = testM;
    
    self.titleL.text = testM.title;
    
    for (UILabel * label in self.labelArr) {
        label.hidden = YES;
    }
    
    for (int i = 0; i < testM.answers.count; i++) {
        if (i == 0) {
            self.choiceAL.text = [NSString stringWithFormat:@"   A %@",testM.answers[0]];
            self.choiceAL.hidden = NO;
        }else if(i == 1){
            self.choiceBL.text = [NSString stringWithFormat:@"   B %@",testM.answers[1]];
            self.choiceBL.hidden = NO;
        }else if(i == 2){
            self.choiceCL.text = [NSString stringWithFormat:@"   C %@",testM.answers[2]];
            self.choiceCL.hidden = NO;
        }else if(i == 3){
            self.choiceDL.text = [NSString stringWithFormat:@"   D %@",testM.answers[3]];
            self.choiceDL.hidden = NO;
        }
    }
    _sameImageView.hidden = YES;
    for (UILabel *label in self.labelArr) {
        if (label.tag == testM.choiceTag) {
            if (testM.sameAnswer) {
                label.backgroundColor = [UIColor colorWithHexString:@"#A361F2"];
                label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                label.layer.borderColor = [UIColor colorWithHexString:@"#A361F2"].CGColor;
                self.sameImageView.hidden = NO;
                self.sameImageView.frame = CGRectMake(label.frame.origin.x-13, label.frame.origin.y-10, 26, 26);
            }else{
                label.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                label.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
            }
       
        }else{
            label.backgroundColor = self.backView.backgroundColor;
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            label.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        }
    }
    self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 68+testM.answers.count*60);
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
