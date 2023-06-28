//
//  NoticeMovie.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMovie.h"
#import <CoreText/CoreText.h>
@implementation NoticeMovie

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"movieListId":@"id",@"editMovieType":@"movie_type"};
}

- (void)setMovie_poster:(NSString *)movie_poster{
    NSArray *arr = [movie_poster componentsSeparatedByString:@"?"];
    _movie_poster = arr[0];
}

- (void)setMovie_score:(NSString *)movie_score{
    _movie_score = [NSString stringWithFormat:@"%.1f",movie_score.floatValue/10];
}

- (void)setReleased_at:(NSString *)released_at{
    _released_at = released_at;
    if (_released_at.length == 10) {
        return;
    }
    if ([released_at isEqualToString:@"0"]) {
        _released_at = @"未知上映时间";
        self.releasedYear = @"未知上映时间";
    }else{
        _released_at = [NoticeTools timeDataAppointFormatterWithTime:released_at.integerValue appointStr:@"yyyy-MM-dd"];
        self.releasedYear = [NoticeTools timeDataAppointFormatterWithTime:released_at.integerValue appointStr:@"yyyy"];
    }
}

- (void)setReleased_date:(NSString *)released_date{
    _released_date = released_date;
    if (![_released_date isEqualToString:@"0000-00-00 00:00:00"] && _released_date.length > 10) {
        self.released_at = [_released_date substringToIndex:10];
        self.releasedYear = [_released_date substringToIndex:4];
    }
}

- (void)setMovie_area:(NSArray *)movie_area{
    _movie_area = movie_area;
    NSString *string = @"";
    for (int i = 0; i < movie_area.count; i++) {
        string =[NSString stringWithFormat:@"%@/%@",string, movie_area[i]];
    }
    if (string.length) {
       self.movieAdress = [string substringFromIndex:1];
    }
    
}

- (void)setMovie_starring:(NSArray *)movie_starring{
    _movie_starring = movie_starring;
    NSString *string = @"";
    for (int i = 0; i < movie_starring.count; i++) {
        string =[NSString stringWithFormat:@"%@/%@",string, movie_starring[i]];
    }
    if (string.length) {
        self.movieStar = [string substringFromIndex:1];
    }
}

- (void)setMovie_type:(NSArray *)movie_type{
    _movie_type = movie_type;
    
    NSString *string = @"";
    for (int i = 0; i < movie_type.count; i++) {
        string =[NSString stringWithFormat:@"%@ %@",string, movie_type[i]];
    }
    if (string.length) {
        self.movietype = [string substringFromIndex:1];
    }
}

- (void)setFirst_voice:(NSDictionary *)first_voice{
    _first_voice = first_voice;
    self.voiceM = [NoticeVoiceModel mj_objectWithKeyValues:first_voice];
}

- (void)setMovie_intro:(NSString *)movie_intro{

    NSArray * array = [movie_intro componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        if ([array[i] length]) {
            [newArr addObject:array[i]];
        }
    }
    
    _movie_intro = [newArr componentsJoinedByString:@"\n"];
    
    self.textHeight = [self getSpaceLabelHeight:_movie_intro withFont:THRETEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30-40];

    if (self.textHeight < 30) {
        self.textHeight = 30;
    }
  

    if (_movie_intro.length) {
        self.allTextAttStr = [self setLabelSpacewithValue:_movie_intro withFont:THRETEENTEXTFONTSIZE];
        if ([[self getSeparatedLinesFromLabel:_movie_intro width:DR_SCREEN_WIDTH-70 font:THRETEENTEXTFONTSIZE] count]> 3) {
            self.isMoreLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:_movie_intro width:DR_SCREEN_WIDTH-70 font:THRETEENTEXTFONTSIZE];

            NSString *showText = [NSString stringWithFormat:@"%@%@%@", array[0], array[1],array[2]];
            self.fiveTextHeight = [self getSpaceLabelHeight:showText withFont:THRETEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-70];
            
            self.fiveAttTextStr = [self setLabelSpacewithValue:showText withFont:THRETEENTEXTFONTSIZE];
        }else{
            self.isMoreLines = NO;
        }
    }
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

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{

    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
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

@end
