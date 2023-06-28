//
//  NoticeHelpListModel.m
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpListModel.h"

@implementation NoticeHelpListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tieId":@"id"};
}

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.userM = [NoticeAbout mj_objectWithKeyValues:user_info];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.allTextAttStr = [NoticeTools getStringWithLineHight:4 string:content];
    self.textHeight = [NoticeTools getHeightWithLineHight:4 font:15 width:DR_SCREEN_WIDTH-70 string:content];
    self.allTextHeight = [NoticeTools getHeightWithLineHight:4 font:15 width:DR_SCREEN_WIDTH-40 string:content];
    if (self.textHeight > 100) {
        self.textHeight = 100;
    }
    
    NSArray * array = [content componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {

        [newArr addObject:array[i]];
    }
    _content = [newArr componentsJoinedByString:@"\n"];
    
    if (content.length) {
        if ([[self getSeparatedLinesFromLabel:_content width:DR_SCREEN_WIDTH-70 font:FIFTHTEENTEXTFONTSIZE] count]> 5) {
            self.isMoreFiveLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:_content width:DR_SCREEN_WIDTH-70 font:FIFTHTEENTEXTFONTSIZE];
            NSString *line4String = array[4];
            
            if (line4String.length < 3) {
                line4String = [NSString stringWithFormat:@"%@...",line4String];
            }
            self.showText = [NSString stringWithFormat:@"%@%@%@%@%@...", array[0], array[1], array[2], array[3],[line4String substringToIndex:line4String.length-3]];
            
            self.fiveTextHeight = [NoticeTools getHeightWithLineHight:4 font:15 width:DR_SCREEN_WIDTH-70 string:self.showText];
        
            self.fiveAttTextStr = [NoticeTools getStringWithLineHight:4 string:self.showText];
        }else{
            self.isMoreFiveLines = NO;
        }
    }
}

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{

    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
}

- (void)setGiveData:(NSDictionary *)giveData{
    _giveData = giveData;
    self.giveModel = [NoticeAbout mj_objectWithKeyValues:giveData];
}

- (void)setGiveHotData:(NSDictionary *)giveHotData{
    _giveHotData = giveHotData;
    self.giveHotModel = [NoticeAbout mj_objectWithKeyValues:giveHotData];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd hh:mm:ss"];
}

@end
