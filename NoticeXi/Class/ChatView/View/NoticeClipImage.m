//
//  NoticeClipImage.m
//  NoticeXi
//
//  Created by li lei on 2020/7/17.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeClipImage.h"

@implementation NoticeClipImage

+ (UIImage *)clipImageWithText:(NSString *)text fromName:(NSString *)fromName toName:(nonnull NSString *)toName{
    if (!text.length) {
        return nil;
    }
    NSDate * nowDate = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSArray * weekTitleArray = [NoticeTools getLocalType]?@[@"Sun",@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat"] : @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    
    //去除没有文字的换行符
    NSArray * array = [text componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        if ([array[i] length]) {
            [newArr addObject:array[i]];
        }
    }
    NSString *newText  = [newArr componentsJoinedByString:@"\n"];
    
    //富文本文案
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:SIXTEENTEXTFONTSIZE, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:newText attributes:dic];
        
    //文笔高度
    CGSize size = [newText boundingRectWithSize:CGSizeMake(DR_SCREEN_WIDTH-30,9999999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGFloat minTextHeight = DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-44-60-60;
    
    CGFloat viewHeght = DR_SCREEN_HEIGHT;
    if (size.height < minTextHeight) {
        viewHeght = DR_SCREEN_HEIGHT;
    }else{
        viewHeght = STATUS_BAR_HEIGHT+44+60+60+size.height;
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, viewHeght)];
    
    UIImageView *backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    backImageV.image = UIImageNamed(@"Image_xinfengback");
    [view addSubview:backImageV];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,STATUS_BAR_HEIGHT, 32, 32)];
    titleImageView.image = UIImageNamed(@"Image_sendxin_b");
    [view addSubview:titleImageView];
    view.backgroundColor = [NoticeTools getWhiteColor:@"#FFFCF0" NightColor:@"#222238"];
        
    UILabel *toNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame)+11, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-30-15-15-11, 32)];
    toNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    toNameL.font = XGTwentyBoldFontSize;
    toNameL.text = [NSString stringWithFormat:@"to %@：",toName];
    [view addSubview:toNameL];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(toNameL.frame)+6, DR_SCREEN_WIDTH-10-CGRectGetMaxX(titleImageView.frame)-11, 20)];
    label.text =[NSString stringWithFormat:@"%@  %@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyy-MM-dd HH:mm"],weekTitleArray[[dateComponent weekday] - 1]];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
    [view addSubview:label];
        
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+30, DR_SCREEN_WIDTH-30, 0.5)];
    line.backgroundColor = [[UIColor colorWithHexString:@"#EBECF0"] colorWithAlphaComponent:0.1];
    [view addSubview:line];
    
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame)+15, DR_SCREEN_WIDTH-30, size.height)];
    textL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    textL.font = SIXTEENTEXTFONTSIZE;
    textL.numberOfLines = 0;
    textL.attributedText = attributeStr;
    [view addSubview:textL];
    
    UILabel *fromL = [[UILabel alloc] initWithFrame:CGRectMake(15,viewHeght-60, DR_SCREEN_WIDTH-30, 60)];
    fromL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    fromL.font = SIXTEENTEXTFONTSIZE;
    fromL.textAlignment = NSTextAlignmentRight;
    fromL.text = [NSString stringWithFormat:@"From  %@",fromName];
    [view addSubview:fromL];
    
    //第一个参数表示区域大小 第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    CGSize size1 = CGSizeMake(view.layer.bounds.size.width,view.layer.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size1, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
