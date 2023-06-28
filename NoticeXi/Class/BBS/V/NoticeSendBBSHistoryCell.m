//
//  NoticeSendBBSHistoryCell.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendBBSHistoryCell.h"

@implementation NoticeSendBBSHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.userInteractionEnabled = YES;
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 8)];
        self.line.backgroundColor = GetColorWithName(VBigLineColor);
        [self.contentView addSubview:self.line];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,23,65, 13)];
        _timeL.font = THRETEENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_timeL];
        
        _dateL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_timeL.frame)+10,65, 11)];
        _dateL.font = ELEVENTEXTFONTSIZE;
        _dateL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_dateL];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame)+10,14+8,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-10-15, 17)];
        _titleL.font = XGFifthBoldFontSize;
        _titleL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_titleL];
        
        self.contentTextL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame)+10,_dateL.frame.origin.y,DR_SCREEN_WIDTH-110, 13)];
        self.contentTextL.textColor = GetColorWithName(VMainTextColor);
        self.contentTextL.font = THRETEENTEXTFONTSIZE;
        self.contentTextL.numberOfLines = 0;
        [self.contentView addSubview:self.contentTextL];
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.contentTextL.frame)+15, DR_SCREEN_WIDTH, 0)];
        [self.contentView addSubview:self.imageViewS];
    
        UILongPressGestureRecognizer *longPressDeleT1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT1.minimumPressDuration = 0.3;
        [self.contentView addGestureRecognizer:longPressDeleT1];
        
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-102, 10, 102, 49)];
        self.markImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_usebbsmark_b":@"Image_usebbsmark_y");
        [self.contentView addSubview:self.markImageView];
        self.markImageView.hidden = YES;
    }
    return self;
}

- (void)deleTapT:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        sheet.delegate = self;
        [sheet show];
    }
}


- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除该稿子吗?" message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                if (weakSelf.deleteBlock) {
                    weakSelf.deleteBlock(weakSelf.bbsModel);
                }
            }
        };
        [alerView showXLAlertView];

    }
}

- (void)setBbsModel:(NoticeBBSModel *)bbsModel{
    _bbsModel = bbsModel;
    _dateL.text = bbsModel.year;
    _timeL.text = bbsModel.day;
    if (bbsModel.twoLineHeight >= 13) {
        self.contentTextL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+10,_dateL.frame.origin.y,DR_SCREEN_WIDTH-110,bbsModel.twoLineHeight);
        self.contentTextL.attributedText = bbsModel.twoTextAttStr;
    }else{
        self.contentTextL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+10,_dateL.frame.origin.y,DR_SCREEN_WIDTH-110, 13);
        self.contentTextL.text = bbsModel.textContent;
    }
    self.titleL.text = bbsModel.title;
    self.contentTextL.numberOfLines = 0;
    
    self.imageViewS.hidden = bbsModel.imgListArr.count?NO:YES;

    self.imageViewS.frame = CGRectMake(0,CGRectGetMaxY(self.contentTextL.frame)+15, DR_SCREEN_WIDTH, bbsModel.imgHeight-15);
    self.imageViewS.imgArr = bbsModel.imgListArr;
    
    self.markImageView.hidden = bbsModel.post_id.intValue?NO:YES;
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
