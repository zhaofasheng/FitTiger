//
//  NoticeWeb.h
//  NoticeXi
//
//  Created by li lei on 2018/11/7.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeWeb : NSObject
@property (nonatomic, strong) NSString *banner_url;
@property (nonatomic, strong) NSString *newbanner_url;
@property (nonatomic, strong) NSString *html_content;
@property (nonatomic, strong) NSString *html_id;
@property (nonatomic, strong) NSString *html_title;//
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSString *html_type;
@property (nonatomic, strong) NSString *redirect_url;
@property (nonatomic, strong) NSString *released_at;

@property (nonatomic, strong) NSString *is_open;//是否开启留言

@property (nonatomic, strong) NSString *platform_id;
@property (nonatomic, strong) NSString *resource_content;
@property (nonatomic, strong) NSString *resource_name;
@property (nonatomic, strong) NSString *resource_status;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *jsonStr;

@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *is_new;
@end

NS_ASSUME_NONNULL_END
