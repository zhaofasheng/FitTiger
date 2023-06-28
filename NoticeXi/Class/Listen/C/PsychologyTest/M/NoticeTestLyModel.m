//
//  NoticeTestLy.m
//  NoticeXi
//
//  Created by li lei on 2019/2/1.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTestLyModel.h"

@implementation NoticeTestLyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"lyId":@"id"};
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    self.attString = [NoticeTools getStringWithLineHight:4 string:content];
    self.cellHeight = [NoticeTools getHeightWithLineHight:4 font:12 width: DR_SCREEN_WIDTH-60-60-44 string:content];
}

- (void)setPersonality_no:(NSString *)personality_no{
    _personality_no = personality_no;
    if (_personality_no.length >= 4) {
        if ([[_personality_no substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"T"]) {
            self.isT = YES;
        }else{
            self.isT = NO;
        }
    }
}
@end
