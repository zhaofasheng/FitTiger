//
//  NoticeBBSheaderView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSheaderView.h"

@implementation NoticeBBSheaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [NoticeTools getWhiteColor:@"#FFCBAB" NightColor:@"#4B4C89"];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 90, 90)];
        titleImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_bbstitle_b":@"Image_bbstitle_y");
        [self addSubview:titleImageView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame)+15, 29, 300, 18)];
        titleL.font = SEVENTEENTEXTFONTSIZE;
        titleL.textColor = GetColorWithName(VMainThumeWhiteColor);
        titleL.text = [NoticeTools getTextWithSim:@"啊，啊囧又睡过头了" fantText:@"啊，啊囧又睡過頭了"];
        [self addSubview:titleL];
        self.titleLabel = titleL;
        
        UILabel *subL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame)+15, CGRectGetMaxY(titleL.frame)+10,DR_SCREEN_WIDTH-10-90-15-15,70)];
        subL.textColor = GetColorWithName(VMainThumeWhiteColor);
        subL.font = FOURTHTEENTEXTFONTSIZE;
        subL.attributedText = [self setLabelSpacewithValue:[NoticeTools getTextWithSim:@"每天下午6点更新一道啊囧的人生疑问句，啊囧有时会偷懒，万一到点儿没更新记得叫小二去打醒他" fantText:@"每天下午6點更新壹道啊囧的人生疑問句，啊囧有時會偷懶，萬壹到點兒沒更新記得叫小二去打醒他"] withFont:[UIFont systemFontOfSize:14]];
        [self addSubview:subL];
        subL.numberOfLines = 0;
    }
    return self;
}

-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}

@end
