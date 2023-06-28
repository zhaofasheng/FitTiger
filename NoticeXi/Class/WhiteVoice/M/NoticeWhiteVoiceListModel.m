//
//  NoticeWhiteVoiceListModel.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteVoiceListModel.h"

@implementation NoticeWhiteVoiceListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cardId":@"id"};
}

- (void)setCard_intro:(NSString *)card_intro{
    _card_intro = [card_intro stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (void)setCard_url:(NSString *)card_url{
    _card_url = card_url;
    
    NSArray *arr =  [card_url componentsSeparatedByString:@"_"];
    if (arr.count == 4) {
        self.backColor = [NSString stringWithFormat:@"#%@",arr[1]];
        self.textColor = [NSString stringWithFormat:@"#%@",arr[2]];
    }
}
@end
