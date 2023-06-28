//
//  NoticeHelpListCell.m
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpListCell.h"
#import "NoticeXi-Swift.h"
@implementation NoticeHelpListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20,15, DR_SCREEN_WIDTH-40, 0)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.hotImageVuew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [self.backView addSubview:self.hotImageVuew];
        self.hotImageVuew.image = UIImageNamed(@"hothelpimg");
        self.hotImageVuew.hidden = YES;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.backView.frame.size.width-20, 25)];
        self.titleL.font = XGEightBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.titleL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 48, self.backView.frame.size.width-30, 0)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.backView addSubview:self.contentL];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.contentL.frame), self.backView.frame.size.width-20, 40)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.backView addSubview:self.numL];
   
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,15, self.backView.frame.size.width-20, 17)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.backView addSubview:self.timeL];
        self.timeL.hidden = YES;
        
        self.contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.3;
        [self.contentView addGestureRecognizer:longPressDeleT];
    }
    return self;
}

- (void)setHelpModel:(NoticeHelpListModel *)helpModel{
    _helpModel = helpModel;
    
    if (self.isMine) {
        helpModel.isHot = NO;
        self.timeL.hidden = NO;
        self.timeL.text = helpModel.created_at;
    }else{
        self.timeL.hidden = YES;
    }
    self.hotImageVuew.hidden = helpModel.isHot?NO:YES;
    
    self.backView.frame = CGRectMake(20, 15, DR_SCREEN_WIDTH-40, (helpModel.isMoreFiveLines?helpModel.fiveTextHeight: helpModel.textHeight)+48+40+ (helpModel.isHot?30:0)+(self.isMine?32:0));
    self.contentL.frame = CGRectMake(15, 48+ (helpModel.isHot?30:0)+(self.isMine?32:0), self.backView.frame.size.width-30, (helpModel.isMoreFiveLines?helpModel.fiveTextHeight:helpModel.textHeight));
    self.numL.frame = CGRectMake(15,CGRectGetMaxY(self.contentL.frame), self.backView.frame.size.width-20, 40);
    self.titleL.frame = CGRectMake(15, 15+ (helpModel.isHot?30:0)+(self.isMine?32:0), self.backView.frame.size.width-20, 25);
    self.titleL.text = helpModel.title;
    self.contentL.attributedText = helpModel.isMoreFiveLines?helpModel.fiveAttTextStr: helpModel.allTextAttStr;
    if ([NoticeTools getLocalType]==1) {
        self.numL.text = [NSString stringWithFormat:@"%@ comments",helpModel.reply_num];
    }else if ([NoticeTools getLocalType]==2){
        self.numL.text = [NSString stringWithFormat:@"%@個の提案",helpModel.reply_num];
    }else{
        self.numL.text = [NSString stringWithFormat:@"%@个建议",helpModel.reply_num];
    }
    
    if (!(helpModel.reply_num.intValue > 0)) {
        self.numL.text = [NoticeTools getLocalStrWith:@"help.nojinayi"];
    }
}


- (void)deleTapT:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        if(![self.helpModel.userM.userId isEqualToString:[NoticeTools getuserId]]){
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"],self.helpModel.is_dislike.boolValue?[NoticeTools chinese:@"恢复帖子" english:@"Like again" japan:@"解除"]: [NoticeTools chinese:@"不喜欢此帖子" english:@"Unlike" japan:@"非表示"]]];
            sheet.delegate = self;
            [sheet show];
          
        }
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
        juBaoView.reouceId = self.helpModel.tieId;
        juBaoView.reouceType = @"141";
        [juBaoView showView];
    }else if (buttonIndex == 2){
        if (self.noLikeBlock) {
            self.noLikeBlock(self.helpModel);
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
