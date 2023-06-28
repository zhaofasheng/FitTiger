//
//  NoticeChangeTextView.m
//  NoticeXi
//
//  Created by li lei on 2020/12/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeTextView.h"

@implementation NoticeChangeTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissView)];
        [self addGestureRecognizer:tap];
        
        self.textL = [[UILabel alloc] init];
        self.textL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.textL.textAlignment = NSTextAlignmentCenter;
        self.textL.font = SIXTEENTEXTFONTSIZE;
        
        
        self.alertView = [[UIScrollView alloc] init];
        self.alertView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        self.alertView.layer.position = CGPointMake(self.center.x, self.center.y);
        [self addSubview:self.alertView];
        
        [self.alertView addSubview:self.textL];
    }
    return self;
}

- (void)dissView{
    [self removeFromSuperview];
}

- (void)showManagerView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)setVoiceContent:(NSString *)voiceContent{
    _voiceContent = voiceContent;
    if (!voiceContent) {
        return;
    }
    self.alertView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH,[self getSpaceLabelHeight:voiceContent withFont:SIXTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-60]+60);
    self.textL.frame = CGRectMake(30, 30, DR_SCREEN_WIDTH-60, [self getSpaceLabelHeight:voiceContent withFont:SIXTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-60]);
    self.textL.attributedText = [self setLabelSpacewithValue:voiceContent withFont:SIXTEENTEXTFONTSIZE];
    if (self.alertView.frame.size.height > DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT) {
        self.alertView.frame = CGRectMake(0,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT- STATUS_BAR_HEIGHT);
    }
    self.alertView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, self.textL.frame.size.height);
    
    self.alertView.center = self.center;
    self.textL.numberOfLines = 0;
    [self showManagerView];
}

//返回文案
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

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
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
@end
