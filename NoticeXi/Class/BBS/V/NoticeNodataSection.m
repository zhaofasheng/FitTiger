//
//  NoticeNodataSection.m
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeNodataSection.h"

@implementation NoticeNodataSection

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        
        UILabel *lyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,DR_SCREEN_WIDTH, 15)];
        lyLabel.text = [NoticeTools getTextWithSim:@"还没有留言，点击这里成为第一个留言者" fantText:@"還沒有留言，點擊這裏成為第壹個留言者"];
        lyLabel.font = FIFTHTEENTEXTFONTSIZE;
        lyLabel.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3e3e4a"];
        lyLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lyLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(lyLabel.frame)+5, DR_SCREEN_WIDTH-80, 40)];
        [btn setTitle:[NoticeTools chinese:@"查看帖子详情>" english:@"Read More >" japan:@"ポストを見る >"] forState:UIControlStateNormal];
        [btn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:btn];
        btn.enabled = NO;
        
        //[btn addTarget:self action:@selector(detaliClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
