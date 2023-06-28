//
//  NoticeSayToSelf.h
//  NoticeXi
//
//  Created by li lei on 2019/7/9.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSayToSelf : NSObject
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSString *note_len;
@property (nonatomic, strong) NSString *note_url;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *noteId;
@property (nonatomic, strong) NSString *deleteId;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSString *nowTime;

@property (nonatomic, strong) NSString *dialog_id;
@property (nonatomic, strong) NSString *source_type;
@end

NS_ASSUME_NONNULL_END
