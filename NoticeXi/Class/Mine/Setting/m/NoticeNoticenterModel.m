//
//  NoticeNoticenterModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNoticenterModel.h"

@implementation NoticeNoticenterModel

- (void)setChat_with:(NSString *)chat_with{
    _chat_with = chat_with;
    if ([_chat_with isEqualToString:@"0"]) {
        self.chantWithName = Localized(@"privacy.all");
    }else{
        self.chantWithName = Localized(@"privacy.limit");
    }
}

- (void)setChat_pri_with:(NSString *)chat_pri_with{
    _chat_pri_with = chat_pri_with;
    if ([_chat_pri_with isEqualToString:@"0"]) {
        self.chantPriWithName = Localized(@"privacy.all");
    }else{
        self.chantPriWithName = Localized(@"privacy.limit");
    }
}

- (void)setGps_switch:(NSString *)gps_switch{
    _gps_switch = gps_switch;
    if ([_gps_switch isEqualToString:@"0"]) {
        self.ditanceName = Localized(@"privacy.close");
    }else{
        self.ditanceName = Localized(@"privacy.open");
    }
}

- (void)setStrange_view:(NSString *)strange_view{
    _strange_view = strange_view;
    if ([_strange_view isEqualToString:@"0"]) {
        self.lookWithName = Localized(@"privacy.no");
    }else if ([_strange_view isEqualToString:@"7"]){
        self.lookWithName = Localized(@"privacy.seven");
    }else if ([_strange_view isEqualToString:@"30"]){
        self.lookWithName = @"最近30天";
    }else{
        self.lookWithName = [NoticeTools getLocalStrWith:@"py.allPy"];
    }
}

- (void)setDisplay_same_topic:(NSString *)display_same_topic{
    _display_same_topic = display_same_topic;
    if ([display_same_topic isEqualToString:@"1"]) {
        self.displayName = [NoticeTools isSimpleLau]? @"显示":@"顯示";
    }else{
        self.displayName = [NoticeTools isSimpleLau]? @"隐藏":@"隱藏";
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"newfriend_remind":@"new_friend_remind"};
}
@end
