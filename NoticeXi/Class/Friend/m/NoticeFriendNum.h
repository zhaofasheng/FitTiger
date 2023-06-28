//
//  NoticeFriendNum.h
//  NoticeXi
//
//  Created by li lei on 2019/3/6.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeFriendNum : NSObject

@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *self_intro;
@property (nonatomic, strong) NSString *wave_url;
@property (nonatomic, strong) NSString *wave_len;
@property (nonatomic, strong) NSString *friend_num;
@property (nonatomic, strong) NSString *friend_card_url;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSString *paiHang;
@property (nonatomic, strong) NSString *yushu;//也是利用这个求余数
@property (nonatomic, strong) NSString *is_on;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) UIImage *cardImage;
@property (nonatomic, strong) NSString *friend_status;//学友关系，1:待验证，2:已经是学友，其他情况不返回该key
@property (nonatomic, strong) NSString *song_num;
@end

NS_ASSUME_NONNULL_END
