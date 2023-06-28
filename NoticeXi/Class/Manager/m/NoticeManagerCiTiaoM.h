//
//  NoticeManagerCiTiaoM.h
//  NoticeXi
//
//  Created by li lei on 2019/9/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerCiTiaoM : NSObject
@property (nonatomic, strong) NSString *ciId;
@property (nonatomic, strong) NSDictionary *resource_detail;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *user_id;//词条创建者id
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) BOOL hasRead;
@property (nonatomic, strong) NSString *pointValue;
@end

NS_ASSUME_NONNULL_END
