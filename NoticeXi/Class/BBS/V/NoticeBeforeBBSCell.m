//
//  NoticeBeforeBBSCell.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBeforeBBSCell.h"

@implementation NoticeBeforeBBSCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 120, DR_SCREEN_WIDTH, 8)];
        self.line.backgroundColor = GetColorWithName(VBigLineColor);
        [self.contentView addSubview:self.line];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 70)];
        view.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#222238"];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, DR_SCREEN_WIDTH-30-60, 70)];
        self.titleL.font = [UIFont systemFontOfSize:16];
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.numberOfLines = 1;
        [view addSubview:self.titleL];
        self.titleL.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#222238"];
        self.titleL.layer.cornerRadius = 5;
        self.titleL.layer.masksToBounds = YES;
        
        UIImageView *markImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 24)];
        markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_bbsmark_b":@"Image_bbsmark_y");
        [view addSubview:markImage];
        
        self.comNumL = [[UILabel alloc] initWithFrame:CGRectMake(15,90, DR_SCREEN_WIDTH-30, 30)];
        self.comNumL.textColor = GetColorWithName(VMainThumeColor);
        self.comNumL.font = TWOTEXTFONTSIZE;
        self.comNumL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.comNumL];
    }
    return self;
}

- (void)setBbsModel:(NoticeBBSModel *)bbsModel{
    _bbsModel = bbsModel;
    self.titleL.text = bbsModel.title;
    self.comNumL.text = [NSString stringWithFormat:@"%@条留言>>",bbsModel.comment_num];
    if (GET_STRWIDTH(bbsModel.title, 16, 70) > self.titleL.frame.size.width) {
        self.titleL.adjustsFontSizeToFitWidth = YES;
    }else{
        self.titleL.font = [UIFont systemFontOfSize:16];
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
