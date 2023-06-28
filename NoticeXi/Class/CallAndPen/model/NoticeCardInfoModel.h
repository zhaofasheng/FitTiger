//
//  NoticeCardInfoModel.h
//  NoticeXi
//
//  Created by li lei on 2020/10/29.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCardInfoModel : NSObject
@property (nonatomic, strong) NSString *card_title;
@property (nonatomic, strong) NSString *card_type;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NoticeAbout *userInfo;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *admired_id;//欣赏id

@end

NS_ASSUME_NONNULL_END
