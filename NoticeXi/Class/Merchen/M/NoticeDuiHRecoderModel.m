//
//  NoticeDuiHRecoderModel.m
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDuiHRecoderModel.h"

@implementation NoticeDuiHRecoderModel

- (void)setCreated_at:(NSString *)created_at{
   _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"MM-dd HH:mm"];
}

@end
