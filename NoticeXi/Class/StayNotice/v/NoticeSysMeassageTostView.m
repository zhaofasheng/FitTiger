//
//  NoticeSysMeassageTostView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSysMeassageTostView.h"

@implementation NoticeSysMeassageTostView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(26, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH-26*2,450)];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        self.contentView = contentView;
        contentView.center = self.center;
        [self addSubview:contentView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+26,contentView.frame.origin.y-76/2, 76, 76)];
        imageView.image = UIImageNamed(@"Img_sxhuodong");
        [self addSubview:imageView];
        _logoImageView = imageView;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, contentView.frame.size.width-30, 28)];
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.titleL.font = XGEightBoldFontSize;
        [contentView addSubview:self.titleL];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleL.frame)+10, (contentView.frame.size.width-40)/2, 17)];
        self.typeL.font = TWOTEXTFONTSIZE;
        self.typeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.typeL.text = [NoticeTools getLocalStrWith:@"system.mark"];
        [self.contentView addSubview:self.typeL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeL.frame), self.typeL.frame.origin.y, self.typeL.frame.size.width, 17)];
        self.timeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.timeL.frame)+9, contentView.frame.size.width-40, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:line];
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-45-1, self.contentView.frame.size.width, 1)];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.bottomLine];
        
        self.bottomL = [[UILabel alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height-45, self.contentView.frame.size.width-20, 45)];
        self.bottomL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.bottomL.font = XGSIXBoldFontSize;
        self.bottomL.text = [NoticeTools getLocalStrWith:@"sure.comgir"];
        [self.contentView addSubview:self.bottomL];
        
        self.bottomL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissTap)];
        [self.bottomL addGestureRecognizer:tap];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 120, self.contentView.frame.size.width-40, self.contentView.frame.size.height-120-55)];
        [self.contentView addSubview:self.scrollView];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width,0)];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.scrollView addSubview:self.contentL];
    }
    return self;
}

- (void)setMessage:(NoticeMessage *)message{
    if (message.type.intValue == 19) {
        self.bottomL.text = [NoticeTools getLocalStrWith:@"chat.close"];
        self.typeL.text = @"";
        _logoImageView.hidden = YES;
    }
    self.timeL.text = message.created_at;
    if (GET_STRWIDTH(message.title, 18, 28) > self.titleL.frame.size.width) {
        self.titleL.adjustsFontSizeToFitWidth = YES;
    }else{
        self.titleL.adjustsFontSizeToFitWidth = NO;
    }
    self.titleL.text = message.title;
    
    self.contentL.frame = CGRectMake(0, 0, self.scrollView.frame.size.width,[self getSpaceLabelHeight:message.content withFont:FOURTHTEENTEXTFONTSIZE withWidth:self.scrollView.frame.size.width]);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, [self getSpaceLabelHeight:message.content withFont:FOURTHTEENTEXTFONTSIZE withWidth:self.scrollView.frame.size.width]);
    self.contentL.attributedText = [self setLabelSpacewithValue:message.content withFont:FOURTHTEENTEXTFONTSIZE];
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;//设置行间距
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

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


- (void)dissTap{
    [self removeFromSuperview];
}


- (void)showActiveView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    } completion:^(BOOL finished) {
    }];
}
@end
