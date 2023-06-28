//
//  NoticeYuSetModel.h
//  NoticeXi
//
//  Created by li lei on 2019/9/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeYuSetModel : NSObject

@property (nonatomic, strong) NSString *yuseId;
@property (nonatomic, strong) NSString *resource_type;//内容类型，1:语音，2:图片
@property (nonatomic, strong) NSString *resource_uri;//内容地址，相对地址
@property (nonatomic, strong) NSString *resource_len;//内容长度，音频长度0-120S，图片无长度,即为0
@property (nonatomic, strong) NSString *bucket_id;//存储节点ID
@property (nonatomic, strong) NSString *reply_remark;//回复备注
@property (nonatomic, strong) NSString *reply_sort;
@property (nonatomic, strong) NSString *resource_url;//内容地址，绝对地址
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) BOOL isTrueStr;
@end

NS_ASSUME_NONNULL_END
