//
//  NoticeShopChatCommentCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopChatCommentCell.h"

@implementation NoticeShopChatCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 12, DR_SCREEN_WIDTH-30, 152)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        self.backV = backView;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
        self.iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
        [backView addSubview:self.iconImageView];
        
        self.scroeimageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-16-15-GET_STRWIDTH(@"太治愈了", 12, 17), 15, 16, 16)];
        self.scroeimageView.layer.cornerRadius = 10;
        self.scroeimageView.layer.masksToBounds = YES;
        [backView addSubview:self.scroeimageView];
        
        self.scoreL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-15-GET_STRWIDTH(@"太治愈了", 12, 17), 15, GET_STRWIDTH(@"太治愈了", 12, 17), 17)];
        self.scoreL.font = TWOTEXTFONTSIZE;
        self.scoreL.textColor = [UIColor colorWithHexString:@"#F29900"];
        [backView addSubview:self.scoreL];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, GET_STRWIDTH(@"太治愈了", 14, 20)+30, 20)];
        self.nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.nickNameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(55, 33, GET_STRWIDTH(@"2021-03-25 10:00:52", 14, 20)+30, 16)];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.timeL];
        
        self.labelL = [[UILabel alloc] init];
        self.labelL.numberOfLines = 0;
        self.labelL.font = ELEVENTEXTFONTSIZE;
        self.labelL.textColor = [UIColor colorWithHexString:@"#C2680E"];
        [backView addSubview:self.labelL];
        
        self.marksL = [[UILabel alloc] init];
        self.marksL.numberOfLines = 0;
        self.marksL.font = FOURTHTEENTEXTFONTSIZE;
        self.marksL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.marksL];
    }
    return self;
}

- (void)setCommentModel:(NoticeShopCommentModel *)commentModel{
    _commentModel = commentModel;
    
    self.nickNameL.text = [commentModel.user_id isEqualToString:[NoticeTools getuserId]]?@"我的评价":@"匿名评价";
    
    self.timeL.text = commentModel.created_at;
    
    NSString *imgName = [NSString stringWithFormat:@"goodcomimg_%d",commentModel.score.intValue-1];
    self.scroeimageView.image = UIImageNamed(imgName);
    
    if(self.isUserView){
        self.labelL.hidden = YES;
        self.backV.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 75+commentModel.marksHeight);
        self.marksL.frame = CGRectMake(15, 60, DR_SCREEN_WIDTH-60, commentModel.marksHeight);
    }else{
        self.labelL.hidden = commentModel.label_list.count? NO : YES;
        self.backV.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 75+commentModel.marksHeight+(commentModel.label_list.count?(commentModel.labelHeight+8):0));
        self.labelL.frame = CGRectMake(15, 60, DR_SCREEN_WIDTH-60, commentModel.labelHeight);
        self.labelL.attributedText = commentModel.labelAtt;
        self.marksL.frame = CGRectMake(15, 60+(commentModel.label_list.count?(8+commentModel.labelHeight):0), DR_SCREEN_WIDTH-60, commentModel.marksHeight);
    }
    self.marksL.attributedText = commentModel.marksAttTextStr;
    if(commentModel.score.intValue == 1){
        self.scoreL.text = @"太治愈了";
    }else if (commentModel.score.intValue == 2){
        self.scoreL.text = @"还可以啦";
    }else{
        self.scoreL.text = @"不太行噢";
    }
    
    if (self.isComDetail) {
        self.nickNameL.frame = CGRectMake(55, 16, GET_STRWIDTH(@"太治愈了", 14, 20)+30, 22);
        self.nickNameL.font = XGSIXBoldFontSize;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.backV.frame = CGRectMake(15,0,DR_SCREEN_WIDTH-30, 75+commentModel.marksHeight+(commentModel.label_list.count?(commentModel.labelHeight+8):0)+30);
        self.timeL.frame = CGRectMake(15, self.backV.frame.size.height-33, GET_STRWIDTH(@"2021-03-25 10:00:52", 14, 20)+30, 17);
        self.nickNameL.text = [commentModel.user_id isEqualToString:[NoticeTools getuserId]]?@"我的评价":@"买家评价";
        if(self.needDelete){
            self.deleteButton.frame = CGRectMake(self.backV.frame.size.width-35, self.backV.frame.size.height-35, 20, 20);
            self.deleteButton.hidden = NO;
        }else{
            _deleteButton.hidden = YES;
        }
    }
}

- (void)deleteClick{
    if (self.deleteSureBlock) {
        self.deleteSureBlock(self.commentModel);
    }
}

- (UIButton *)deleteButton{
    if(!_deleteButton){
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.backV.frame.size.width-35, self.backV.frame.size.height-35, 20, 20)];
        [_deleteButton setImage:UIImageNamed(@"shopdeletecom") forState:UIControlStateNormal];
        [self.backV addSubview:_deleteButton];
        [_deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
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
