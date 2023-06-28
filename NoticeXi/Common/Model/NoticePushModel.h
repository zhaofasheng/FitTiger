//
//  NoticePushModel.h
//  NoticeXi
//
//  Created by li lei on 2021/12/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePushModel : NSObject

@property (nonatomic, strong) NSString *push_type;//10 私聊 7悄悄话 24涂鸦
@property (nonatomic, strong) NSString *push_user_id;
@property (nonatomic, strong) NSString *push_voice_id;
@property (nonatomic, strong) NSString *push_user_nick_name;
@property (nonatomic, strong) NSString *push_user_level;
@property (nonatomic, strong) NSString *push_line_id;
@property (nonatomic, strong) NSString *push_dubbing_id;
@property (nonatomic, strong) NSString *push_artwork_id;
@property (nonatomic, strong) NSString *push_about_id;

@end

NS_ASSUME_NONNULL_END
