//
//  NoticeReadEveryDayCell.m
//  NoticeXi
//
//  Created by li lei on 2021/6/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeReadEveryDayCell.h"

@implementation NoticeReadEveryDayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 200, 20)];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#DB9A58"];
        [self.contentView addSubview:self.markL];
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 41, 16, 16)];
        [self.contentView addSubview:self.titleImageView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame)+3, 41, 74, 16)];
        self.titleL.text = [NoticeTools getLocalStrWith:@"read.title"];
        self.titleL.font = SIXTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-150, 41, 150, 16)];
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.font = FOURTHTEENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#737780"];
        [self.contentView addSubview:self.timeL];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 71, DR_SCREEN_WIDTH-20-20-15-24, 32)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backV.layer.cornerRadius = 3;
        backV.layer.masksToBounds = YES;
        [self.contentView addSubview:backV];
        
        self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, 74, 24, 25)];
        [self.editButton setBackgroundImage:UIImageNamed(@"Image_dsrwbj") forState:UIControlStateNormal];
        [self.contentView addSubview:self.editButton];
        [self.editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, backV.frame.size.width-10, 32)];
        self.contentL.textColor = [UIColor colorWithHexString:@"#737780"];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        [backV addSubview:self.contentL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 117, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)editClick{
    
}

- (void)setBannerM:(NoticeBannerModel *)bannerM{
    _bannerM = bannerM;
    if (self.index == 0) {
        self.markL.hidden = YES;
        self.titleImageView.image = UIImageNamed(@"Image_dsrenwu1");
    }else{
        self.markL.hidden = NO;
        self.markL.text = [NSString stringWithFormat:@"定时任务%ld",self.index];
        self.titleImageView.image = UIImageNamed(@"Image_dsrenwu2");
    }
    self.timeL.text = bannerM.taketed_at;
    self.contentL.text = bannerM.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
