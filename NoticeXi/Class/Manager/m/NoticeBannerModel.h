//
//  NoticeBannerModel.h
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBannerModel : NSObject
@property (nonatomic, strong) NSString *bannerId;
@property (nonatomic, strong) NSString *started_at;
@property (nonatomic, strong) NSString *title_image_url;
@property (nonatomic, strong) NSString *content_image_url;
@property (nonatomic, strong) NSString *is_like;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *article_status;
@property (nonatomic, strong) NSString *http_attr_pc;
@property (nonatomic, strong) NSString *taketed_at;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *showTimeMD;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *read_num;
@property (nonatomic, strong) NSString *cover_url;
@end

NS_ASSUME_NONNULL_END
